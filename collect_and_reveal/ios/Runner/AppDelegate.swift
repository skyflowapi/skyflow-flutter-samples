import Flutter
import Skyflow
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Register collect and reveal plugins
        CollectPlugin.register(with: registrar(forPlugin: "skyflow_collect_plugin")!)
        RevealPlugin.register(with: registrar(forPlugin: "skyflow_reveal_plugin")!)

        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}



