import 'package:flutter/material.dart';
import 'package:riverform/bindings/form_bindings.dart';

class RiverformSwitchListTile extends StatelessWidget {
  const RiverformSwitchListTile({
    Key? key,
    required this.binding,
  }) : super(key: key);

  final FormBinding<bool> binding;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: binding.valueStream,
      builder: (context, snapshot) {
        return SwitchListTile(
          value: snapshot.data ?? binding.initial,
          onChanged: (v) => binding.update((_) => v),
        );
      },
    );
  }
}
