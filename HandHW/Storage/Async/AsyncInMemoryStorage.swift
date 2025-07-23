import Foundation

final class AsyncInMemoryStorage: AsyncStorable {
    private var storage: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.example.asyncinmemorystorage.queue", attributes: .concurrent)

    func store<T: Codable>(_ value: T, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async(flags: .barrier) {
            self.storage[key] = value
            completion(.success(()))
        }
    }

    func retrieve<T: Codable>(forKey key: String, completion: @escaping (Result<T, Error>) -> Void) {
        queue.async {
            guard let value = self.storage[key] as? T else {
                completion(.failure(StorageError.notFound))
                return
            }
            completion(.success(value))
        }
    }
    
    func remove(forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async(flags: .barrier) {
            self.storage.removeValue(forKey: key)
            completion(.success(()))
        }
    }
} 