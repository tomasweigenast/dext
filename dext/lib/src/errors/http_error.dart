import 'dart:io';

class HttpError extends Error {
  final int statusCode;

  HttpError({
    required this.statusCode,
  });

  String get message => "An HTTP $statusCode error occurred.";

  @override
  String toString() => "HttpError(statusCode: $statusCode)";
}

final class InternalError extends HttpError {
  InternalError() : super(statusCode: HttpStatus.internalServerError);
}

final class NotFoundError extends HttpError {
  NotFoundError() : super(statusCode: HttpStatus.notFound);
}

final class BadRequestError extends HttpError {
  BadRequestError() : super(statusCode: HttpStatus.badRequest);
}
