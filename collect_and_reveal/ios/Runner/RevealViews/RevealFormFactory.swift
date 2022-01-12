import Flutter
import Skyflow
import UIKit

class RevealFormFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var client: Client

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        self.client  = Client(ClientConfiguration().config)
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let dictArgs = args as! Dictionary<String, Any>
        let labelView = RevealForm(
            frame: frame,
            viewIdentifier: viewId,
            client: client,
            arguments: dictArgs,
            binaryMessenger: messenger)
                
        return labelView
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
    }
}



