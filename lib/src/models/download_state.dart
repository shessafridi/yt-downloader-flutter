import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

const uuidGenerator = Uuid();

class DownloadState extends ChangeNotifier {
  static final _ffmpeg = FlutterFFmpeg();

  final Dio _dio;
  final String downloadUrl;
  final String fileName;
  final String uuid = uuidGenerator.v4();

  Future<String> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download/YouTubeDownloads/';
    }
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final dir = await getDownloadsDirectory();
      return dir!.path.toString();
    }

    throw UnsupportedError("Platform not supported");
  }

  DownloadState(this._dio, {required this.downloadUrl, required this.fileName});

  CancelToken? _cancelToken;

  double progress = 0.0;
  DownloadStatus status = DownloadStatus.notStarted;
  dynamic data;

  Future<void> startDownload() async {
    if (status != DownloadStatus.notStarted) return;
    _cancelToken = CancelToken();

    final basePath = await _getDownloadDirectory();
    final downloadFolderPath = basePath;

    final tempFolderPath = p.join(basePath, 'downloadCache');
    final tempFilePath = p.join(tempFolderPath, uuid + '.temp');
    final downloadedFilePath = p.join(basePath, fileName + '.mp3');

    status = DownloadStatus.active;
    notifyListeners();

    await File(tempFilePath).create(recursive: true);

    var res = await _dio.download(
      downloadUrl,
      tempFilePath,
      cancelToken: _cancelToken,
      onReceiveProgress: (count, total) {
        progress = (count / total) * 100;
        print(progress.toStringAsFixed(1) + '%');
        notifyListeners();
      },
    );

    status = DownloadStatus.processing;
    notifyListeners();

    await Directory(downloadFolderPath).create(recursive: true);
    await _encodeVideo(tempFilePath, downloadedFilePath);

    try {
      File(tempFilePath).deleteSync();
    } catch (e) {}

    status = DownloadStatus.done;

    data = res.data;

    notifyListeners();
  }

  Future<void> _encodeVideo(
      String tempFilePath, String downloadedFilePath) async {
    await DownloadState._ffmpeg.executeWithArguments([
      '-i',
      tempFilePath,
      '-vn',
      '-ab',
      '128k',
      '-ar',
      '44100',
      '-y',
      downloadedFilePath
    ]);
  }

  void cancelDownload() {
    _cancelToken?.cancel();
    progress = 0;
    status = DownloadStatus.cancelled;
  }
}

enum DownloadStatus { notStarted, pending, active, done, processing, cancelled }
