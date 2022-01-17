# Collect and Reveal Sample

This Flutter demo illustrates the use of Skyflow Collect and Reveal with Flutter using the Android and iOS SDKs


## Steps to run

This project can be run by following these steps

### Android

- Add your `VAULT_ID` and `VAULT_URL` in [MainActivity.kt](https://github.com/skyflowapi/skyflow-flutter-samples/blob/main/collect_and_reveal/android/app/src/main/kotlin/com/example/collect_and_reveal/MainActivity.kt) file inside the `android` directory
- Add your tokenProvider code in [utils/DemoTokenProvider.kt](https://github.com/skyflowapi/skyflow-flutter-samples/blob/main/collect_and_reveal/android/app/src/main/kotlin/com/example/collect_and_reveal/utils/DemoTokenProvider.kt) file

### iOS
- Add your `VAULT_ID` and `VAULT_URL` in [ios/Runner/ClientConfiguration.swift](https://github.com/skyflowapi/skyflow-flutter-samples/blob/main/collect_and_reveal/ios/Runner/ClientConfiguration.swift) file
- Add you tokenProvider code in [ios/Runner/utils/DemoTokenProvider.kt](https://github.com/skyflowapi/skyflow-flutter-samples/blob/main/collect_and_reveal/ios/Runner/utils/DemoTokenProvider.swift)


### Dart
- You can change the Label, tablename, column and type of Collect and Reveal UI elements in `CollectForm` and `RevealForm` Widgets inside `lib/main.dart`
