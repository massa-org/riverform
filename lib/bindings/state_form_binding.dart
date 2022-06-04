import 'package:flutter/foundation.dart';
import 'package:riverform/bindings/form_bindings.dart';

import './form_control.dart';
import 'package:riverpod/riverpod.dart';

// ignore: implementation_imports
// import 'package:riverpod/src/framework.dart';

class StateFormBinding<T> extends FormControl<T> {
  final StateController<T> controller;

  StateFormBinding(this.controller);

  @override
  T get initial => controller.state;

  @override
  T update(T Function(T newValue) updater) => controller.update(updater);

  @override
  Stream<T> get valueStream => controller.stream;
}

StateFormBinding<State> _stateValueAsBinding<State>(
  StateProvider<State> provider,
  ProviderElementBase<StateFormBinding<State>> ref,
) {
  // ref.onDispose(() {
  //   if (loadingCompleter != null) {
  //     loadingCompleter!.completeError(
  //       StateError(
  //         'The provider $provider was disposed before a value was emitted.',
  //       ),
  //     );
  //   }
  // });

  void listener(
    StateController<State>? previous,
    StateController<State> value,
  ) {
    ref.setState(StateFormBinding(value));
  }

  ref.listen(provider.notifier, listener, fireImmediately: true);

  return ref.requireState;
}

String? modifierName(String? from, String modifier) {
  return from == null ? null : '$from.$modifier';
}

// ignore: subtype_of_sealed_class
@protected
class StateAsFormBinding<State>
    extends AlwaysAliveProviderBase<StateFormBinding<State>> {
  ///
  StateAsFormBinding(
    this._provider, {
    required Family? from,
    required Object? argument,
  }) : super(
          name: modifierName(_provider.name, 'formBinding'),
          from: from,
          argument: argument,
        );

  final StateProvider<State> _provider;

  @override
  late final dependencies = [_provider.notifier];

  @override
  StateFormBinding<State> create(
      ProviderElementBase<StateFormBinding<State>> ref) {
    return _stateValueAsBinding(_provider, ref);
  }

  @override
  bool updateShouldNotify(
    FormBinding<State> previousState,
    FormBinding<State> newState,
  ) {
    return true;
  }

  @override
  ProviderElement<StateFormBinding<State>> createElement() {
    return ProviderElement(this);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is StateAsFormBinding<State> && other._provider == _provider;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _provider.hashCode;
}

extension StateProviderBindingExtension<T> on StateProvider<T> {
  StateAsFormBinding<T> get binding =>
      StateAsFormBinding(this, from: from, argument: argument);
}
