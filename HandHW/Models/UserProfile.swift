import Foundation

struct UserProfile: Codable, Equatable, CustomStringConvertible {
    let id: FlexibleIdentifier
    let username: String

    var description: String {
        "UserProfile(id: \(id), username: \(username))"
    }
} 