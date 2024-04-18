import 'dart:async';

import 'package:dext/src/message.dart';

typedef RouteHandler = FutureOr<Response> Function(Request request);
