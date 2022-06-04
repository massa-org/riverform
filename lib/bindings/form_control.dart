import 'package:flutter/foundation.dart';
import './form_bindings.dart';

// 2 way data binding with validation
abstract class FormControl<T> extends FormBinding<T> {
  String? validate(T value) => null;
  Future<String?> asyncValidate(T value) => SynchronousFuture(null);
}
