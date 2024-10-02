package com.turbomodules.modules.registry

import com.facebook.react.ReactPackage
import com.turbomodules.modules.toast.ToastPackage
import com.turbomodules.modules.device.DevicePackage

object NativeModulesRegistry {
    fun getPackages(): List<ReactPackage> {
        return listOf(
            ToastPackage(),
            DevicePackage()
        )
    }
}
