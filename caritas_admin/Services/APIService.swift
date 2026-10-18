import Foundation

enum APIError: Error {
    case credencialesIncorrectas
    case sinAutenticacion
    case sinPermiso
    case errorDeServidor
    case sinConexion
    case desconocido

    var mensaje: String {
        switch self {
        case .credencialesIncorrectas:
            return "Correo o contraseña incorrectos."
        case .sinAutenticacion:
            return "Tu sesión expiró. Inicia sesión nuevamente."
        case .sinPermiso:
            return "Tu usuario no tiene permisos de administrador."
        case .errorDeServidor:
            return "Ocurrió un problema con el servidor. Intenta nuevamente."
        case .sinConexion:
            return "No fue posible conectarse al servidor."
        case .desconocido:
            return "No fue posible cargar la información. Intenta nuevamente."
        }
    }
}

// GET compartido por los servicios: arma la URL, manda el token y decodifica.
struct APIService {

    static func get<T: Decodable>(_ ruta: String) async throws -> T {
        // 1. Validar URL
        guard let url = URL(string: Env.apiBaseURL + ruta) else {
            throw APIError.desconocido
        }

        // 2. Configurar la petición con el token, si hay sesión
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = KeychainHelper.leerToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // 3. Realizar la petición asíncrona
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.sinConexion
        }

        // 4. Validar la respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.desconocido
        }

        switch httpResponse.statusCode {
        case 200...299:
            // 5. Decodificar de JSON a estructura Swift
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Error al decodificar \(ruta): \(error)")
                throw APIError.desconocido
            }
        case 401:
            // Token inválido o expirado: se cierra la sesión y la app regresa a Login
            UserSessionHelper.cerrarSesion()
            throw APIError.sinAutenticacion
        case 403:
            throw APIError.sinPermiso
        case 500...599:
            throw APIError.errorDeServidor
        default:
            print("Código de error del API en \(ruta): \(httpResponse.statusCode)")
            throw APIError.desconocido
        }
    }
}
