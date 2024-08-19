final class Inject {
  final Type type;
  final String? variableName;

  const Inject(this.type, {this.variableName});
}

final class InjectAll {
  final List<Type> types;
  const InjectAll(this.types);
}
