package com.example.collect_and_reveal.CollectViews

import Skyflow.CollectContainer
import Skyflow.CollectElementOptions
import Skyflow.SkyflowElementType
import Skyflow.create
import Skyflow.utils.EventName
import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.EditText
import android.widget.TextView
import io.flutter.Log
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
                label = label
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
