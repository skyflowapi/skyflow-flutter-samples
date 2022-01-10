import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

// Generic function used to get Native Label views based on platform
SizedBox GetNativeRevealForm(Map<String, String> revealFormDetails) {
  if(Platform.isAndroid) {
    return _GetAndroidRevealForm(revealFormDetails);
  } else if(Platform.isIOS) {
    return _GetiOSRevealForm(revealFormDetails);
  } else {
    return SizedBox(child: Text("Not supported in ${defaultTargetPlatform.name}"));
  }
}

// Function used to get Android Native Collect Form
SizedBox _GetAndroidCollectForm(Map<String, List<String>> collectFormDetails) {
  const String viewType = 'android-text-field';

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
        creationParams: {"fields": collectFormDetails},
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



// Function used to get Android Native Reveal Form
SizedBox _GetAndroidRevealForm(Map<String, String> revealFormDetails) {
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
      return PlatformViewsService.initSurfaceAndroidView(
        id: params.id+1,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: revealFormDetails,
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

// Function used to get iOS Native Label views
SizedBox _GetiOSRevealForm(Map<String, String> revealFormDetails) {
  const String viewType = 'iOS-reveal-label';

  return SizedBox(height: 100,child:
  UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: revealFormDetails,
    creationParamsCodec: const StandardMessageCodec(),
  )
  );
}