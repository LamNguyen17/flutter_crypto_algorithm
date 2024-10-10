package com.example.flutter_crypto_algorithm

import android.util.Base64
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.*

class CryptoHelper {
    enum class CryptoType {
        ENCRYPT,
        DECRYPT,
    }

    object CONSTANTS {
        const val ERR_VALID_KEY = "Invalid key or corrupted data"
        const val ERR_INCORRECT_BLOCK_SIZE = "Incorrect block size"
        const val ERR_UNEXPECTED_ERROR = "Unexpected error"
        const val KEY_256 = 256
    }

    object AES {
        const val ALGORITHM = "AES"
        const val TRANSFORMATION = "AES/CBC/PKCS5PADDING"
        val EMPTY_IV_SPEC = IvParameterSpec(ByteArray(16) { 0x00.toByte() })
        val EMPTY_SECRET_KEY = SecretKeySpec(ByteArray(32) { 0x00 }, "AES")
    }

    private fun genExactlyCharacterLengthKey(key: String, length: Int): String {
        val bytes = key.toByteArray(Charsets.UTF_8)
        val hexString = bytes.joinToString("") { "%02x".format(it) }
        val hexLength = hexString.take(length).padEnd(length, '0');
        return hexLength;
    }

    fun genSecretKey(algorithmType: String, secretKey: String?): SecretKey? {
        return when (algorithmType) {
            AES.ALGORITHM -> {
                if (secretKey != null) {
                    val transform = genExactlyCharacterLengthKey(secretKey, 32)
                    SecretKeySpec(transform.toByteArray(), AES.ALGORITHM)
                } else {
                    AES.EMPTY_SECRET_KEY
                }
            }
            else -> AES.EMPTY_SECRET_KEY
        }
    }

    fun genIvKey(ivKey: String?): IvParameterSpec {
        return if (ivKey != null) {
            val transform = genExactlyCharacterLengthKey(ivKey, 16)
            IvParameterSpec(transform.toByteArray())
        } else {
            AES.EMPTY_IV_SPEC
        }
    }
}