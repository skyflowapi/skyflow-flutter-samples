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
        let textFieldFactory = TextFieldFactory(messenger: registrar!.messenger(), container: collectContainer)
        let revealLabelFactory = RevealLabelFactory(messenger: registrar!.messenger(), container: revealContainer, callback: addRevealView)
        
        // Register both collect and reveal views
        self.registrar(forPlugin: "iOS-collect")!.register(
            textFieldFactory,
            withId: "iOS-text-field")
        self.registrar(forPlugin: "iOS-reveal")!.register(
            revealLabelFactory,
            withId: "iOS-reveal-label")
        
        // The main controller for invoking Native methods from dart
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let skyflowChannel = FlutterMethodChannel(name: "skyflow",
                                                      binaryMessenger: controller.binaryMessenger)
            skyflowChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if(call.method == "GENERATECVV") {
                    guard let rawArgs = call.arguments else {
                        result(FlutterError(code: "400", message: "Arguments `label` and `token` required", details: nil))
                        return
                    }
                    if let args = rawArgs as? [String: Any],
                       let connectionURL = args["connectionURL"] as? String,
                       let requestBody = args["requestBody"] as? [String: Any],
                       let requestHeader = args["requestHeader"] as? [String: String],
                       let pathParams = args["pathParams"] as? [String: String],
                       let queryParams = args["queryParams"] as? [String: String],
                       let responseBody = args["responseBody"] as? [String: Any] {
                        let convertedRequestBody = self.convertBody(requestBody)
                        let convertedResponseBody = self.convertBody(responseBody)
                        
                        let connectionConfig = Skyflow.ConnectionConfig(
                            connectionURL: connectionURL,
                            method: Skyflow.RequestMethod.POST,
                            pathParams: pathParams,
                            queryParams: queryParams,
                            requestBody: convertedRequestBody,
                            requestHeader: requestHeader,
                            responseBody: convertedResponseBody
                        )
                        
                        self.client.invokeConnection(config: connectionConfig, callback: DemoCallback(result))
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
    
    func convertBody(_ body: [String: Any]) -> [String: Any] {
        
        var convertedRequestBody = [:] as [String: Any]
        
        // Check if request body contains UI element (only at the top level)
        for (key, rawValue) in body {
            if let value = rawValue as? String {
                if(labelToViewMap[key] != nil) {
                    convertedRequestBody[key] = labelToViewMap[value]!
                } else {
                    convertedRequestBody[key] = value
                }
            }
        }
        return convertedRequestBody;
    }
}


class DemoTokenProvider: TokenProvider {
    func getBearerToken(_ apiCallback: Callback) {
        // Method for obtaining bearer token
    }
    
}

class DemoCallback: Callback {
    
    private var resultCallback: FlutterResult
    
    init(_ callback: @escaping FlutterResult) {
        self.resultCallback = callback
    }
    
    func onSuccess(_ responseBody: Any) {
        let strContent = String(data: try! JSONSerialization.data(withJSONObject: responseBody), encoding: .utf8)
        // send result as a string
        self.resultCallback(strContent)
    }
    
    func onFailure(_ error: Any) {
        self.resultCallback("")
    }
    
}
