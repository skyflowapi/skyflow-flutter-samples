import Flutter
import Skyflow
import UIKit

class TextFieldView: NSObject, FlutterPlatformView {

    private var container: Container<CollectContainer>
    private var args: Dictionary<String, String>?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments params: Dictionary<String, String>,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        container: Container<CollectContainer>
    ) {
        self.container = container
        self.args = params


        super.init()
    }

    func getElementType(_ type: String) -> ElementType {
        switch type.uppercased() {
        case "CVV":
            return .CVV
        case "CARDHOLDER_NAME":
            return .CARDHOLDER_NAME
        case "CARD_NUMBER":
            return .CARD_NUMBER
        case "EXPIRATION_DATE":
            return .EXPIRATION_DATE
        default:
            return .CARDHOLDER_NAME
        }
    }
    
    class func getDefaultStyles() -> Styles {
        let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let base = Style(
            borderColor: UIColor.black,
            cornerRadius: 10,
            padding: padding,
            borderWidth: 1,
            textColor: UIColor.blue)
        let complete = Style(
            borderColor: UIColor.green,
            cornerRadius: 10,
            padding: padding,
            borderWidth: 2,
            textColor: UIColor.green)
        let focus = Style(
            borderColor: UIColor.blue,
            cornerRadius: 10,
            padding: padding,
            borderWidth: 2,
            textColor: UIColor.blue)
        let error = Style(
            borderColor: UIColor.red,
            cornerRadius: 10,
            padding: padding,
            borderWidth: 2,
            textColor: UIColor.red)
        return Styles(base: base, complete:complete, focus:focus, invalid: error)
    }

    func view() -> UIView {
        let tablename = args?["table"] ?? ""
        let column = args?["column"] ?? ""
        let label = args?["label"] ?? "default"
        let elementType = getElementType(args?["type"] ?? "")
        


        let collectInput = CollectElementInput(table: tablename, column: column, inputStyles: TextFieldView.getDefaultStyles(), label: label, type: elementType)
        let textField = self.container.create(input: collectInput)
        textField.backgroundColor = .white
        return textField
    }

}
