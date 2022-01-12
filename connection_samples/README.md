# connection_samples

This Flutter demo illustrates the use of [Skyflow Connections]() with Flutter using the Android and iOS SDKs. The connection used for this demo is for [CVV2 Generation](https://developer.visa.com/capabilities/dps-card-and-account-services/docs-how-to-cvv2), although it can be modified to use any connection. You can find more about skyflow connections [here](https://www.skyflow.com/post/skyflow-connections-mission-critical-integrations-that-dont-break-privacy) and [here](https://docs.skyflow.com/developer-portal/connections/connections-overview/)

## Steps to run

This project can be run by following these steps:

### For Android:

- Add your `VAULT_ID` and `VAULT_URL` in `android/src/kotlin/MainActivity.kt` file


### For iOS:

- Add your `VAULT_ID` and `VAULT_URL` in `ios/Runner/AppDelegate.swift` file


### In Dart:

- Change connection config in `lib/main.dart` inside the `generateCVV` function for your connection

Finally, run the flutter program.