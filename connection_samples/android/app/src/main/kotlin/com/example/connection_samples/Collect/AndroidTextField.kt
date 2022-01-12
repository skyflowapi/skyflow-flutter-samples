package com.example.connection_samples.Collect

import Skyflow.CollectContainer
import Skyflow.CollectElementOptions
import Skyflow.SkyflowElementType
import Skyflow.create
import android.content.Context
import android.graphics.Color
import android.view.View
import io.flutter.plugin.platform.PlatformView

internal class AndroidTextField(context: Context, id: Int, container: Skyflow.Container<CollectContainer>, creationParams: Map<String?, Any?>?) :
        PlatformView {
    private val textView: Skyflow.TextField

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        val table = creationParams?.get("table") as String
        val column = creationParams?.get("column") as String
        val type = creationParams?.get("type") as String
        val label = creationParams?.get("label") as String
        val textFieldInput = Skyflow.CollectElementInput(
                table = table,
                column = column,
                type = getElementType(type),
                label = label,
                inputStyles = getDefaultStyles()
        )
        textView = container.create(context, textFieldInput, CollectElementOptions())
        textView.setBackgroundColor(Color.rgb(255, 255, 255))

    }


    private fun getElementType(type: String): SkyflowElementType {
        if(type == "CARD_NUMBER") {
            return SkyflowElementType.CARD_NUMBER
        } else if (type.equals("CARDHOLDER_NAME")) {
            return SkyflowElementType.CARDHOLDER_NAME
        } else if(type.equals("CVV")) {
            return SkyflowElementType.CVV
        } else if(type.equals("EXPIRATION_DATE")) {
            return SkyflowElementType.EXPIRATION_DATE
        } else if(type.equals("PIN")) {
            return SkyflowElementType.PIN;
        } else {
            return SkyflowElementType.INPUT_FIELD
        }
    }
}
        
private fun getDefaultStyles() : Styles {
        val padding = Padding(8, 8, 8, 8)
        val base = Style(
                Color.BLACK
                10f,
                padding,
                1,
                R.font.roboto_light,
                Gravity.START,
                Color.BLUE
        )
        val complete = Style(
                Color.GREEN,
                10f,
                padding,
                1,
                R.font.roboto_light,
                Gravity.END,
                Color.GREEN
        )
        val focus = Style(
                Color.BLACK,
                10f,
                padding,
                1,
                R.font.roboto_light,
                Gravity.START,
                Color.GREEN
        )
        val empty = Style(
                Color.YELLOW,
                10f,
                padding,
                1,
                R.font.roboto_light,
                Gravity.CENTER,
                Color.YELLOW
        )
        val invalid = Style(Color.RED, 10f, padding, 1, R.font.roboto_light, Gravity.START, Color.RED)
        return Styles(base, complete, error, focus, invalid)
}
