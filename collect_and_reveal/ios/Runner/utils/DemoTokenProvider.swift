import Foundation
import Skyflow

class DemoTokenProvider: TokenProvider {
    public func getBearerToken(_ apiCallback: Callback) {
        if let url = URL(string: "<YOUR_TOKEN_ENDPOINT_URL>") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ data, response, error in
                if(error != nil){
                    print(error!)
                    return
                }
                if let safeData = data {
                    do {
                        let x = try JSONSerialization.jsonObject(with: safeData, options:[]) as? [String: String]
                        if let accessToken = x?["accessToken"] {
                            apiCallback.onSuccess(accessToken)
                        }
                    }
                    catch {
                        apiCallback.onFailure(error)
                    }
                }
            }
            task.resume()
        }
    }
    
}
