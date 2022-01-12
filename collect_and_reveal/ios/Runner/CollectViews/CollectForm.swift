import Flutter
import Skyflow
import UIKit

class CollectForm: NSObject, FlutterPlatformView {

    private var collectContainer: Container<CollectContainer>
    private var args: Dictionary<String, Dictionary<String, [String]>>?
    private var viewId: Int64
    private var messenger: FlutterBinaryMessenger

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments params: Dictionary<String, Dictionary<String, [String]>>,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        client: Client
    ) {
        self.collectContainer = client.container(type: ContainerType.COLLECT)!
        self.args = params
        self.messenger = messenger!
        self.viewId = viewId


        super.init()
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
        let collectForm = UIView()
        let stackView = UIStackView()
        
        collectForm.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        stackView.topAnchor.constraint(equalTo: collectForm.topAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: collectForm.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: collectForm.rightAnchor).isActive = true
        
        let styles = CollectForm.getDefaultStyles()

        if let fields = args!["fields"] {
            for (label, field) in fields {
                let label = label
                let tablename = field[0]
                let column = field[1]
                let elementType = getElementType(field[2])

        
                let collectInput = CollectElementInput(table: tablename, column: column, inputStyles: styles, label: label, type: elementType)
                let textField = self.collectContainer.create(input: collectInput)
                textField.backgroundColor = .white
                
                stackView.addArrangedSubview(textField)
            }
        }
        
        
        // set collect method call
        FlutterMethodChannel(name: "skyflow-collect/\(self.viewId)", binaryMessenger: self.messenger)
            .setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                  if(call.method == "COLLECT") {
                      self.collectContainer.collect(callback: DemoCallback(result))
                  } else {
                    result(FlutterMethodNotImplemented)
                  }
            })
        
        
        return collectForm
    }

}
