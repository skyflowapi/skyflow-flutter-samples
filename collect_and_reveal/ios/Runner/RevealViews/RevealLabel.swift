import Flutter
import Skyflow
import UIKit

class RevealLabelView: NSObject, FlutterPlatformView {
    private var container: Container<RevealContainer>
    private var revealLabel: Label

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        container: Container<RevealContainer>,
        arguments args: Dictionary<String, String>,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.container = container
        
        let token = args["token"]!
        let label = args["label"]!

        let revealInput = RevealElementInput(token: token, label: label)
        self.revealLabel = self.container.create(input: revealInput)

        super.init()
    }


    func view() -> UIView {
        return self.revealLabel
    }
    
    // Set token on native Label view
    func setToken(_ token: String) {
        self.revealLabel.setToken(token)
    }

}

