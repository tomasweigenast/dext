final class ImmutableException implements Exception {
  const ImmutableException();

  @override
  String toString() =>
      "ImmutableException(Cannot modify immutable properties because Dext mode is set to immutable. Try changing it to mutable or using copyWith methods.)";
}
