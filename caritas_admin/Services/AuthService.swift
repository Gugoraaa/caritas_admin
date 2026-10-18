import Foundation

struct AuthService {

    static func login(email: String, password: String) async throws -> LoginResponse {
        // 1. Validar URL
        guard let url = URL(string: Env.apiBaseURL + "/login") else {
            throw APIError.desconocido
        }

        // 2. Configurar la petición POST: las credenciales viajan en el body
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(LoginRequest(email: email, password: password))

        // 3. Ejecutar la solicitud
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.sinConexion
        }

        // 4. Validar la respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.desconocido
        }

        switch httpResponse.statusCode {
        case 200...299:
            guard let respuesta = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                throw APIError.desconocido
            }
            return respuesta
        case 400, 401:
            // En el login un 401 significa credenciales malas, no sesión expirada
            throw APIError.credencialesIncorrectas
        case 500...599:
            throw APIError.errorDeServidor
        default:
            throw APIError.desconocido
        }
    }

    // Valida el token guardado y regresa el usuario dueño del token
    static func usuarioActual() async throws -> Usuario {
        return try await APIService.get("/me")
    }
}
