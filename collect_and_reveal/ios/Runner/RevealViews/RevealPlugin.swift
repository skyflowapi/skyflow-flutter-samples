import Foundation
import Flutter

public class RevealPlugin {
 class func register(with registrar: FlutterPluginRegistrar) {
     let viewFactory = RevealFormFactory(messenger: registrar.messenger())
     registrar.register(viewFactory, withId: "iOS-reveal-label")
 }
}
