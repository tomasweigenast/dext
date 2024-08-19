part of 'index.dart';

abstract interface class _$UserIdController extends Controller {
  final BaseServer _server;
  late final LoggerBase loggerBase = _server.services.mustResolve<LoggerBase>();

  _$UserIdController(this._server);
}
