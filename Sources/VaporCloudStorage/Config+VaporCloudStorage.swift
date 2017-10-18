import Foundation
import Vapor

extension CloudStrageRestClient: ConfigInitializable {
    public init(config: Config) throws {
        guard let firebase = config["firebase"] else {
            throw ConfigError.missingFile("firebase")
        }
        guard let bucket = firebase["bucket"]?.string else {
            throw ConfigError.missing(key: ["bucket"], file: "firebase", desiredType: String.self)
        }
        self = CloudStrageRestClient(bucket: bucket,
                                     client: try config.resolveClient(),
                                     logger: try config.resolveLog())
    }
}

extension Config {
    public func addConfigurable<
        F: CloudStrageClinet
        >(storage: @escaping Config.Lazy<F>, name: String) {
        customAddConfigurable(closure: storage, unique: "storage", name: name)
    }
    public func resolveFirestore() throws -> CloudStrageClinet {
        return try customResolve(
            unique: "storage",
            file: "firebase",
            keyPath: ["storage"],
            as: CloudStrageClinet.self,
            default: CloudStrageRestClient.init
        )
    }
}
