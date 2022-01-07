package com.example.invoke_connection

import Skyflow.*
import com.example.invoke_connection.CollectViews.AndridTextFieldFactory
import com.example.invoke_connection.RevealViews.AndroidRevealLabel
import com.example.invoke_connection.RevealViews.AndroidRevealLabelFactory
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
    private val collectContainer = skyflowClient.container(ContainerType.COLLECT)
    private var revealContainer = skyflowClient.container(ContainerType.REVEAL)

    private var labelToViewMap = HashMap<String, AndroidRevealLabel>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register collect and reveal view factories
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("android-text-field", AndridTextFieldFactory(collectContainer))
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("android-reveal-label", AndroidRevealLabelFactory(revealContainer, ::addRevealView))

        // TODO: Add method call for generate cvv


    }

    private fun addRevealView(label: String, view: AndroidRevealLabel) {
        labelToViewMap.put(label, view)
    }
}

private class DemoTokenProvider: Skyflow.TokenProvider {
    override fun getBearerToken(callback: Callback) {
        // Method to get bearer token for collect/reveal/invokeConnection
    }

}

private class DemoCallback(result: MethodChannel.Result): Callback {

    private var result: MethodChannel.Result


    init {
        this.result = result
    }

    override fun onFailure(exception: Any) {
        result.error("500", "Operation Failed", null)
    }

    override fun onSuccess(responseBody: Any) {
        result.success(responseBody.toString())
    }

}

