package com.example.collect_and_reveal.RevealViews

import Skyflow.Client
import Skyflow.Container
import Skyflow.ContainerType
import Skyflow.RevealContainer
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class AndroidRevealLabelFactory(client: Client) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private var client: Client

    init {
        this.client=  client
    }
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        val revealLabel =  AndroidRevealLabel(context, viewId, client, creationParams)


        return revealLabel
    }
}