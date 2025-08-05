// ignore_for_file: avoid_print

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void main() async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found.');
    exit(1);
  }

  final originalContent = pubspecFile.readAsStringSync();
  final doc = loadYaml(originalContent);
  final editor = YamlEditor(originalContent);

  final baseDirs = [Directory('assets'), Directory('assets/openings')];

  final allDirs = <String>{};

  for (final baseDir in baseDirs) {
    if (!baseDir.existsSync()) {
      print('❌ Directory ${baseDir.path} does not exist.');
      exit(1);
    }

    allDirs.add(
      '${baseDir.path.replaceAll('\\', '/')}/',
    ); // Ajoute le dossier lui-même

    baseDir.listSync(recursive: true).whereType<Directory>().forEach((dir) {
      allDirs.add('${dir.path.replaceAll('\\', '/')}/');
    });
  }

  final currentAssets =
      (doc['flutter']?['assets'] as YamlList?)?.toList().cast<String>() ?? [];

  final newAssets = allDirs
      .where((dir) => !currentAssets.contains(dir))
      .toList();

  if (newAssets.isEmpty) {
    print('✅ No new asset directories to add.');
    return;
  }

  final updatedAssets = [...currentAssets, ...newAssets]..sort();

  editor.update(['flutter', 'assets'], updatedAssets);

  pubspecFile.writeAsStringSync(editor.toString());
  print('✅ Added ${newAssets.length} new asset directories to pubspec.yaml');
}
