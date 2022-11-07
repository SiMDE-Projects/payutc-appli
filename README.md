# payutc

The payutc app

## Getting Started

### Add env file

Add env.dart file in `lib/src/` with content

```dart
const String nemoPayUrl = "https://api.nemopay.net/";
const String payUrlCallback = "https://assos.utc.fr/pay_app_callback";
const String nemoPayAppId = "80405";
const String casUrl = "https://cas.utc.fr/cas/";
const String nemoPayKey = "YOUR_WEEZPAY_APPKEY";
const String gingerKey = "YOUR_GINGER_APPKEY";
```

### Run app

```shell
flutter run
```

### Build apk

```shell
flutter build apk
```