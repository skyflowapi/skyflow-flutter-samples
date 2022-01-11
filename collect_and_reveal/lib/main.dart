import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';



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
  var channel = MethodChannel('skyflow-collect');

  // Tokens from collect are stored here
  var _tokens = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {

    const collectFormDetails = {
      "Credit Card Number": ["pii_fields", "primary_card.card_number", "CARD_NUMBER"],
    "Card Holder": ["pii_fields", "first_name", "CARDHOLDER_NAME"],
      "CVV": ["pii_fields", "primary_card.cvv", "CVV"],
      "Expiry Date": ["pii_fields", "primary_card.expiry_date", "EXPIRATION_DATE"],
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
      final String platformResult = await channel.invokeMethod('COLLECT');
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

  // Generic function used to get Native TextField views based on platform
  SizedBox GetNativeCollectForm(Map<String, List<String>> collectFormDetails) {
    if(Platform.isAndroid) {
      return _GetAndroidCollectForm(collectFormDetails);
    } else if(Platform.isIOS) {
      return _GetiOSCollectForm(collectFormDetails);
    } else {
      return SizedBox(child: Text("Not supported in ${defaultTargetPlatform.name}"));
    }
  }



// Function used to get Android Native Collect Form
  SizedBox _GetAndroidCollectForm(Map<String, List<String>> collectFormDetails) {
    const String viewType = 'android-text-field';
    MethodChannel channel;

    return SizedBox(height: 100,child: PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        var platformView = PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: {"fields": collectFormDetails},
          creationParamsCodec: StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          } ,
        );
        platformView.addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
        platformView.addOnPlatformViewCreatedListener(setCollectChannel);
        platformView.create();
        return platformView;
      },
    ));
  }



// Function used to get iOS Native Collect form
  SizedBox _GetiOSCollectForm(Map<String, List<String>> collectFormDetails) {
    const String viewType = 'iOS-text-field';

    return SizedBox(height: 100,child:
    UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: {"fields": collectFormDetails},
      creationParamsCodec: const StandardMessageCodec(),
    )
    );
  }

  void setCollectChannel(int id) {
    this.channel = MethodChannel("skyflow-collect/${id}");
  }

}

class RevealForm extends StatelessWidget {
  RevealForm({Key? key, required this.tokens}) : super(key: key);

  final Map<String, dynamic> tokens;
  var channel = MethodChannel("skyflow-reveal");

  @override
  Widget build(BuildContext context) {
    var revealFormDetails = {
      "Card Number": tokens["primary_card"]["card_number"] as String,
      "Card Holder Name": tokens["first_name"] as String,
      "CVV": tokens["primary_card"]["cvv"] as String,
      "Expiry Date": tokens["primary_card"]["expiry_date"] as String,
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
      await channel.invokeMethod("REVEAL");
    } on PlatformException catch (e) {
      log(e.message!);
    }
  }

  // Generic function used to get Native Label views based on platform
  SizedBox GetNativeRevealForm(Map<String, String> revealFormDetails) {
    if(Platform.isAndroid) {
      return _GetAndroidRevealForm({"fields": revealFormDetails});
    } else if(Platform.isIOS) {
      return _GetiOSRevealForm({"fields": revealFormDetails});
    } else {
      return SizedBox(child: Text("Not supported in ${defaultTargetPlatform.name}"));
    }
  }

  // Function used to get Android Native Reveal Form
  SizedBox _GetAndroidRevealForm(Map<String, Map<String, String>> revealFormDetails) {
    const String viewType = 'android-reveal-label';

    return SizedBox(height: 100,child: PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        var platformView = PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: revealFormDetails,
          creationParamsCodec: StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          } ,
        );
        platformView.addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
        platformView.addOnPlatformViewCreatedListener(setRevealChannel);
        platformView.create();
        return platformView;
      },
    ));
  }

  // Function used to get iOS Native Label views
  SizedBox _GetiOSRevealForm(Map<String, Map<String, String>> revealFormDetails) {
    const String viewType = 'iOS-reveal-label';

    return SizedBox(height: 100,child:
    UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      onPlatformViewCreated: setRevealChannel,
      creationParams: revealFormDetails,
      creationParamsCodec: const StandardMessageCodec(),
    )
    );
  }

  void setRevealChannel(int id) {
    this.channel = MethodChannel("skyflow-reveal/${id}");
  }

}

