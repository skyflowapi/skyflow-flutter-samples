import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NativeViews.dart';

void main() {
  runApp(const SkyflowFlutterDemo());
}

class SkyflowFlutterDemo extends StatelessWidget {
  const SkyflowFlutterDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Skyflow Flutter Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('skyflow');

  @override
  Widget build(BuildContext context) {

    List<Widget> fields = [
      GetNativeTextField("CARD NUMBER", "pii_fields", "primary_card.card_number", "CARD_NUMBER"),
      GetNativeTextField("EXPIRATION DATE", "pii_fields", "primary_card.expiry_date", "EXPIRY_DATE"),
      GetNativeRevealLabel("CVV", ""),
      ElevatedButton(
          onPressed: generateCVV,
          child: const Text("Generate CVV"))];

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // initialize and add necessary Collect TextFields
            child: ListView(children: [Column(children:
            fields
            )]
            )
        ));
  }

  void generateCVV() async {

    Map<String, dynamic> args = {
      "connectionUrl": "<YOUR_CONNECTION_URL>",
      "requestHeaders": {
        "Content-Type": "application/json",
        "Authorization": "<YOUR_VISA_BASIC_AUTH"
      },
      "requestBody": {
        // Get the expiration date from the "EXPIRATION DATE" collect element
        "expirationDate": "EXPIRATION DATE"
      },
      "pathParams": {
        // Get the card number from the "CARD NUMBER" collect element
        "card_number": "CARD NUMBER"
      },
      "queryParams": {},
      "responseBody": {
        // Generated CVV shows up on CVV reveal element
        "cvv2": "CVV"
      }
    };

    try {
      final String platformResult = await platform.invokeMethod("GENERATECVV", args);
    } on PlatformException catch (e) {
      String message = "Unexpected error";
      if(e.message != null) {
        message = e.message!;
      }
      log("Error: " + message);
    }
  }

}

