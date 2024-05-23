import 'package:args/command_runner.dart';
import 'package:dext_cli/cli/commands/project/subcommands/create_project.dart';

final class ProjectCommand extends Command {
  ProjectCommand() {
    addSubcommand(CreateProjectSubcommand());
  }

  @override
  String get description => "Project management command.";

  @override
  String get name => "project";
}
