import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'serenity_export_service.dart';

class DeviceExportService {
  DeviceExportService(this._exportService);

  final SerenityExportService _exportService;

  Future<void> exportAndShare() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/serenity-export.json');
    await file.writeAsString(await _exportService.buildJson(), flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        fileNameOverrides: const ['serenity-export.json'],
        subject: 'Ekspor data Serenity',
      ),
    );
  }
}
