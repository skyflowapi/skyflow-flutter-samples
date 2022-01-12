import Flutter
import Skyflow
import UIKit

class RevealForm: NSObject, FlutterPlatformView {
    private var revealContainer: Container<RevealContainer>
    private var revealForm: UIView
    private var args: Dictionary<String, String>?
    private var viewId: Int64
    private var messenger: FlutterBinaryMessenger

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        client: Client,
        arguments args: Dictionary<String, Any>,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.revealContainer = client.container(type: ContainerType.REVEAL)!
        
        
        self.revealForm = UIView()
        let stackView = UIStackView()
        revealForm.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        stackView.topAnchor.constraint(equalTo: revealForm.topAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: revealForm.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: revealForm.rightAnchor).isActive = true
        
        if let fields = args["fields"] as? [String: String] {
            for (label, token) in fields {
                let revealLabel = self.revealContainer.create(input: RevealElementInput(token: token, label: label))
                stackView.addArrangedSubview(revealLabel)
            }

        }

        
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
        
        return self.revealForm
    }
}

