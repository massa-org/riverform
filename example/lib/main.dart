import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverform/fields/checkbox_list_tile.dart';
import 'package:riverform/fields/switch_list_tile.dart';
import 'package:riverform/fields/radio_list_tile.dart';
import 'package:riverform/fields/slider.dart';
import 'package:riverform/fields/range_slider.dart';

import 'package:riverform/riverform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(),
      ),
    );
  }
}

final _stringValue = StateProvider((ref) => '');
final _boolValue = StateProvider((ref) => true);
final _optionalBoolValue = StateProvider<bool?>((_) => true);
final _radioGroupValue = StateProvider<String>((_) => 'nothing');
final _sliderValue = StateProvider((_) => 0.0);
final _rangeSliderValue = StateProvider((_) => RangeValues(0, 1));

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('rebuild binding');
    return Scaffold(
      appBar: AppBar(title: const Text('Riverform examples')),
      body: SafeArea(
        child: ListView(
          children: [
            RiverformTextField(
              binding: ref.watch(_stringValue.binding),
            ),
            Row(
              children: [
                Text(ref.watch(_stringValue)),
                TextButton(
                  onPressed: () =>
                      ref.watch(_stringValue.notifier).update((v) => v + 'A'),
                  child: const Text('A'),
                ),
              ],
            ),
            RiverformSwitchListTile(binding: ref.watch(_boolValue.binding)),
            RiverformCheckboxListTile(
              title: const Text('simple'),
              binding: ref.watch(_boolValue.binding),
            ),
            RiverformCheckboxListTile(
              title: const Text('tristate by binding type'),
              binding: ref.watch(_optionalBoolValue.binding),
            ),
            RiverformCheckboxListTile(
              title: const Text('forced tristate'),
              binding: ref.watch(_optionalBoolValue.binding),
            ),
            RiverformRadioListTile(
              title: const Text('nothing'),
              binding: ref.watch(_radioGroupValue.binding),
              value: 'nothing',
            ),
            RiverformRadioListTile(
              title: const Text('something'),
              binding: ref.watch(_radioGroupValue.binding),
              value: 'something',
            ),
            RiverformSlider(
              binding: ref.watch(_sliderValue.binding),
            ),
            RiverformRangeSlider(
              binding: ref.watch(_rangeSliderValue.binding),
            ),
          ],
        ),
      ),
    );
  }
}
