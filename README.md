# LBRYDart
### LRBY API binding for the Dart Language

Placeholder for actual information about this binding

## Installation 

To install this package, include `lbry` in your 
`dependencies` in your project's `pubspec.yaml`:

```yaml
dependencies:
    lbry: any
```

## Usage

Simply import `package:lbry/lbry.dart` in your
dart file, and initialize the API objects as follow:

```dart
import 'package:lbry/lbry.dart';

void main() {
  // optional timeout parameter
  LbrydApi api = LbrydApi(timeout: 5);
  
  // lbrycrd requires username and password
  LbrycrdApi api = LbrycrdApi("username", "password");
  
  // calling api method 'help' without args
  api.call("help");
  
  // calling resolve method with args
  api.call("resolve", params: {"name": "odder otter"});
  
}
```

#### Feedback
If you would like to provide feedback or find a bug, simply
open an issue in the [github repository](https://github.com/osilkin98/lbrydart)