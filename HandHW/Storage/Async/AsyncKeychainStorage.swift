import Foundation

final class AsyncKeychainStorage: AsyncStorable {
    private let service: String

    init(service: String = "com.example.app") {
        self.service = service
    }
    
    private func createQuery(forKey key: String) -> [String: Any] {
        var query: [String: Any] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service
        query[kSecAttrAccount as String] = key
        return query
    }

    func store<T: Codable>(_ value: T, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let data = try JSONEncoder().encode(value)
                var query = self.createQuery(forKey: key)
                
                let status = SecItemCopyMatching(query as CFDictionary, nil)
                
                if status == errSecSuccess {
                    let attributesToUpdate = [kSecValueData as String: data]
                    let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
                    if updateStatus != errSecSuccess {
                        completion(.failure(StorageError.saveFailed(NSError(domain: NSOSStatusErrorDomain, code: Int(updateStatus)))))
                        return
                    }
                } else if status == errSecItemNotFound {
                    query[kSecValueData as String] = data
                    let addStatus = SecItemAdd(query as CFDictionary, nil)
                    if addStatus != errSecSuccess {
                        completion(.failure(StorageError.saveFailed(NSError(domain: NSOSStatusErrorDomain, code: Int(addStatus)))))
                        return
                    }
                } else {
                    completion(.failure(StorageError.unknown(NSError(domain: NSOSStatusErrorDomain, code: Int(status)))))
                    return
                }
                completion(.success(()))
            } catch {
                completion(.failure(StorageError.encodingFailed(error)))
            }
        }
    }

    func retrieve<T: Codable>(forKey key: String, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().async {
            var query = self.createQuery(forKey: key)
            query[kSecReturnData as String] = kCFBooleanTrue
            query[kSecMatchLimit as String] = kSecMatchLimitOne

            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)

            guard status == errSecSuccess else {
                if status == errSecItemNotFound {
                    completion(.failure(StorageError.notFound))
                } else {
                    completion(.failure(StorageError.unknown(NSError(domain: NSOSStatusErrorDomain, code: Int(status)))))
                }
                return
            }

            guard let data = item as? Data else {
                completion(.failure(StorageError.decodingFailed(NSError(domain: "KeychainError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Данные из Keychain имеют неверный формат."]))))
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
            let query = self.createQuery(forKey: key)
            let status = SecItemDelete(query as CFDictionary)
            
            if status == errSecSuccess || status == errSecItemNotFound {
                completion(.success(()))
            } else {
                completion(.failure(StorageError.deleteFailed(NSError(domain: NSOSStatusErrorDomain, code: Int(status)))))
            }
        }
    }
} 