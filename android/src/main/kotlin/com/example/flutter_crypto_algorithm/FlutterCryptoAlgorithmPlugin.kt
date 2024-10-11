package com.example.flutter_crypto_algorithm

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class FlutterCryptoAlgorithmPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var aesAlgorithm: AesAlgorithm
    private lateinit var cryptoHelper: CryptoHelper

    private companion object {
        const val CRYPTO_CHANNEL = "flutter_crypto_algorithm"
        const val ENCRYPT_METHOD = "encrypt"
        const val DECRYPT_METHOD = "decrypt"
    }

    private val activityScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        aesAlgorithm = AesAlgorithm()
        cryptoHelper = CryptoHelper()
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CRYPTO_CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ENCRYPT_METHOD -> {
                val value = call.argument<String>("value")
                val privateKey = call.argument<String>("privateKey")
                val ivKey = call.argument<String>("ivKey") ?: ""
                if (value != null && privateKey != null) {
                    activityScope.launch {
                        flow {
                            val encryptedData = aesAlgorithm.encrypt(value, privateKey, ivKey)
                            emit(encryptedData)
                        }.flowOn(Dispatchers.IO).catch {
                            result.error(
                                CryptoHelper.CONSTANTS.ERR_VALID_KEY,
                                "Data to encrypt is null",
                                null
                            )
                        }.collect { encryptData ->
                            result.success(encryptData)
                        }
                    }
                } else {
                    result.error(
                        CryptoHelper.CONSTANTS.ERR_VALID_KEY,
                        "Data to encrypt is null",
                        null
                    )
                }
            }

            DECRYPT_METHOD -> {
                val value = call.argument<String>("value")
                val privateKey = call.argument<String>("privateKey")
                val ivKey = call.argument<String>("ivKey") ?: ""
                if (value != null && privateKey != null) {
                    activityScope.launch {
                        flow {
                            val decryptData = aesAlgorithm.decrypt(value, privateKey, ivKey)
                            emit(decryptData)
                        }.flowOn(Dispatchers.IO).catch {
                            result.error(
                                CryptoHelper.CONSTANTS.ERR_VALID_KEY,
                                "Data to decrypt is null",
                                null
                            )
                        }.collect { decryptData ->
                            result.success(decryptData)
                        }
                    }
                } else {
                    result.error(
                        CryptoHelper.CONSTANTS.ERR_VALID_KEY,
                        "Data to decrypt is null",
                        null
                    )
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        // Cancel the CoroutineScope to avoid memory leaks
        activityScope.cancel()
    }
}
