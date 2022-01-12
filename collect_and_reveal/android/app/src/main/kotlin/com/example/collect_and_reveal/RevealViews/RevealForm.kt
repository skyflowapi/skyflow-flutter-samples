package com.example.collect_and_reveal.RevealViews

import Skyflow.*
import Skyflow.utils.EventName
import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import com.example.collect_and_reveal.utils.DemoCallback
import io.flutter.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

internal class RevealForm(context: Context, id: Int, flutterEngine: FlutterEngine, client: Client, creationParams: Map<String?, Any?>?) :
        PlatformView {
    private val revealForm = LinearLayout(context)
    private val revealContainer = client.container(ContainerType.REVEAL)

    override fun getView(): View {
        return revealForm
    }


    override fun dispose() {}

    init {

        val CHANNEL = "skyflow-reveal/${id}"

        revealForm.orientation = LinearLayout.VERTICAL
        val fields = creationParams?.get("fields") as Map<String, String>
        for((label, token) in fields) {
            val labelInput = RevealElementInput(
                    token = token,
                    label = label
            )
            val revealLabel = revealContainer.create(context, labelInput, RevealElementOptions())
            revealForm.addView(revealLabel)
        }

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler{ call, result ->
            if (call.method == "REVEAL") {
                Log.d("MC", "Reveal has been called")
                this.revealContainer.reveal(DemoCallback(result), RevealOptions())
            } else {
                result.notImplemented()
            }}

        revealForm.setBackgroundColor(Color.rgb(255, 255, 255))
    }

}
