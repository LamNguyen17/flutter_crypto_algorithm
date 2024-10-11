import Flutter
import UIKit
import RxSwift

let CRYPTO_CHANNEL = "flutter_crypto_algorithm"
let ENCRYPT_METHOD = "encrypt"
let DECRYPT_METHOD = "decrypt"

public class FlutterCryptoAlgorithmPlugin: NSObject, FlutterPlugin {
    private let disposeBag = DisposeBag() // For RxSwift memory management
    private let cryptoHelper = CryptoHelper()
    private let aesAlgorithm = AesAlgorithm()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CRYPTO_CHANNEL, binaryMessenger: registrar.messenger())
        let instance = FlutterCryptoAlgorithmPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func cryptoMethod(_ algorithmType: String, _ cryptoType: CryptoHelper.CryptoType, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let arguments = call.arguments as? [String: Any] {
            if let value = arguments["value"] as? String, !value.isEmpty,
               let privateKey = arguments["privateKey"] as? String, !privateKey.isEmpty {
                let ivKey = arguments["ivKey"] as? String
                activityLaunch(algorithmType: algorithmType, cryptoType: cryptoType,
                               value: value, privateKey: privateKey, ivKey: ivKey, result: result)
            } else {
                result(NSError(domain: CryptoHelper.errValuePrivateKeyNull, code: 0, userInfo: nil))
            }
        } else {
            result(NSError(domain: CryptoHelper.errValuePrivateRequired, code: 0, userInfo: nil))
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case ENCRYPT_METHOD:
            cryptoMethod(CryptoHelper.Aes.algorithm, CryptoHelper.CryptoType.encrypt, call, result)
        case DECRYPT_METHOD:
            cryptoMethod(CryptoHelper.Aes.algorithm, CryptoHelper.CryptoType.decrypt, call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func activityLaunch(algorithmType: String, cryptoType: CryptoHelper.CryptoType, value: String, privateKey: String, ivKey: String?, result: @escaping FlutterResult) {
        Observable.just(value)
            .flatMap { data -> Observable<String> in
                switch algorithmType {
                case CryptoHelper.Aes.algorithm:
                    switch cryptoType {
                    case CryptoHelper.CryptoType.encrypt:
                        return Observable.create { observer in
                            guard let encryptedData = self.aesAlgorithm.encrypt(value: data, privateKey: privateKey, ivKey: ivKey) else {
                                observer.onError(NSError(domain: CryptoHelper.errValidKey, code: 0, userInfo: nil))
                                return Disposables.create()
                            }
                            observer.onNext(encryptedData)
                            observer.onCompleted()
                            return Disposables.create()
                        }
                    case CryptoHelper.CryptoType.decrypt:
                        return Observable.create { observer in
                            let decryptedData = self.aesAlgorithm.decrypt(value: data, privateKey: privateKey, ivKey: ivKey)
                            if decryptedData == CryptoHelper.errValidKey ||
                                decryptedData == CryptoHelper.errIncorrectBlockSize ||
                                decryptedData == CryptoHelper.errUnexpectedError {
                                observer.onError(NSError(domain: CryptoHelper.errValidKey, code: 0, userInfo: [NSLocalizedDescriptionKey: decryptedData]))
                            } else {
                                observer.onNext(decryptedData)
                                observer.onCompleted()
                            }
                            return Disposables.create()
                        }
                    }
                default:
                    return Observable.error(NSError(domain: CryptoHelper.errValidKey, code: 0, userInfo: nil))
                }
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance) // Observe result on main thread
            .subscribe(
                onNext: { data in
                    result(data)
                },
                onError: { error in
                    result(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
