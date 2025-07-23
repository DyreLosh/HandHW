import Foundation

protocol AsyncStorable {
    func store<T: Codable>(_ value: T, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void)
    func retrieve<T: Codable>(forKey key: String, completion: @escaping (Result<T, Error>) -> Void)
    func remove(forKey key: String, completion: @escaping (Result<Void, Error>) -> Void)
} 