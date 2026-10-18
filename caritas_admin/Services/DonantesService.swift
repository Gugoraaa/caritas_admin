import Foundation

struct DonantesService {

    // Lista completa de donantes; solo para usuarios con rol admin (403 si no)
    static func obtenerDonantes() async throws -> [Donante] {
        let respuesta: [DonanteRespuesta] = try await APIService.get("/admin/donors")
        return respuesta.map { donante in
            donante.donante
        }
    }
}
