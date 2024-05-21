import 'package:dext/src/context.dart';
import 'package:dext/src/errors/http_error.dart';

abstract class Controller {
  /// The request's context
  late final Context context;

  Never notFound() => throw NotFoundError();

  Never internalServerError() => throw InternalError();
}
