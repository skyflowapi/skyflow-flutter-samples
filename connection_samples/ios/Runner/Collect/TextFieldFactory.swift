import Flutter
import Skyflow
import UIKit

class TextFieldFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var container: Container<CollectContainer>

    init(messenger: FlutterBinaryMessenger, container: Container<CollectContainer>) {
        self.messenger = messenger
        self.container = container
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
            container: container)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
    }
}



