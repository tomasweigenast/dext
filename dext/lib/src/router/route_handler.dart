import 'dart:async';

import 'package:dext/src/message.dart';

typedef RouteHandler<T> = FutureOr<Response<T>> Function(Request<T> request);
