import 'package:flutter/material.dart';
import 'package:riverform/bindings/form_bindings.dart';

class RiverformRadioListTile<T> extends StatelessWidget {
  const RiverformRadioListTile({
    Key? key,
    required this.value,
    required this.binding,
    this.title,
  }) : super(key: key);

  final Widget? title;
  final T value;
  final FormBinding<T> binding;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: binding.valueStream,
      builder: (context, snapshot) {
        return RadioListTile<T>(
          title: title,
          value: value,
          groupValue: snapshot.hasData ? snapshot.data : binding.initial,
          onChanged: (v) => binding.update((_) => v as T),
        );
      },
    );
  }
}
