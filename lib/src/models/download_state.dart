import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

const uuidGenerator = Uuid();

class DownloadState extends ChangeNotifier {
  // static final _ffmpeg = FlutterFFmpeg();

  final Dio _dio;
  final String downloadUrl;
  final String fileName;
  final String basePath;
  final String _uuid = uuidGenerator.v4();
  final DownloadType type;

  late final String _tempFolderPath;
  late final String _tempFilePath;
  late final String _downloadedFilePath;

  DownloadState(this._dio,
      {required this.basePath,
      required this.type,
      required this.downloadUrl,
      required this.fileName}) {
    _tempFolderPath = path.join(basePath, '.downloadCache');
    _tempFilePath = path.join(_tempFolderPath, _uuid + '.temp');
    _downloadedFilePath = path.join(basePath, isAudio ? 'Audio' : 'Video',
        fileName + (isAudio ? '.mp3' : '.mp4'));
  }

  bool get isVideo => type == DownloadType.video;
  bool get isAudio => type == DownloadType.audio;

  bool get isNotStarted => status == DownloadStatus.notStarted;
  bool get isActive => status == DownloadStatus.active;
  bool get isProcessing => status == DownloadStatus.processing;
  bool get isDone => status == DownloadStatus.done;

  CancelToken? _cancelToken;

  double progress = 0.0;
  DownloadStatus status = DownloadStatus.notStarted;
  dynamic data;

  Future<void> startDownload() async {
    if (status != DownloadStatus.notStarted) return;
    _cancelToken = CancelToken();

    status = DownloadStatus.active;
    notifyListeners();

    await File(_tempFilePath).create(recursive: true);

    var res = await _dio.download(
      downloadUrl,
      _tempFilePath,
      cancelToken: _cancelToken,
      onReceiveProgress: (count, total) {
        progress = (count / total) * 100;
        notifyListeners();
      },
    );

    status = DownloadStatus.processing;
    notifyListeners();

    await _ensureDownloadFolderIsCreated(basePath);
    if (type == DownloadType.audio) {
      await _transcodeAudio(_tempFilePath, _downloadedFilePath);
    } else {
      await _transcodeVideo(_tempFilePath, _downloadedFilePath);
    }

    try {
      File(_tempFilePath).deleteSync();
    } catch (_) {}

    status = DownloadStatus.done;

    data = res.data;

    notifyListeners();
  }

  Future<void> _ensureDownloadFolderIsCreated(String downloadFolderPath) async {
    await Directory(downloadFolderPath).create(recursive: true);
    await Directory(path.join(downloadFolderPath, "Audio"))
        .create(recursive: true);
    await Directory(path.join(downloadFolderPath, "Video"))
        .create(recursive: true);
  }

  Future<void> _transcodeAudio(
      String tempFilePath, String downloadedFilePath) async {
    // if (Platform.isAndroid || Platform.isIOS) {
    //   await DownloadState._ffmpeg.executeWithArguments([
    //     '-i',
    //     tempFilePath,
    //     '-vn',
    //     '-ab',
    //     '128k',
    //     '-ar',
    //     '44100',
    //     '-y',
    //     downloadedFilePath
    //   ]);
    // } else {
    //   await _transcodeNoop(tempFilePath, downloadedFilePath);
    // }
    await _transcodeNoop(tempFilePath, downloadedFilePath);
  }

  Future<void> _transcodeNoop(
      String tempFilePath, String downloadedFilePath) async {
    final file = File(tempFilePath);
    await file.copy(downloadedFilePath);
    try {
      await file.delete();
    } catch (_) {}
  }

  Future<void> _transcodeVideo(
      String tempFilePath, String downloadedFilePath) async {
    await _transcodeNoop(tempFilePath, downloadedFilePath);
    // await DownloadState._ffmpeg.executeWithArguments([
    //   '-i',
    //   tempFilePath,
    //   '-vn',
    //   '-ab',
    //   '128k',
    //   '-ar',
    //   '44100',
    //   '-y',
    //   downloadedFilePath
    // ]);
  }

  void cancelDownload() {
    _cancelToken?.cancel();
    progress = 0;
    status = DownloadStatus.cancelled;
  }
}

enum DownloadStatus { notStarted, pending, active, done, processing, cancelled }
enum DownloadType { video, audio }
