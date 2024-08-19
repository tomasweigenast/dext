import 'package:dext/src/dependency_injection/dependency_collection.dart';

final class Service {
  final ServiceType serviceType;
  final String? name;
  final String? environment;

  const Service(this.serviceType, {this.name, this.environment});
}

const singleton = Service(ServiceType.singleton);
const transient = Service(ServiceType.transient);
const scoped = Service(ServiceType.scoped);

final class Implementation {
  final String? name;
  final String? environment;

  const Implementation({this.name, this.environment});
}

const implementation = Implementation();
