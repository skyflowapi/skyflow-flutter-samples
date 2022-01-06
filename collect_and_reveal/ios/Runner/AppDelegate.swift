import Flutter
import Skyflow
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    // Initialize client
    private var client  = Client(Configuration(
                                    vaultID: "<YOUR_VAULT_ID>",
                                    vaultURL: "<YOUR_VAULT_URL>",
                                    tokenProvider: DemoTokenProvider()))
    private lazy var collectContainer = client.container(type: ContainerType.COLLECT)!
    private lazy var revealContainer = client.container(type: ContainerType.REVEAL)!
    private let CHANNEL = "skyflow"
    private var labelToViewMap = [:] as [String: RevealLabelView]
    
    func addRevealView(label: String, view: RevealLabelView) {
        self.labelToViewMap[label] = view
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        

        weak var registrar = self.registrar(forPlugin: "skyflow-ios")
        let textFieldFactory = TextFieldViewFactory(messenger: registrar!.messenger(), container: collectContainer)
        let revealLabelFactory = RevealLabelFactory(messenger: registrar!.messenger(), container: revealContainer, callback: addRevealView)
        
        // Register collect and reveal views
        self.registrar(forPlugin: "ios-skfylow")!.register(
            textFieldFactory,
            withId: "iOS-text-field")
        self.registrar(forPlugin: "skyflow_iOS")!.register(
            revealLabelFactory,
            withId: "iOS-reveal-label")
        
        // The main controller for invoking Native methods from dart
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let skyflowChannel = FlutterMethodChannel(name: "skyflow",
                                                      binaryMessenger: controller.binaryMessenger)
            skyflowChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if(call.method == "COLLECT") {
                    self.collectContainer.collect(callback: DemoCallback(result))
                } else if (call.method == "REVEAL") {
                    self.revealContainer.reveal(callback: DemoCallback(result))
                } else if (call.method == "SETTOKEN") {
                    guard let args = call.arguments else {
                        result(FlutterError(code: "400", message: "Arguments `label` and `token` required", details: nil))
                        return
                    }
                    if let dictArgs = args as? [String: Any],
                       let label = dictArgs["label"] as? String,
                       let token = dictArgs["token"] as? String{
                        self.labelToViewMap[label]?.setToken(token)
                        result("")
                    } else {
                        result(FlutterError(code: "400", message: "Bad arguments", details: nil))
                    }
                } else {
                    result(FlutterMethodNotImplemented)
                }
            })

            GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


class DemoTokenProvider: TokenProvider {
    func getBearerToken(_ apiCallback: Callback) {
        // Method to get bearer token for collect/reveal/invokeConnection
    }
    
}

class DemoCallback: Callback {
    
    private var resultCallback: FlutterResult
    
    init(_ callback: @escaping FlutterResult) {
        self.resultCallback = callback
    }
    
    func onSuccess(_ responseBody: Any) {
        let strContent = String(data: try! JSONSerialization.data(withJSONObject: responseBody), encoding: .utf8)
        self.resultCallback(strContent)
    }
    
    func onFailure(_ error: Any) {
        self.resultCallback("")
    }
    
}

