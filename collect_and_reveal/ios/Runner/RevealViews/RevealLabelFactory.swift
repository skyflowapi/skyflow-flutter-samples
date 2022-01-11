import Flutter
import Skyflow
import UIKit

class RevealLabelFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var client: Client

    init(messenger: FlutterBinaryMessenger, client: Client) {
        self.messenger = messenger
        self.client = client
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let dictArgs = args as! Dictionary<String, String>
        let labelView = RevealLabelView(
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



