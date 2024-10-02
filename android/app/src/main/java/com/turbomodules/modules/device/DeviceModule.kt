package com.turbomodules.modules.device

import android.os.Build
import android.provider.Settings
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = DeviceModule.NAME)
class DeviceModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    companion object {
        const val NAME = "DeviceModule"  // This is the name used to reference the module from JavaScript
    }

    override fun getName(): String {
        return NAME
    }

    @ReactMethod
    fun getDeviceName(promise: Promise) {
        try {
            // Retrieve the device name using the Build class
            val deviceName = Build.MODEL  // Ensure this variable is correctly referenced
            promise.resolve(deviceName) // Resolve the promise with the device name
        } catch (e: Exception) {
            promise.reject("ERROR", e.message) // Handle any exceptions by rejecting the promise
        }
    }

    @ReactMethod
    fun getDeviceUniqueId(promise:Promise){
        try{
            val androidId = Settings.Secure.getString(reactApplicationContext.contentResolver, Settings.Secure.ANDROID_ID)
            promise.resolve(androidId) 
        }catch(e:Exception){
            promise.reject("ERROR",e.message)
        }
    }
}
