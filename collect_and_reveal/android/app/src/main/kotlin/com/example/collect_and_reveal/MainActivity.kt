package com.example.collect_and_reveal

import Skyflow.Configuration
import com.example.collect_and_reveal.CollectViews.CollectFormFactory
import com.example.collect_and_reveal.RevealViews.RevealFormFactory
import com.example.collect_and_reveal.utils.DemoTokenProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

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
                .registerViewFactory("android-text-field", CollectFormFactory(flutterEngine, skyflowClient))
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("android-reveal-label", RevealFormFactory(flutterEngine, skyflowClient))
    }

}





