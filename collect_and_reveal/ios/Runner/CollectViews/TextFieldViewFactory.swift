import Flutter
import Skyflow
import UIKit

class TextFieldViewFactory: NSObject, FlutterPlatformViewFactory {
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
        let params = args as? Dictionary<String, String> ?? [:]
        return TextFieldView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: params,
            binaryMessenger: messenger,
            client: client)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
    }
}
