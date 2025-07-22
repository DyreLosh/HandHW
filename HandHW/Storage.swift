//
//  Storage.swift
//  HandHomeWorks
//
//  Created by dinar on 06.07.2025.
//

import Foundation

protocol KeyValueStorable {
    func store<T: Codable>(_ value: T, forKey key: String)
    func retrieve<T: Codable>(forKey key: String) -> T?
}

final class UserDefaultsStorage: KeyValueStorable {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func store<T: Codable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            print("[UserDefaultsStorage] Не удалось закодировать значение для ключа '\(key)': \(error)")
        }
    }

    func retrieve<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            print("[UserDefaultsStorage] Нет данных по ключу '\(key)'")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("[UserDefaultsStorage] Не удалось декодировать значение для ключа '\(key)': \(error)")
            return nil
        }
    }
}

enum FlexibleIdentifier: Codable, Equatable, CustomStringConvertible {
    case string(String)
    case int(Int)

    var description: String {
        switch self {
        case .string(let value): return value
        case .int(let value): return String(value)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(
                FlexibleIdentifier.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "FlexibleIdentifier должен быть строкой или числом"
                )
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}


struct UserProfile: Codable, CustomStringConvertible {
    let id: FlexibleIdentifier
    let username: String

    var description: String {
        "UserProfile(id: \(id), username: \(username))"
    }
}
