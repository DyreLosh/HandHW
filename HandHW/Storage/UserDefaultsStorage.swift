import Foundation

final class UserDefaultsStorage: Storable {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func store<T: Codable>(_ value: T, forKey key: String) throws {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            throw StorageError.encodingFailed(error)
        }
    }

    func retrieve<T: Codable>(forKey key: String) throws -> T {
        guard let data = userDefaults.data(forKey: key) else {
            throw StorageError.notFound
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }

    func remove(forKey key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
} 