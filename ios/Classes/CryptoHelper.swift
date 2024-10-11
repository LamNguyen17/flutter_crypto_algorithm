import Foundation
import CryptoSwift

class CryptoHelper {
    enum CryptoType {
        case encrypt
        case decrypt
    }
    struct Aes {
        static let algorithm = "AES"
        static let emptyIvSpec = Array<UInt8>(repeating: 0x00, count: 16)
        static let emptySecretKey = Array<UInt8>(repeating: 0x00, count: 32)
    }
    internal static let errValuePrivateKeyNull = "Value and privateKey must not be null or empty"
    internal static let errValuePrivateRequired = "Value and privateKey are required"
    internal static let errValidKey = "Invalid key or corrupted data"
    internal static let errIncorrectBlockSize = "Incorrect block size"
    internal static let errUnexpectedError = "Unexpected error"
    
    private func genExactlyCharacterLengthKey(key: String, length: Int) -> String {
        let bytes = Array(key.utf8)
        let hexString = bytes.map { String(format: "%02x", $0) }.joined()
        let hexLength = hexString.prefix(length).padding(toLength: length, withPad: "0", startingAt: 0)
        return String(hexLength)
    }
    
    func genSecretKey(algorithmType: String, secretKey: String?) -> Array<UInt8> {
        switch algorithmType {
        case CryptoHelper.Aes.algorithm:
            if let secretKey = secretKey {
                let transform = genExactlyCharacterLengthKey(key: secretKey, length: 32)
                return Array(transform.utf8)
            } else {
                return Aes.emptySecretKey
            }
        default:
            return Aes.emptySecretKey
        }
    }
    
    func genAESSecretKey(secretKey: String?) -> Array<UInt8> {
        if let secretKey = secretKey {
            let transform = genExactlyCharacterLengthKey(key: secretKey, length: 32)
            return Array(transform.utf8)
        } else {
            return Aes.emptySecretKey
        }
    }
    
    func genAESIvKey(ivKey: String?) -> Array<UInt8> {
        if let ivKey = ivKey {
            let transform = genExactlyCharacterLengthKey(key: ivKey, length: 16)
            return Array(transform.utf8)
        } else {
            return Aes.emptyIvSpec
        }
    }
}
