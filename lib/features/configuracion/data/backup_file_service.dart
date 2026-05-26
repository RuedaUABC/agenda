import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

abstract class BackupFileService {
  Future<String?> saveBackup(String content);
  Future<String?> openBackup();
}

class NativeBackupFileService implements BackupFileService {
  static const _jsonGroup = XTypeGroup(
    label: 'Respaldo JSON',
    extensions: ['json'],
    mimeTypes: ['application/json'],
  );

  @override
  Future<String?> saveBackup(String content) async {
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final suggestedName = 'agenda_backup_$timestamp.json';
    final location = await getSaveLocation(
      acceptedTypeGroups: const [_jsonGroup],
      suggestedName: suggestedName,
      confirmButtonText: 'Guardar',
    );
    if (location == null) return null;

    final file = XFile.fromData(
      Uint8List.fromList(utf8.encode(content)),
      mimeType: 'application/json',
      name: suggestedName,
    );
    await file.saveTo(location.path);
    return location.path;
  }

  @override
  Future<String?> openBackup() async {
    final file = await openFile(
      acceptedTypeGroups: const [_jsonGroup],
      confirmButtonText: 'Importar',
    );
    return file?.readAsString();
  }
}
