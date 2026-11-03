package com.example.movem

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.movem/google_config"

    override fun configureFlutterEngine(
        flutterEngine: io.flutter.embedding.engine.FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getMapsApiKey" -> {
                    val appInfo = packageManager.getApplicationInfo(
                        packageName,
                        android.content.pm.PackageManager.GET_META_DATA
                    )

                    val apiKey = appInfo.metaData
                        ?.getString("com.google.android.geo.API_KEY")

                    if (apiKey.isNullOrBlank()) {
                        result.error(
                            "API_KEY_MISSING",
                            "MAPS_API_KEY was not found.",
                            null
                        )
                    } else {
                        result.success(apiKey)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
