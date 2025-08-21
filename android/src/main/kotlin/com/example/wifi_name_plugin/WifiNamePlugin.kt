package com.example.wifi_name_plugin

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.net.wifi.WifiManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class WifiNamePlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wifi_name_plugin")
        channel.setMethodCallHandler(this)
        println("WifiNamePlugin: Plugin attached")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        println("WifiNamePlugin: Method called - ${call.method}")

        if(call.method == "getWifiName") {
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
                result.success("PERMISSION_REQUIRED")
                println("WifiNamePlugin: Permesso ACCESS_FINE_LOCATION mancante")
                return
            }

            val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val info = wifiManager.connectionInfo
            val ssid = info?.ssid?.replace(""", "")
            println("WifiNamePlugin: SSID trovato - $ssid")
            result.success(ssid)
        } else {
            println("WifiNamePlugin: Metodo non implementato")
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        println("WifiNamePlugin: Plugin detached")
    }
}