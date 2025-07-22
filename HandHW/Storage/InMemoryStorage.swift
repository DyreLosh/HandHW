import Foundation

final class InMemoryStorage: Storable {
    private var storage: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.example.inmemorystorage.queue", attributes: .concurrent)

    func store<T: Codable>(_ value: T, forKey key: String) throws {
        queue.async(flags: .barrier) {
            self.storage[key] = value
        }
    }

    func retrieve<T: Codable>(forKey key: String) throws -> T {
        return try queue.sync {
            guard let value = storage[key] as? T else {
                throw StorageError.notFound
            }
            return value
        }
    }
    
    func remove(forKey key: String) throws {
        queue.async(flags: .barrier) {
            self.storage.removeValue(forKey: key)
        }
    }
} 