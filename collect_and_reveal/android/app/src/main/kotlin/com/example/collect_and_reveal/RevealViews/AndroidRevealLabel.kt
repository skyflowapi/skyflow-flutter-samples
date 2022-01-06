package com.example.collect_and_reveal.RevealViews

import Skyflow.*
import Skyflow.utils.EventName
import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.EditText
import android.widget.TextView
import io.flutter.Log
import io.flutter.plugin.platform.PlatformView

internal class AndroidRevealLabel(context: Context, id: Int, container: Container<RevealContainer>, creationParams: Map<String?, Any?>?) :
        PlatformView {
    private val revealLabel: Skyflow.Label

    override fun getView(): View {
        return revealLabel
    }

    override fun dispose() {}

    init {
        val label = creationParams?.get("label") as String
        val token = creationParams?.get("token") as String
        val labelInput = RevealElementInput(
                token = token,
                label = label
        )

        revealLabel = container.create(context, labelInput, RevealElementOptions())
        revealLabel.setBackgroundColor(Color.rgb(255, 255, 255))
    }

    internal fun setToken(token: String) {
        revealLabel.setToken(token)
    }
}
