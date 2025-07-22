import Foundation

final class StorageManager {
    private var strategy: Storable

    init(strategy: Storable) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: Storable) {
        self.strategy = strategy
    }

    func store<T: Codable>(_ value: T, forKey key: String) throws {
        try strategy.store(value, forKey: key)
    }

    func retrieve<T: Codable>(forKey key: String) throws -> T {
        return try strategy.retrieve(forKey: key)
    }
    
    func remove(forKey key: String) throws {
        try strategy.remove(forKey: key)
    }
} 