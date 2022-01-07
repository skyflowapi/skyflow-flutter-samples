package com.example.invoke_connection.RevealViews

import Skyflow.*
import android.content.Context
import android.graphics.Color
import android.view.View
import io.flutter.plugin.platform.PlatformView

internal class AndroidRevealLabel(context: Context, container: Container<RevealContainer>, creationParams: Map<String?, Any?>?) :
        PlatformView {
    private val revealLabel: Label

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
