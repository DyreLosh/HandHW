import Foundation

final class AsyncInMemoryStorage: AsyncStorable {
    private var storage: [String: Any] = [:]

    func store<T: Codable>(_ value: T, forKey key: String) async throws {
        self.storage[key] = value
    }

    func retrieve<T: Codable>(forKey key: String) async throws -> T {
        guard let value = self.storage[key] as? T else {
            throw StorageError.notFound
        }
        return value
    }

    func remove(forKey key: String) async throws {
        self.storage.removeValue(forKey: key)
    }
} 