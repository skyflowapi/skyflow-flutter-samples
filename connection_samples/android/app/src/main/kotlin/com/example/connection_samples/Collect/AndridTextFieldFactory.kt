package com.example.connection_samples.Collect

import Skyflow.CollectContainer
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class AndridTextFieldFactory(container: Skyflow.Container<CollectContainer>) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    var container: Skyflow.Container<CollectContainer>

    init {
        this.container = container
    }
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return AndroidTextField(context, viewId, container, creationParams)
    }
}