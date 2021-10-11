import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod/riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/models/download_state.dart';

final downloadServiceProvider = Provider((ref) => _DownloadService(Dio()));

class _DownloadService {
  final Dio _dio;

  _DownloadService(this._dio);

  Future<DownloadState> downloadAudio(
      AudioStreamInfo stream, String fileName) async {
    var hasPermission = await requestStoragePermissions();

    if (!hasPermission) throw Error();

    var appDocDir = await getDownloadDirectory();
    String savePath = appDocDir!.path + "/temp.webm";

    var state = DownloadState(_dio,
        savePath: savePath,
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
    Map<Permission, PermissionStatus> statuses = await [
      // Permission.manageExternalStorage,
      Permission.storage,
      Permission.mediaLibrary,
    ].request();

    // if (Platform.isAndroid) {
    //   var intent = const AndroidIntent(
    //       data: 'package:com.example.yt_player',
    //       action: 'android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
    //   try {
    //     await intent.launch();
    //   } catch (e) {
    //     print("Intent Failed");
    //   }
    // }

    // var dir = Directory("storage/emulated/0/YouTubeDownloader");
    // print("storage/emulated/0/Download/YouTubeDownloader");
    // dir.createSync();

    return statuses.entries.every((element) => element.value.isGranted);
  }

  downloadMuxed(MuxedStreamInfo stream) {}
}
