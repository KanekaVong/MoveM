import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Remembers the photo just uploaded, because the server returns a path
/// it cannot serve yet.
class ProfileImageStore {
  static final Map<String, String> _files = {};

  static String? localFor(String urlOrPath) {
    for (final entry in _files.entries) {
      final local = entry.value;
      if (!File(local).existsSync()) continue;
      if (urlOrPath == entry.key || urlOrPath.endsWith(entry.key)) return local;
    }
    return null;
  }

  static Future<void> remember(String remotePath, String localPath) async {
    final source = File(localPath);
    if (!source.existsSync()) return;
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/profile_pics');
    if (!folder.existsSync()) folder.createSync(recursive: true);
    final name = remotePath.split('/').last;
    final dest = File('${folder.path}/$name');
    await source.copy(dest.path);
    _files[remotePath] = dest.path;
    _files[name] = dest.path;
  }
}
