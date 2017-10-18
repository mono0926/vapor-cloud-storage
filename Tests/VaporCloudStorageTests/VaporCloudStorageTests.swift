import XCTest
import VaporCloudStorage

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

        let responseDelete = try target.delete(authToken: authToken,
                                            object: object)
        XCTAssertEqual(responseDelete.status.statusCode, 204)

        let responseGet2 = try target.get(authToken: authToken,
                                         object: object)
        XCTAssertEqual(responseGet2.status.statusCode, 404)
    }

    func testGetPublicUrl() {
        XCTAssertEqual(target.getPublicUrl(object: "test/test.png").absoluteString,
                       "https://storage.googleapis.com/ighost-dev.appspot.com/test/test.png")
    }


    static var allTests = [
        ("test", test),
    ]
}
