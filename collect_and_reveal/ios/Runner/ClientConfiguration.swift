import Foundation
import Skyflow

public class ClientConfiguration {
    var config = Configuration(
        vaultID: "<YOUR_VAULT_ID>",
        vaultURL: "<YOUR_VAULT_URL>",
        tokenProvider: DemoTokenProvider())
}
