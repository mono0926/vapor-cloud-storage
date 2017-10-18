import XCTest
import VaporCloudStorage
import Foundation

private let bucket = "YOUR_BUCKET"
private let authToken = "YOUR_AUTH_TOKEN"

class VaporCloudStorageTests: XCTestCase {
    let target: CloudStrageClinet = CloudStrageRestClient(bucket: bucket)

    func test() throws {

        let object = "test/test.png"
        let responsePost = try target.post(authToken: authToken,
                                           object: object,
                                           data: FileManager.default.contents(atPath: "/Users/mono/Desktop/love.png")!.makeBytes(),
                                           predefinedAcl: "publicRead",
                                           cacheControl: "public, max-age=31536000") // one year
        XCTAssertEqual(responsePost.status.statusCode, 200)

        let responseGet = try target.get(authToken: authToken,
                                         object: object)
        XCTAssertEqual(responseGet.status.statusCode, 200)

        let expected = URL(string: "https://storage.googleapis.com/\(bucket)/\(object)")!
        XCTAssertEqual(target.getPublicUrl(object: object),
                       expected)
        _  = try Data(contentsOf: expected)

        let responseDelete = try target.delete(authToken: authToken,
                                            object: object)
        XCTAssertEqual(responseDelete.status.statusCode, 204)

        let responseGet2 = try target.get(authToken: authToken,
                                         object: object)
        XCTAssertEqual(responseGet2.status.statusCode, 404)
    }

    static var allTests = [
        ("test", test),
    ]
}
