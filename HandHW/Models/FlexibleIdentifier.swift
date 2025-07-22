import Foundation

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