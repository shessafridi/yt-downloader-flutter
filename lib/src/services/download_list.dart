import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_player/src/models/download_state.dart';

final downloadListStateProvider = StateProvider((ref) => <DownloadState>[]);
