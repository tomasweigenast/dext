enum HttpMethod {
  get._("GET"),
  post._("POST"),
  put._("PUT"),
  delete._("DELETE"),
  head._("HEAD"),
  patch._("PATCH"),
  $all._(r"$ALL");

  final String verb;

  const HttpMethod._(this.verb);

  @override
  String toString() => verb;
}
