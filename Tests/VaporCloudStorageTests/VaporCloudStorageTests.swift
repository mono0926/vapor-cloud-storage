import XCTest
import VaporCloudStorage

private let bucket = "YOUR_BUCKET"
private let authToken = "YOUR_AUTH_TOKEN"

class VaporCloudStorageTests: XCTestCase {
    let target: CloudStrageClinet = CloudStrageRestClient(bucket: bucket)

    func test() throws {

        let responsePost = try target.post(authToken: authToken,
                                           object: "test/test.png",
                                           data: FileManager.default.contents(atPath: "/Users/mono/Desktop/love.png")!.makeBytes(),
                                           predefinedAcl: "publicRead",
                                           cacheControl: "public, max-age=31536000") // one year
        XCTAssertEqual(responsePost.status.statusCode, 200)

        let responseGet = try target.get(authToken: authToken,
                                         object: "test/test.png")
        XCTAssertEqual(responseGet.status.statusCode, 200)
    }


    static var allTests = [
        ("test", test),
    ]
}
