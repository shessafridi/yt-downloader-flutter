import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod/riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/models/download_state.dart';
import 'package:yt_player/src/shared/path_service.dart';

final downloadServiceProvider = Provider((ref) => _DownloadService(Dio()));

class _DownloadService {
  final Dio _dio;

  _DownloadService(this._dio);

  Future<DownloadState> downloadAudio(
      AudioStreamInfo stream, String fileName) async {
    var hasPermission = await requestStoragePermissions();
    if (!hasPermission) throw Error();

    final basePath = await getAppDownloadDirectory();

    var state = DownloadState(_dio,
        basePath: basePath,
        type: DownloadType.audio,
        downloadUrl: stream.url.toString(),
        fileName: getLegalFileName(fileName));

    return state;
  }

  static String getLegalFileName(String fileName) {
    final regex = RegExp("[\\/:\"*?<>|]+");
    return fileName.replaceAllMapped(regex, (match) => "");
  }

  Future<DownloadState> downloadMuxed(
      MuxedStreamInfo stream, String fileName) async {
    var hasPermission = await requestStoragePermissions();
    if (!hasPermission) throw Error();

    final basePath = await getAppDownloadDirectory();

    var state = DownloadState(_dio,
        basePath: basePath,
        type: DownloadType.video,
        downloadUrl: stream.url.toString(),
        fileName: fileName);

    return state;
  }

  Future<Directory?> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      var dirs = await path_provider.getExternalStorageDirectories(
          type: path_provider.StorageDirectory.downloads);
      return dirs!.first;
    }
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return await path_provider.getDownloadsDirectory();
    }
  }

  Future<bool> requestStoragePermissions() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) return true;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();

    return statuses.entries.every((element) => element.value.isGranted);
  }
}
