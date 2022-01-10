package com.example.collect_and_reveal.CollectViews
import Skyflow.Client
import Skyflow.CollectContainer
import android.content.Context
import io.flutter.Log
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

public class AndridTextFieldFactory(client: Client) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    var client: Client

    init {
        this.client = client
    }
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return AndroidTextField(context, viewId, client, creationParams)
    }
}