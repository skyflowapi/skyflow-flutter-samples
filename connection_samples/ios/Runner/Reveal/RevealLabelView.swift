import Flutter
import Skyflow
import UIKit

class RevealLabelView: NSObject, FlutterPlatformView {
    private var container: Container<RevealContainer>
    private var revealLabel: UIView = UIView()

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

        let revealInput = RevealElementInput(token: token, inputStyles: RevealLabelView.getDefaultStyles(), label: label)
        let labelView = self.container.create(input: revealInput)
        
        self.revealLabel.addSubview(labelView)
        
        labelView.rightAnchor.constraint(equalTo: revealLabel.rightAnchor).isActive = true
        labelView.leftAnchor.constraint(equalTo: revealLabel.leftAnchor).isActive = true

        super.init()
    }
    
    class func getDefaultStyles() -> Styles {
        let padding = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 5)
        let base = Style(
            borderColor: UIColor.blue,
            cornerRadius: 1,
            padding: padding,
            borderWidth: 3,
            textColor: UIColor.black)
        let error = Style(
            borderColor: UIColor.red,
            cornerRadius: 1,
            padding: padding,
            borderWidth: 3,
            textColor: UIColor.red)
        return Styles(base: base, invalid: error)
    }


    func view() -> UIView {
        return self.revealLabel
    }

}



