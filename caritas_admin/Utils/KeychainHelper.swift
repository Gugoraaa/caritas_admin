import Foundation
import Security

// El token de sesión es información sensible: va en el Keychain, no en UserDefaults.
struct KeychainHelper {
    private static let servicio = "com.caritas.admin"
    private static let cuenta = "token"

    private static func consultaBase() -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: servicio,
            kSecAttrAccount as String: cuenta
        ]
    }

    static func guardarToken(_ token: String) {
        // 1. Convertir a binario (Data)
        guard let data = token.data(using: .utf8) else { return }

        // 2. Borrar el registro previo: el Keychain no sobrescribe solo
        SecItemDelete(consultaBase() as CFDictionary)

        // 3. Guardar
        var consulta = consultaBase()
        consulta[kSecValueData as String] = data
        consulta[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        SecItemAdd(consulta as CFDictionary, nil)
    }

    static func leerToken() -> String? {
        var consulta = consultaBase()
        consulta[kSecReturnData as String] = true
        consulta[kSecMatchLimit as String] = kSecMatchLimitOne

        var resultado: AnyObject?
        let estado = SecItemCopyMatching(consulta as CFDictionary, &resultado)

        guard estado == errSecSuccess,
              let data = resultado as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    static func borrarToken() {
        SecItemDelete(consultaBase() as CFDictionary)
    }
}
