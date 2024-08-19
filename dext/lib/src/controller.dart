import 'package:dext/dext.dart';
import 'package:dext/src/errors/http_error.dart';
import 'package:dext/src/message.dart';

abstract class Controller {
  /// The request's context
  Context get context => request.context;

  /// The http request that is going to handle this controller
  late final Request request;
}

Never badRequest() => throw BadRequestError();
Never notFound() => throw NotFoundError();
Never internalServerError() => throw InternalError();
