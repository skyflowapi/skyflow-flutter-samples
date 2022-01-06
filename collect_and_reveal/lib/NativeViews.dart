import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Generic function used to get Native TextField views based on platform
SizedBox GetNativeTextField(String label, String table, String column, String type) {
  if(Platform.isAndroid) {
    return _GetAndroidView(label, table, column, type);
  } else if(Platform.isIOS) {
    return _GetiOSTextView(label, table, column, type);
  } else {
    return SizedBox(child: Text("Not supported in ${defaultTargetPlatform.name}"));
  }
}

// Generic function used to get Native Label views based on platform
SizedBox GetNativeRevealLabel(String label, String token) {
  if(Platform.isAndroid) {
    return _GetAndroidRevealLabel(label, token);
  } else if(Platform.isIOS) {
    return _GetiOSRevealLabel(label, token);
  } else {
    return SizedBox(child: Text("Not supported in ${defaultTargetPlatform.name}"));
  }
}

// Function used to get Android Native TextField views
SizedBox _GetAndroidView(String label, String table, String column, String type) {
  const String viewType = 'android-text-field';
  var creationParams = Map<String, dynamic>();

  creationParams.putIfAbsent("label", () => label);
  creationParams.putIfAbsent("table", () => table);
  creationParams.putIfAbsent("column", () => column);
  creationParams.putIfAbsent("type", () => type);

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
      return PlatformViewsService.initSurfaceAndroidView(
        id: params.id+1,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
        onFocus: () {
          params.onFocusChanged(true);
        } ,
      )
        ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
        ..create();
    },
  ));
}



// Function used to get Android Native Label views
SizedBox _GetAndroidRevealLabel(String label, String token) {
  const String viewType = 'android-reveal-label';
  var creationParams = Map<String, dynamic>();

  creationParams.putIfAbsent("label", () => label);
  creationParams.putIfAbsent("token", () => token);

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
      return PlatformViewsService.initSurfaceAndroidView(
        id: params.id+1,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
        onFocus: () {
          params.onFocusChanged(true);
        } ,
      )
        ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
        ..create();
    },
  ));
}


// Function used to get iOS Native TextField views
SizedBox _GetiOSTextView(String label, String table, String column, String type) {
  const String viewType = 'iOS-text-field';
  var creationParams = Map<String, dynamic>();

  creationParams.putIfAbsent("label", () => label);
  creationParams.putIfAbsent("table", () => table);
  creationParams.putIfAbsent("column", () => column);
  creationParams.putIfAbsent("type", () => type);

  return SizedBox(height: 100,child:
  UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  )
  );
}

// Function used to get iOS Native Label views
SizedBox _GetiOSRevealLabel(String label, String token) {
  const String viewType = 'iOS-reveal-label';

  var creationParams = Map<String, dynamic>();

  creationParams.putIfAbsent("label", () => label);
  creationParams.putIfAbsent("token", () => token);

  return SizedBox(height: 100,child:
  UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  )
  );
}