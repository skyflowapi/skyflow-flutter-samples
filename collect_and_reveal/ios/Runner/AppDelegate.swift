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
        let textFieldFactory = TextFieldViewFactory(messenger: registrar!.messenger(), client: client)
        let revealLabelFactory = RevealLabelFactory(messenger: registrar!.messenger(), client: client)
        
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
                }
            })

            GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}



