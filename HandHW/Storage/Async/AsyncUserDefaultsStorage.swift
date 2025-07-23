import Foundation

final class AsyncUserDefaultsStorage: AsyncStorable {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func store<T: Codable>(_ value: T, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let data = try JSONEncoder().encode(value)
                self.userDefaults.set(data, forKey: key)
                completion(.success(()))
            } catch {
                completion(.failure(StorageError.encodingFailed(error)))
            }
        }
    }

    func retrieve<T: Codable>(forKey key: String, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().async {
            guard let data = self.userDefaults.data(forKey: key) else {
                completion(.failure(StorageError.notFound))
                return
            }
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                completion(.success(value))
            } catch {
                completion(.failure(StorageError.decodingFailed(error)))
            }
        }
    }

    func remove(forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            self.userDefaults.removeObject(forKey: key)
            completion(.success(()))
        }
    }
} 