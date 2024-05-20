enum HttpMethod {
  get,
  post,
  put,
  delete,
  head,
  patch,
  $all;

  static const _map = <String, HttpMethod>{
    "get": get,
    "post": post,
    "put": put,
    "delete": delete,
    "head": head,
    "patch": patch,
  };

  static HttpMethod? find(String method) {
    method = method.toLowerCase();
    return _map[method];
  }
}
