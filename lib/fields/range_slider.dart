import 'package:flutter/material.dart';
import 'package:riverform/bindings/form_bindings.dart';

class RiverformRangeSlider extends StatelessWidget {
  const RiverformRangeSlider({Key? key, required this.binding})
      : super(key: key);

  final FormBinding<RangeValues> binding;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RangeValues>(
      stream: binding.valueStream,
      builder: (context, snapshot) {
        return RangeSlider(
          values: snapshot.data ?? binding.initial,
          onChanged: (v) => binding.update((_) => v),
        );
      },
    );
  }
}
