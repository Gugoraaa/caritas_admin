import Foundation

// Datos no sensibles del usuario en UserDefaults. Las vistas los leen con
// @AppStorage usando estas mismas llaves, así se actualizan solas.
struct UserSessionHelper {
    static let sesionActivaKey = "sesionActiva"
    static let nombreKey = "usuarioNombre"
    static let emailKey = "usuarioEmail"
    static let rolKey = "usuarioRol"

    static func guardarUsuario(_ usuario: Usuario) {
        UserDefaults.standard.set(usuario.name, forKey: nombreKey)
        UserDefaults.standard.set(usuario.email, forKey: emailKey)
        UserDefaults.standard.set(usuario.role, forKey: rolKey)
    }

    static func iniciarSesion(token: String, usuario: Usuario) {
        KeychainHelper.guardarToken(token)
        guardarUsuario(usuario)
        UserDefaults.standard.set(true, forKey: sesionActivaKey)
    }

    // Botón "Cerrar sesión" y cualquier 401 del API. RaizView detecta el
    // cambio de sesionActiva y regresa a LoginView.
    static func cerrarSesion() {
        KeychainHelper.borrarToken()
        UserDefaults.standard.removeObject(forKey: nombreKey)
        UserDefaults.standard.removeObject(forKey: emailKey)
        UserDefaults.standard.removeObject(forKey: rolKey)
        UserDefaults.standard.set(false, forKey: sesionActivaKey)
    }
}
