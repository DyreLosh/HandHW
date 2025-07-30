import Foundation

final class AsyncStorageManager {
    private var strategy: AsyncStorable

    init(strategy: AsyncStorable) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: AsyncStorable) {
        self.strategy = strategy
    }

    func store<T: Codable>(_ value: T, forKey key: String) async throws {
        try await strategy.store(value, forKey: key)
    }

    func retrieve<T: Codable>(forKey key: String) async throws -> T {
        try await strategy.retrieve(forKey: key)
    }

    func remove(forKey key: String) async throws {
        try await strategy.remove(forKey: key)
    }
} 