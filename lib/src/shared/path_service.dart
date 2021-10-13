import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getAppDownloadDirectory() async {
  if (Platform.isAndroid) {
    return '/storage/emulated/0/Download/YouTubeDownloads/';
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final dir = await getDownloadsDirectory();
    return dir!.path.toString();
  }

  throw UnsupportedError("Platform not supported");
}
