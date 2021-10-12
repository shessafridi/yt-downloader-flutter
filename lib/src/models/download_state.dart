import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class DownloadState extends ChangeNotifier {
  static final _ffmpeg = FlutterFFmpeg();

  final String savePath;
  final String downloadPath = '/storage/emulated/0/Download/YouTubeDownloads/';
  final Dio _dio;
  final String downloadUrl;
  final String fileName;

  DownloadState(this._dio,
      {required this.savePath,
      required this.downloadUrl,
      required this.fileName});

  CancelToken? _cancelToken;

  double progress = 0.0;
  DownloadStatus status = DownloadStatus.pending;
  dynamic data;

  Future<Response<dynamic>> startDownload() async {
    _cancelToken = CancelToken();

    status = DownloadStatus.active;

    notifyListeners();

    await File(savePath).create(recursive: true);

    var res = await _dio.download(
      downloadUrl,
      savePath,
      cancelToken: _cancelToken,
      onReceiveProgress: (count, total) {
        progress = (count / total) * 100;
        print(progress.toStringAsFixed(1) + '%');
      },
    );

    status = DownloadStatus.processing;
    notifyListeners();

    await Directory(downloadPath).create(recursive: true);

    await DownloadState._ffmpeg.executeWithArguments([
      '-i',
      savePath,
      '-vn',
      '-ab',
      '128k',
      '-ar',
      '44100',
      '-y',
      downloadPath + fileName + '.mp3'
    ]);

    var isDownloaded = File(savePath + '.mp3').existsSync();
    print(File(savePath + '.mp3').stat());
    print(isDownloaded);
    print(savePath);

    try {
      File(savePath).deleteSync(recursive: true);
    } catch (e) {
      print('Failed to delete');
    }

    status = DownloadStatus.done;

    data = res.data;

    notifyListeners();
    return res;
  }

  void cancelDownload() {
    _cancelToken?.cancel();
    progress = 0;
    status = DownloadStatus.cancelled;
  }
}

enum DownloadStatus { pending, active, done, processing, cancelled }
