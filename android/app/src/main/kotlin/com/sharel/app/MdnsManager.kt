package com.sharel.com

import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MdnsManager(private val context: Context) {
    companion object {
        const val CHANNEL = "com.sharel.app/mdns"
        private const val TAG = "MdnsManager"
    }

    private val nsdManager: NsdManager? = context.getSystemService(Context.NSD_SERVICE) as? NsdManager
    private var mRegistrationListener: RegistrationListener? = null
    private var mServiceName: String = ""
    private var mPort: Int = 0

    fun setupChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "publishService" -> {
                    val serviceName = call.argument<String>("serviceName") ?: return@setMethodCallHandler
                    val serviceType = call.argument<String>("serviceType") ?: return@setMethodCallHandler
                    val port = call.argument<Int>("port") ?: return@setMethodCallHandler
                    val txtRecords = call.argument<Map<String, String>>("txtRecords") ?: emptyMap()

                    val success = publishService(serviceName, serviceType, port, txtRecords)
                    result.success(success)
                }
                "unpublishService" -> {
                    unpublishService()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun publishService(
        serviceName: String,
        serviceType: String,
        port: Int,
        txtRecords: Map<String, String>
    ): Boolean {
        if (nsdManager == null) {
            Log.e(TAG, "NsdManager not available")
            return false
        }

        try {
            mServiceName = serviceName
            mPort = port

            val serviceInfo = NsdServiceInfo().apply {
                this.serviceName = serviceName
                this.serviceType = serviceType
                this.port = port

                // Add TXT records (max 400 bytes total)
                if (txtRecords.isNotEmpty()) {
                    for ((key, value) in txtRecords) {
                        this.setAttribute(key, value)
                    }
                }
            }

            mRegistrationListener = RegistrationListener(serviceName)
            nsdManager.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, mRegistrationListener)
            Log.d(TAG, "Service registration initiated for $serviceName")
            return true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to publish service: ${e.message}", e)
            return false
        }
    }

    private fun unpublishService() {
        if (nsdManager != null && mRegistrationListener != null) {
            try {
                nsdManager.unregisterService(mRegistrationListener)
                Log.d(TAG, "Service unregistered: $mServiceName")
            } catch (e: Exception) {
                Log.e(TAG, "Error unregistering service: ${e.message}", e)
            }
        }
    }

    private inner class RegistrationListener(val serviceName: String) : NsdManager.RegistrationListener {
        override fun onServiceRegistered(serviceInfo: NsdServiceInfo) {
            Log.i(TAG, "Service registered: ${serviceInfo.serviceName} on port ${serviceInfo.port}")
        }

        override fun onRegistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
            Log.e(TAG, "Service registration failed for $serviceName. Error code: $errorCode")
        }

        override fun onServiceUnregistered(serviceInfo: NsdServiceInfo) {
            Log.i(TAG, "Service unregistered: ${serviceInfo.serviceName}")
        }

        override fun onUnregistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
            Log.e(TAG, "Service unregistration failed. Error code: $errorCode")
        }
    }
}
