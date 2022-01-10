import 'dart:convert';
import 'dart:developer';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CollectForm(title: 'Skyflow Flutter Demo'),
    );
  }
}

class CollectForm extends StatefulWidget {
  const CollectForm({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CollectForm> createState() => _CollectFormState();
}

class _CollectFormState extends State<CollectForm> {
  static const platform = MethodChannel('skyflow');

  // Tokens from collect are stored here
  var _tokens = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {

    const collectFormDetails = {
      "Credit Card Number": ["pii_fields", "primary_card.card_number", "CARD_NUMBER"],
      "Card Holder": ["pii_fields", "first_name", "CARDHOLDER_NAME"],
      "Expiry Date": ["pii_fields", "primary_card.expiry_date", "EXPIRATION_DATE"],
      "CVV": ["pii_fields", "primary_card.cvv", "CVV"]
    };


    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          // initialize and add necessary Collect TextFields
            child: Column(children: [
                  Expanded(child: GetNativeCollectForm(collectFormDetails)),
                  ElevatedButton(
                      onPressed: collectDetails,
                      child: const Text("Collect"))
            ]
            )
        ));
  }

  // This function is used to call the PlatformChannel for collect
  void collectDetails() async {
    // clear out previous reveal elements

    try {
      // Call collect
      final String platformResult = await platform.invokeMethod('COLLECT');


      setState(() {
        _tokens = json.decode(platformResult)["records"][0]["fields"];
      });

      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RevealForm(tokens: _tokens))
      );
    } on PlatformException catch (e) {
      String message = "Unexpected error";
      if(e.message != null) {
        message = e.message!;
      }
      log("Error: " + message);
    }
  }
}

class RevealForm extends StatelessWidget {
  static const platform = MethodChannel('skyflow');

  const RevealForm({Key? key, required this.tokens}) : super(key: key);

  final Map<String, dynamic> tokens;

  @override
  Widget build(BuildContext context) {
    var revealFormDetails = {
      "Card Number": tokens["primary_card"]["card_number"] as String,
      "Card Holder Name": tokens["first_name"] as String,
      "Expiry Date": tokens["primary_card"]["expiry_date"] as String,
      "CVV": tokens["primary_card"]["cvv"] as String,
    };

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Reveal"),
        ),
        body: Center(
          // initialize and add necessary Collect Form
            child: Column(children: [
              Expanded(child: GetNativeRevealForm(revealFormDetails)),
                  ElevatedButton(
                      onPressed: revealValues,
                      child: const Text("Reveal"))
                ]
            )
            )
        );
  }
  void revealValues() async {

    try {
      await platform.invokeMethod("REVEAL");
    } on PlatformException catch (e) {
      log(e.message!);
    }
  }
}

