import 'package:freezed_annotation/freezed_annotation.dart';

part 'dext_file_metadata.g.dart';
part 'dext_file_metadata.freezed.dart';

/// A [DextFileMetadata] maintains state information about a project
@freezed
class DextFileMetadata with _$DextFileMetadata {
  const factory DextFileMetadata() = _DextFileMetadata;

  factory DextFileMetadata.fromJson(Map<String, dynamic> json) => _$DextFileMetadataFromJson(json);
}
