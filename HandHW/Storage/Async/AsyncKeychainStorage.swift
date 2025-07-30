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

    func store<T: Codable>(_ value: T, forKey key: String) async throws {
        let data = try JSONEncoder().encode(value)
        var query = createQuery(forKey: key)
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            let attributesToUpdate = [kSecValueData as String: data]
            let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if updateStatus != errSecSuccess {
                throw StorageError.saveFailed(NSError(domain: NSOSStatusErrorDomain, code: Int(updateStatus)))
            }
        } else if status == errSecItemNotFound {
            query[kSecValueData as String] = data
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            if addStatus != errSecSuccess {
                throw StorageError.saveFailed(NSError(domain: NSOSStatusErrorDomain, code: Int(addStatus)))
            }
        } else {
            throw StorageError.unknown(NSError(domain: NSOSStatusErrorDomain, code: Int(status)))
        }
    }

    func retrieve<T: Codable>(forKey key: String) async throws -> T {
        var query = createQuery(forKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw StorageError.notFound
            } else {
                throw StorageError.unknown(NSError(domain: NSOSStatusErrorDomain, code: Int(status)))
            }
        }
        guard let data = item as? Data else {
            throw StorageError.decodingFailed(NSError(domain: "KeychainError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Данные из Keychain имеют неверный формат."]))
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func remove(forKey key: String) async throws {
        let query = createQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        if !(status == errSecSuccess || status == errSecItemNotFound) {
            throw StorageError.deleteFailed(NSError(domain: NSOSStatusErrorDomain, code: Int(status)))
        }
    }
} 