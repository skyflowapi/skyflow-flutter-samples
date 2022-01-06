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
        case "PIN":
            return .PIN
        default:
            return .CARDHOLDER_NAME
        }
    }

    func view() -> UIView {
        let tablename = args?["table"] ?? ""
        let column = args?["column"] ?? ""
        let label = args?["label"] ?? "default"
        let elementType = getElementType(args?["type"] ?? "")

        let styles = Styles(base: Style(cornerRadius: 2, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), borderWidth: 1, textAlignment: .left, textColor: .blue))

        let collectInput = CollectElementInput(table: tablename, column: column, inputStyles: styles, label: label, type: elementType)
        let textField = self.container.create(input: collectInput)
        textField.backgroundColor = .white
        return textField
    }

}
