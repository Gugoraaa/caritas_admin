import Foundation

enum Env {
    static let apiBaseURL = value(for: "API_BASE_URL")

    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            fatalError("Falta la variable \(key). Revisa Config.xcconfig e Info.plist.")
        }
        return value
    }
}
