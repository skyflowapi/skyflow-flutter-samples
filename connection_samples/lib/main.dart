import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    List<Widget> fields = [
      Text('Connection generates a CVV'),
      GetNativeTextField("CVV", "pii_fields", "primary_card.cvv", "CVV"),
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
    log("calling invokeConnection");

    Map<String, dynamic> args = {
      "connectionUrl": "https://na1.area51.gateway.skyflowapis.com/v1/gateway/outboundRoutes/scfaffe01789470a81d977804637fa7e/dcas/cardservices/v1/cards/{card_number}/cvv2generation",
      "requestHeaders": {
        "Content-Type": "application/json",
        "Authorization": "Basic QjBORFNKUEcyMzhTMjJOSlU5QjIyMVJfQTBMT3ZLZE1xS3JRQTJOQXpBXzFQQVIyRTozZ0Z3NlNmMUU5VDMxeWo2a3FQMzJmY1VBOU4weUQ5WjlDbA"
      },
      "requestBody": {
        "expirationDate": {
          "mm": "12",
          "yy": "22"
        }
      },
      "pathParams": {
        "card_number": "4111111111111111"
      },
      "queryParams": {},
      "responseBody": {
        // "resource": {
        //   // Should show up on this element
        //   "cvv": "CVV"
        // }
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

