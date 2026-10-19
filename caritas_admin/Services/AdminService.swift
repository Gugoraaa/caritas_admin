import Foundation

struct AdminService {
    static func resumen() async throws -> ResumenAdmin {
        try await APIService.get("/admin/summary")
    }

    static func llamadas() async throws -> [LlamadaAdmin] {
        try await APIService.get("/admin/calls")
    }

    static func usuarios() async throws -> [UsuarioAdmin] {
        try await APIService.get("/admin/users")
    }
}
