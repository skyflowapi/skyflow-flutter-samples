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

  // Tokens from collect are stored here
  var _tokens = <String, dynamic>{};
  // RevealElements are Skyflow.Label views of native iOS or Android framework
  var _revealElements = <Widget>[];

  @override
  Widget build(BuildContext context) {

    List<Widget> fields = [
      GetNativeTextField("Credit Card Number", "pii_fields", "primary_card.card_number", "CARD_NUMBER"),
      GetNativeTextField("Card Holder", "pii_fields", "first_name", "CARDHOLDER_NAME"),
      GetNativeTextField("Expiry Date", "pii_fields", "primary_card.expiry_date", "EXPIRATION_DATE"),
      GetNativeTextField("CVV", "pii_fields", "primary_card.cvv", "CVV"),
      ElevatedButton(
          onPressed: collectDetails,
          child: const Text("Collect"))];
    fields.addAll(_revealElements);

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

  // This function is used to call the PlatformChannel for collect
  void collectDetails() async {
    // clear out previous reveal elements

    try {
      // Call collect
      final String platformResult = await platform.invokeMethod('COLLECT');


      setState(() {
        _tokens = json.decode(platformResult)["records"][0]["fields"];

        // Map label to received tokens
        var nameToToken = {
          "Card Number": _tokens["primary_card"]["card_number"],
          "Card Holder Name": _tokens["first_name"],
          "Expiry Date": _tokens["primary_card"]["expiry_date"],
          "CVV": _tokens["primary_card"]["cvv"]
        };

        if(_revealElements.isEmpty) {
          // Add the tokens received to the map
          nameToToken.forEach((name, token) {
            String tokenString = token;
            _revealElements.add(GetNativeRevealLabel(name, tokenString));
          });
          _revealElements.add(ElevatedButton(onPressed: revealValues, child: const Text("Reveal")));
        } else {
          nameToToken.forEach((name, token) async {
            await platform.invokeMethod("SETTOKEN", {"label": name, "token": token});
          });
        }
      });
    } on PlatformException catch (e) {
      String message = "Unexpected error";
      if(e.message != null) {
        message = e.message!;
      }
      log("Error: " + message);
    }
  }


  void revealValues() async {

    try {
      await platform.invokeMethod("REVEAL");
    } on PlatformException catch (e) {
      log(e.message!);
    }
  }



}

