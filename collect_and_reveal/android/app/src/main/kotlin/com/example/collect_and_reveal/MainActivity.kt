package com.example.collect_and_reveal

import Skyflow.*
import com.example.collect_and_reveal.CollectViews.AndridTextFieldFactory
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "skyflow"

    // ID for cvv gen: j3bd9c6e8ccb420685a43992ef9ca91d

    val config = Skyflow.Configuration(
            vaultID = "i5324c9b6d484c3a989084b878860517",
            vaultURL = "https://sb.area51.vault.skyflowapis.dev",
            tokenProvider = DemoTokenProvider()
    )


    private val skyflowClient = Skyflow.init(config)
    private val collectContainer = skyflowClient.container(Skyflow.ContainerType.COLLECT)


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("android-text-field", AndridTextFieldFactory(collectContainer))
    }
}

class DemoTokenProvider: Skyflow.TokenProvider {
    override fun getBearerToken(callback: Callback) {
        // Method to get bearer token for collect/reveal/invokeConnection
    }

}

