const kReleaseMode = bool.fromEnvironment("RELEASE_MODE", defaultValue: false);
const kDebugMode = !kReleaseMode;
