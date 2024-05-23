import 'dart:io';

import 'package:dext_cli/models/dext_file_metadata/dext_file_metadata.dart';
import 'package:dext_cli/models/project/project.dart';
import 'package:dext_cli/utils/constants.dart';
import 'package:dext_cli/utils/helpers.dart';
import 'package:path/path.dart' as p;

/// Provides methods to manage projects
final class Project {
  late final dextFile = File(p.join(_workingDirectory, ".dext"));
  late final dextProjectFile = File(p.join(_workingDirectory, "config.dext.json"));

  final String _workingDirectory;
  final String _name;
  final bool _created;

  Project._(this._name, String workingDirectory, this._created) : _workingDirectory = p.join(workingDirectory, _name);

  factory Project.existing(String path) {
    // todo: scan project
    return Project._("_name", path, false);
  }

  factory Project.newProject(String name, {String? folder}) {
    folder ??= Directory.current.path;
    return Project._(name, folder, true);
  }

  String? create({bool force = false}) {
    Directory(_workingDirectory).createSync(recursive: true);

    if (!force && dextProjectFile.existsSync()) {
      return "Already exists a Dext project in the current directory.";
    }

    // create project definition
    final project = DextProject(
      version: kVersion,
      config: ProjectConfig(),
    ).toJson();

    // create dext file metadata
    final dextFileData = DextFileMetadata();

    dextProjectFile.writeAsStringSync(jsonEncoder.convert(project));
    dextFile.writeAsStringSync(jsonEncoder.convert(dextFileData));
    return null;
  }
}
