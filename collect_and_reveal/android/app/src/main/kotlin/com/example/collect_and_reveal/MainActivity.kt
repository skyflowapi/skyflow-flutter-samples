package com.example.collect_and_reveal

import Skyflow.*
import com.example.collect_and_reveal.CollectViews.AndridTextFieldFactory
import com.example.collect_and_reveal.RevealViews.AndroidRevealLabel
import com.example.collect_and_reveal.RevealViews.AndroidRevealLabelFactory
import com.example.collect_and_reveal.utils.DemoTokenProvider
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {


    private val CHANNEL = "skyflow"

    val config = Configuration(
            vaultID = "<YOUR_VAULT_ID>",
            vaultURL = "<YOUR_VAULT_URL>",
            tokenProvider = DemoTokenProvider()
    )


    private val skyflowClient = Skyflow.init(config)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        // Register collect and reveal view factories
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("android-text-field", AndridTextFieldFactory(flutterEngine, skyflowClient))
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("android-reveal-label", AndroidRevealLabelFactory(flutterEngine, skyflowClient))
    }

}





