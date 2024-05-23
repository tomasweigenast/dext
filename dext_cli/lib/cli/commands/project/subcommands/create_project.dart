import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dext_cli/project/project.dart';

final class CreateProjectSubcommand extends Command {
  @override
  String get description => "Creates a new Dext project";

  @override
  String get name => "create";

  @override
  String get invocation => "create <project-name> [arguments]";

  CreateProjectSubcommand() {
    argParser.addOption(
      "output-folder",
      help: "Specifies the folder where the project should be created",
      defaultsTo: Directory.current.path,
    );

    argParser.addFlag(
      "force",
      defaultsTo: false,
      negatable: false,
      abbr: "f",
    );
  }

  @override
  FutureOr? run() {
    final projectName = argResults?.rest.firstOrNull;
    if (projectName == null) {
      usageException("Project name was not specified.");
    }

    String? outputFolder = argResults!.option("output-folder");
    bool force = argResults!.flag("force");

    final result = Project.newProject(projectName, folder: outputFolder).create(force: force);
    if (result != null) usageException(result);

    print("Project $projectName was created.");
  }
}
