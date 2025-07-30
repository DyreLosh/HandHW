import Foundation

protocol AsyncProtocol {
    func store<T: Codable>(_ value: T, forKey key: String) async throws
    func retrieve<T: Codable>(forKey key: String) async throws -> T
    func remove(forKey key: String) async throws
} 