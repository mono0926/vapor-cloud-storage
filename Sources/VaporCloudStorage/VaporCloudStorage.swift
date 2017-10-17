import Vapor
import Foundation
import Console
import HTTP
import Debugging
import Multipart

public protocol CloudStrageClinet {
    func get(authToken: String,
             object: String) throws -> Response
    func post(authToken: String,
              object: String,
              data: Bytes,
              predefinedAcl: String?,
              cacheControl: String?) throws -> Response
}

public struct CloudStrageRestClient: CloudStrageClinet {
    private let baseURL: URL
    private let uploadURL: URL
    private let client: ClientFactoryProtocol
    private let logger: LogProtocol

    public init(bucket: String,
                client: ClientFactoryProtocol = EngineClientFactory(),
                logger: LogProtocol = ConsoleLogger(Terminal(arguments: []))) {
        self.baseURL = URL(string: "https://www.googleapis.com/storage/v1/b/\(bucket)/o")!
        self.uploadURL = URL(string: "https://www.googleapis.com/upload/storage/v1/b/\(bucket)/o")!
        self.client = client
        self.logger = logger
    }

    public func get(authToken: String,
                    object: String) throws -> Response {
        let res = try client.get("\(baseURL.absoluteString)/\(object.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
        logger.debug(res.body.bytes?.makeString() ?? "")
        return res
    }

    public func post(authToken: String,
                     object: String,
                     data: Bytes,
                     predefinedAcl: String? = nil,
                     cacheControl: String? = nil) throws -> Response {
        let request = Request(method: .post,
                              uri: uploadURL.absoluteString,
                              headers: createHeaders(authToken: authToken))
        var query: Node = [
            "uploadType": "multipart",
            "name": Node(object)]
        if let predefinedAcl = predefinedAcl {
            query["predefinedAcl"] = Node(predefinedAcl)
        }
        request.query = query
        var json = JSON()
        if let cacheControl = cacheControl {
            try json.set("cacheControl", cacheControl)
        }
        request.multipart = [Part(headers: ["Content-Type": "application/json"],
                                  body: try json.makeBytes()),
                             Part(headers: [:], body: data)
        ]
        let res = try client.respond(to: request)
        logger.debug(res.body.bytes?.makeString() ?? "")
        return res
    }

    private func createHeaders(authToken: String) -> [HeaderKey: String] {
        return ["Authorization": "Bearer \(authToken)"]
    }
}
