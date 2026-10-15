import Foundation

/// Acceso a las variables definidas en Config.xcconfig (vía Info.plist).
enum Env {
    static let apiBaseURL = value(for: "API_BASE_URL")
    static let apiKey = value(for: "API_KEY")

    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            fatalError("Falta la variable \(key). Revisa caritas_admin/Config.xcconfig e Info.plist.")
        }
        return value
    }
}
