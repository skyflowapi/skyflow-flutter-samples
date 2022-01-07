package com.example.invoke_connection.RevealViews

import Skyflow.Container
import Skyflow.RevealContainer
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class AndroidRevealLabelFactory(container: Container<RevealContainer>, callback: (String, AndroidRevealLabel) -> Unit) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private var container: Skyflow.Container<RevealContainer>
    private var callback: (String, AndroidRevealLabel) -> Unit

    init {
        this.container=  container
        this.callback = callback
    }
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        val revealLabel =  AndroidRevealLabel(context, container, creationParams)

        if (args != null) {
            this.callback(args.get("label") as String, revealLabel)
        }

        return revealLabel
    }
}