package com.example.invoke_connection

import Skyflow.*
import com.example.invoke_connection.CollectViews.AndridTextFieldFactory
import com.example.invoke_connection.RevealViews.AndroidRevealLabel
import com.example.invoke_connection.RevealViews.AndroidRevealLabelFactory
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "GENERATECVV") {
                Log.d("MC", call.arguments.toString())
                Log.d("MC", "Generate CVV called")
                val requestBody = call.argument<Map<String, Any>>("requestBody")


                val responseBody = call.argument<Map<String, Any>>("responseBody")
                if (requestBody != null && responseBody != null) {
                    // Gather all required params from flutter end
                    val body = convertBody(requestBody)
                    val convertedResponseBody = convertBody(responseBody)
                    val connectionUrl = call.argument<String>("connectionUrl")!!

                    val headerArg = call.argument<Map<String, Any>>("requestHeader")
                    val pathParamArg = call.argument<Map<String, Any>>("pathParams")
                    val queryParamArg = call.argument<Map<String, Any>>("queryParams")

                    val requestHeader = if (headerArg != null) JSONObject(headerArg as Map<*, *>?) else JSONObject()
                    val pathParams = if (pathParamArg != null) JSONObject(pathParamArg as Map<*, *>?) else JSONObject()
                    val queryParams = if (queryParamArg != null) JSONObject(queryParamArg as Map<*, *>?) else JSONObject()

                    val connectionConfig = ConnectionConfig(connectionUrl,
                            methodName = RequestMethod.POST,
                            requestHeader = requestHeader,
                            requestBody = body,
                            pathParams = pathParams,
                            queryParams = queryParams,
                            responseBody = convertedResponseBody)

                    Log.d("MC", convertedResponseBody.toString())
                    skyflowClient.invokeConnection(connectionConfig, DemoCallback(result))
                }
            } else {
                result.notImplemented()
            }

        }
    }

    private fun addRevealView(label: String, view: AndroidRevealLabel) {
        labelToViewMap.put(label, view)
    }

    private fun convertBody(requestBody: Map<String, Any>): JSONObject {
        var convertedRequestBody = HashMap<String, Any>()
        // Check if request body contains UI element
        for((key, value) in requestBody) {
            if(value is String && labelToViewMap.containsKey(value)) {
                convertedRequestBody[key] = labelToViewMap.get(value)!!
            } else {
                convertedRequestBody[key] = value
            }
        }

        return JSONObject(convertedRequestBody as Map<*, *>?);
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

