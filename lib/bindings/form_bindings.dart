// 2 way data bindings without any validation
abstract class FormBinding<T> {
  Stream<T> get valueStream;
  T get initial;

  T update(T Function(T newValue) updater);
}
