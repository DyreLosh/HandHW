import Foundation

final class AsyncStorageManager {
    private var strategy: AsyncStorable

    init(strategy: AsyncStorable) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: AsyncStorable) {
        self.strategy = strategy
    }

    func store<T: Codable>(_ value: T, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        strategy.store(value, forKey: key, completion: completion)
    }

    func retrieve<T: Codable>(forKey key: String, completion: @escaping (Result<T, Error>) -> Void) {
        strategy.retrieve(forKey: key, completion: completion)
    }
    
    func remove(forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        strategy.remove(forKey: key, completion: completion)
    }
} 