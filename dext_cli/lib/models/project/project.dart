import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// Project represents a dext project
@freezed
class DextProject with _$DextProject {
  const factory DextProject({
    /// The dex_cli version used to create the project
    required String version,

    /// The project's configuration
    required ProjectConfig config,
  }) = _DextProject;

  factory DextProject.fromJson(Map<String, dynamic> json) => _$DextProjectFromJson(json);
}

@freezed
class ProjectConfig with _$ProjectConfig {
  const factory ProjectConfig({
    /// Configuration related to the "static" resources folder
    @JsonKey(fromJson: _staticFolderConfigFromJson, toJson: _staticFolderConfigToJson) StaticFolderConfig? staticFolder,
  }) = _ProjectConfig;

  factory ProjectConfig.fromJson(Map<String, dynamic> json) => _$ProjectConfigFromJson(json);
}

@freezed
class StaticFolderConfig with _$StaticFolderConfig {
  const factory StaticFolderConfig.path(String value) = StringFolderConfigPath;
  const factory StaticFolderConfig.config(StaticFolderConfigValue value) = StringFolderConfigValue;
}

StaticFolderConfig? _staticFolderConfigFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return StaticFolderConfig.path(value);
  } else if (value is Map) {
    return StaticFolderConfig.config(StaticFolderConfigValue.fromJson(value.cast<String, dynamic>()));
  }

  throw FormatException("Invalid format for static folder config.");
}

dynamic _staticFolderConfigToJson(StaticFolderConfig? value) => value?.when(
      path: (path) => path,
      config: (config) => config.toJson(),
    );

@freezed
class StaticFolderConfigValue with _$StaticFolderConfigValue {
  const factory StaticFolderConfigValue() = _StaticFolderConfigValue;

  factory StaticFolderConfigValue.fromJson(Map<String, dynamic> json) => _$StaticFolderConfigValueFromJson(json);
}
