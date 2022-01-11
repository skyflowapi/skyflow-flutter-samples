import Flutter
import Skyflow
import UIKit

class RevealLabelView: NSObject, FlutterPlatformView {
    private var revealContainer: Container<RevealContainer>
    private var revealLabel: Label
    private var args: Dictionary<String, String>?
    private var viewId: Int64
    private var messenger: FlutterBinaryMessenger

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        client: Client,
        arguments args: Dictionary<String, String>,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.revealContainer = client.container(type: ContainerType.REVEAL)!
        
        let token = args["token"]!
        let label = args["label"]!

        let revealInput = RevealElementInput(token: token, label: label)
        self.revealLabel = self.revealContainer.create(input: revealInput)
        self.viewId = viewId
        self.messenger = messenger!

        super.init()
    }


    func view() -> UIView {
        
        FlutterMethodChannel(name: "skyflow-reveal/\(self.viewId)", binaryMessenger: self.messenger)
            .setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                  if(call.method == "REVEAL") {
                      self.revealContainer.reveal(callback: DemoCallback(result))
                  } else {
                    result(FlutterMethodNotImplemented)
                  }
            })
        
        return self.revealLabel
    }
}

