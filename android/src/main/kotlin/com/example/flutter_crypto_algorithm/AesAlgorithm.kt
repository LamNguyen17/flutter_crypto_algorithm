package com.example.flutter_crypto_algorithm

import javax.crypto.*
import android.util.*

class AesAlgorithm {
    private val cryptoHelper = CryptoHelper()

    fun encrypt(value: String, privateKey: String, ivKey: String?): String {
        val ivSpec = cryptoHelper.genIvKey(ivKey)
        val secretKey = cryptoHelper.genSecretKey(CryptoHelper.AES.ALGORITHM, privateKey)
        val cipher = Cipher.getInstance(CryptoHelper.AES.TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec)
        val encryptedBytes = cipher.doFinal(value.toByteArray())
        return Base64.encodeToString(encryptedBytes, Base64.DEFAULT)
    }

    fun decrypt(value: String, privateKey: String, ivKey: String?): String {
        return try {
            val ivSpec = cryptoHelper.genIvKey(ivKey)
            val secretKey = cryptoHelper.genSecretKey(CryptoHelper.AES.ALGORITHM, privateKey)
            val decodedBytes = Base64.decode(value, Base64.DEFAULT)
            val cipher = Cipher.getInstance(CryptoHelper.AES.TRANSFORMATION)
            cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec)
            val decryptedBytes = cipher.doFinal(decodedBytes)
            String(decryptedBytes, Charsets.UTF_8)
        } catch (e: BadPaddingException) {
            CryptoHelper.CONSTANTS.DECRYPTION_ERR_VALID_KEY
        } catch (e: IllegalBlockSizeException) {
            CryptoHelper.CONSTANTS.DECRYPTION_ERR_INCORRECT_BLOCK_SIZE
        } catch (e: Exception) {
            CryptoHelper.CONSTANTS.DECRYPTION_ERR_UNEXPECTED_ERROR
        }
    }
}