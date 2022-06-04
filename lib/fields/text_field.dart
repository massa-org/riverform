import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverform/bindings/form_bindings.dart';
import 'package:riverform/bindings/form_control.dart';
import 'package:rxdart/rxdart.dart';

class RiverformTextField extends StatefulWidget {
  const RiverformTextField({
    Key? key,
    required this.binding,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  final AutovalidateMode autovalidateMode;
  final String? Function(String value)? validator;
  final FormBinding<String> binding;

  @override
  State<RiverformTextField> createState() => _RiverformTextFieldState();
}

class _RiverformTextFieldState extends State<RiverformTextField> {
  late final TextEditingController controller;

  StreamSubscription? subscription;
  StreamSubscription? revalidateSubscription;
  StreamController<String> revalidateStream = StreamController.broadcast();
  String? error;

  void _updateError(String? _error) {
    if (_error != error) {
      setState(() => error = _error);
    }
  }

  void _asyncValidate(String value) async {
    if (widget.binding is FormControl<String>) {
      final binding = widget.binding as FormControl<String>;
      final error = await binding.asyncValidate(value);
      // set error only if value is not changed after validation start
      if (mounted && value == controller.text) _updateError(error);
    }
  }

  String? _validate(String value) {
    final error = widget.validator?.call(value);
    if (error != null) return error;
    if (widget.binding is FormControl<String>) {
      final binding = widget.binding as FormControl<String>;
      final bindingError = binding.validate(value);
      if (bindingError != null) return bindingError;
      revalidateStream.add(value);
    }
    return null;
  }

  void resub() {
    subscription?.cancel();
    subscription = widget.binding.valueStream.listen(syncController);
  }

  void syncBinding() {
    final text = controller.text;
    final _error = _validate(
      widget.binding.update((v) => text == v ? v : text),
    );

    _updateError(_error);
  }

  void syncController(String v) {
    // update controller text only if something change
    if (controller.text != v) {
      final start = controller.selection.baseOffset;
      final end = controller.selection.end;

      final oldText = controller.text;
      controller.text = v;
      final prevPosition = v.lastIndexOf(oldText);
      controller.selection = TextSelection(
        baseOffset: prevPosition + start,
        extentOffset: prevPosition + end,
      );
    }
  }

  @override
  void didUpdateWidget(covariant RiverformTextField oldWidget) {
    if (oldWidget.binding != widget.binding) {
      resub();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.binding is FormControl<String>) {
      revalidateSubscription = revalidateStream.stream
          .debounceTime(const Duration(milliseconds: 250))
          .listen(_asyncValidate);
    }

    controller = TextEditingController(text: widget.binding.initial);
    controller.addListener(syncBinding);
    resub();

    if (widget.autovalidateMode == AutovalidateMode.always) {
      _validate(controller.text);
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(syncBinding);
    controller.dispose();
    subscription?.cancel();
    revalidateSubscription?.cancel();
    revalidateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(errorText: error),
    );
  }
}
