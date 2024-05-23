import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dext_cli/cli/commands/project/project.dart';
import 'dart:io';

const String version = '0.0.1';

CommandRunner buildRunner() {
  final runner = CommandRunner("dext_cli", "A dart implementation of distributed version control.");
  runner.addCommand(ProjectCommand());
  // runner.argParser
  //   ..addFlag(
  //     'verbose',
  //     abbr: 'v',
  //     negatable: false,
  //     help: 'Show additional command output.',
  //   )
  //   ..addFlag(
  //     'version',
  //     negatable: false,
  //     help: 'Print the tool version.',
  //   );

  return runner;
}

void printUsage(ArgParser argParser) {
  print('Usage: dart dext_cli.dart <flags> [arguments]');
  print(argParser.usage);
}

Future<void> main(List<String> arguments) async {
  final runner = buildRunner();
  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}
