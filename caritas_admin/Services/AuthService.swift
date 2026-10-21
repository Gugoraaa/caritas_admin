import Foundation

struct AuthService {

    static func login(email: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: Env.apiBaseURL + "/login") else {
            throw APIError.desconocido
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(LoginRequest(email: email, password: password))

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.sinConexion
        }

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
            throw APIError.credencialesIncorrectas
        case 500...599:
            throw APIError.errorDeServidor
        default:
            throw APIError.desconocido
        }
    }

    static func usuarioActual() async throws -> Usuario {
        return try await APIService.get("/me")
    }
}
