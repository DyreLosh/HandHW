import Foundation

enum StorageError: Error, LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case notFound
    case saveFailed(Error)
    case deleteFailed(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "Не удалось закодировать данные: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Не удалось декодировать данные: \(error.localizedDescription)"
        case .notFound:
            return "Значение не найдено."
        case .saveFailed(let error):
            return "Не удалось сохранить данные: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Не удалось удалить данные: \(error.localizedDescription)"
        case .unknown(let error):
            return "Произошла неизвестная ошибка: \(error.localizedDescription)"
        }
    }
} 