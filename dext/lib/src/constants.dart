const kReleaseMode = bool.fromEnvironment("RELEASE_MODE", defaultValue: false);
const kImmutableTypes = bool.fromEnvironment("IMMUTABLE_TYPES", defaultValue: false);
const kDebugMode = !kReleaseMode;
