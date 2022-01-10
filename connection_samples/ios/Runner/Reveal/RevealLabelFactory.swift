import Flutter
import Skyflow
import UIKit

class RevealLabelFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var container: Container<RevealContainer>
    private var callback: (String, RevealLabelView) -> Void

    init(messenger: FlutterBinaryMessenger, container: Container<RevealContainer>, callback: @escaping (String, RevealLabelView) -> Void) {
        self.messenger = messenger
        self.container = container
        self.callback = callback
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
            container: container,
            arguments: dictArgs,
            binaryMessenger: messenger)
        
        // Add created Label to the Map
        callback(dictArgs["label"]!, labelView)
        
        return labelView
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
    }
}
