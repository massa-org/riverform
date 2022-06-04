import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverform/bindings/form_bindings.dart';

class RiverformCheckboxListTile extends ConsumerWidget {
  const RiverformCheckboxListTile({
    Key? key,
    this.title,
    this.tristate,
    required this.binding,
  })  : assert(
          tristate != true ||
              (tristate == true && (binding is! FormBinding<bool>)),
          'for use tristate:true binding type must be FormBinding<bool?> now',
        ),
        super(key: key);

  final Widget? title;
  final bool? tristate;
  final FormBinding<bool?> binding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<bool?>(
      stream: binding.valueStream,
      builder: (context, snapshot) {
        return CheckboxListTile(
          title: title,
          tristate: tristate ?? (binding is! FormBinding<bool>),
          value: snapshot.hasData ? snapshot.data : binding.initial,
          onChanged: (v) {
            if (binding is FormBinding<bool>) {
              (binding as FormBinding<bool>).update((bool _) => v!);
            } else {
              binding.update((_) => v);
            }
          },
        );
      },
    );
  }
}
