package io.libecosed.flutter_ecosed_example

import com.google.android.material.color.DynamicColors
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        DynamicColors.applyToActivitiesIfAvailable(this@MainApplication)
    }
}