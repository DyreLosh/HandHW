import Foundation

protocol Storable {
    func store<T: Codable>(_ value: T, forKey key: String) throws
    func retrieve<T: Codable>(forKey key: String) throws -> T
    func remove(forKey key: String) throws
} 