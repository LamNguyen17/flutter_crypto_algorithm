import Foundation
import CryptoSwift

class AesAlgorithm {
    private let cryptoHelper = CryptoHelper()

    func encrypt(value: String, privateKey: String, ivKey: String?) -> String? {
          let iv = cryptoHelper.genAESIvKey(ivKey: ivKey)
          let key = cryptoHelper.genAESSecretKey(secretKey: privateKey)

          do {
              let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5)
              let encryptedBytes = try aes.encrypt(Array(value.utf8))
              let encryptedData = Data(encryptedBytes)
              return encryptedData.base64EncodedString()
          } catch {
              print("Encryption error: \(error)")
              return nil
          }
      }

      func decrypt(value: String, privateKey: String, ivKey: String?) -> String {
          let iv = cryptoHelper.genAESIvKey(ivKey: ivKey)
          let key = cryptoHelper.genAESSecretKey(secretKey: privateKey)
          do {
              let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5)
              if let data = Data(base64Encoded: value) {
                  let decryptedBytes = try aes.decrypt([UInt8](data))
                  return String(bytes: decryptedBytes, encoding: .utf8) ?? CryptoHelper.errValidKey
              } else {
                  return CryptoHelper.errValidKey
              }
          } catch {
              return CryptoHelper.errUnexpectedError
          }
      }
}