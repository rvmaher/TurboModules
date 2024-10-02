package com.turbomodules.modules.toast

import android.widget.Toast
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = ToastModule.NAME)
class ToastModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    companion object {
        const val NAME = "ToastModule"
    }

    // Method to return the name of the module, which will be used in JavaScript
    override fun getName(): String {
        return NAME
    }

    // Example method callable from JavaScript to show a Toast
    @ReactMethod
    fun showToast(message: String, duration: Int) {
        Toast.makeText(reactApplicationContext, message, duration).show()
    }
}
