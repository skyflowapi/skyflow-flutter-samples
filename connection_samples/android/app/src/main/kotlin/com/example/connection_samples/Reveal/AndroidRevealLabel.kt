package com.example.connection_samples.Reveal

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
                label = label,
                inputStyles = getDefaultStyles()
        )

        revealLabel = container.create(context, labelInput, RevealElementOptions())
        revealLabel.setBackgroundColor(Color.rgb(255, 255, 255))
    }
}
        
private fun getDefaultStyles() : Styles {
        val padding = Padding(8, 8, 8, 8)
        val base = Style(
        Color.BLACK
        1f,
        padding,
        4,
        R.font.roboto_light,
        Gravity.START,
        Color.BLUE
        )

        val invalid = Style(
        Color.RED,
        1f,
        padding,
        1,
        R.font.roboto_light,
        Gravity.START,
        Color.RED)
        return Styles(base, null, null, null, invalid)
}
