riverpod/freezed based form utility library, that allow build reactive forms

## Features

- Reactive form binding to provider

## Getting started

```sh
flutter pub add riverform
flutter pub get
```

## Usage

Just define provider and pass binding to form
```dart
final usernameProvider = StateProvider((_) => '');
// inside build
RiverformTextField(binding: ref.watch(usernameProvider.binding))
```

## Additional information
