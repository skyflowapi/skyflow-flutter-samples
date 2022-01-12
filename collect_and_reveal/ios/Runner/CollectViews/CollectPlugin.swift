import Foundation
import Flutter

public class CollectPlugin {
 class func register(with registrar: FlutterPluginRegistrar) {
     let viewFactory = CollectFormFactory(messenger: registrar.messenger())
     registrar.register(viewFactory, withId: "iOS-collect")
 }
}
