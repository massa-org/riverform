import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverform/bindings/form_bindings.dart';

class RiverformSlider extends StatelessWidget {
  const RiverformSlider({Key? key, required this.binding}) : super(key: key);

  final FormBinding<double> binding;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: binding.valueStream,
      builder: (context, snapshot) {
        return Slider(
          value: snapshot.data ?? binding.initial,
          onChanged: (v) => binding.update((_) => v),
        );
      },
    );
  }
}
