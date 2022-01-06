import Flutter
import Skyflow
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    // Initialize client
    private var client  = Client(Configuration(
                                    vaultID: "i5324c9b6d484c3a989084b878860517",
                                    vaultURL: "https://sb.area51.vault.skyflowapis.dev",
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
        
        // Register views
        self.registrar(forPlugin: "ios-skfylow")!.register(
            textFieldFactory,
            withId: "iOS-text-field")
    }
}


class DemoTokenProvider: TokenProvider {
    func getBearerToken(_ apiCallback: Callback) {
        // Method to get bearer token for collect/reveal/invokeConnection
    }
    
}
