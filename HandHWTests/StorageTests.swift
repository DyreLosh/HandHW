import XCTest
@testable import HandHW

final class UserDefaultsStorageTests: XCTestCase {

    var storage: UserDefaultsStorage!

    override func setUpWithError() throws {
        try super.setUpWithError()
        storage = UserDefaultsStorage(userDefaults: UserDefaults(suiteName: "TestSuite")!)
    }

    override func tearDownWithError() throws {
        if let suiteName = storage?.userDefaults.domainName {
            UserDefaults().removePersistentDomain(forName: suiteName)
        }
        storage = nil
        try super.tearDownWithError()
    }

    func testStoreAndRetrieveInt() throws {
        storage.store(123, forKey: "intKey")
        let value: Int? = storage.retrieve(forKey: "intKey")
        XCTAssertEqual(value, 123)
    }

    func testStoreAndRetrieveString() throws {
        storage.store("TestUser", forKey: "stringKey")
        let value: String? = storage.retrieve(forKey: "stringKey")
        XCTAssertEqual(value, "TestUser")
    }

    func testStoreAndRetrieveBool() throws {
        storage.store(true, forKey: "boolKey")
        let value: Bool? = storage.retrieve(forKey: "boolKey")
        XCTAssertEqual(value, true)
    }

    func testStoreAndRetrieveDouble() throws {
        storage.store(3.14, forKey: "doubleKey")
        let value: Double? = storage.retrieve(forKey: "doubleKey")
        XCTAssertEqual(value, 3.14)
    }

    func testStoreAndRetrieveUserProfile() throws {
        let profile = UserProfile(id: .int(1), username: "dinar")
        storage.store(profile, forKey: "profileKey")
        let value: UserProfile? = storage.retrieve(forKey: "profileKey")
        XCTAssertEqual(value, profile)
    }
}
