import Foundation

struct DonantesService {

    static func obtenerDonantes() async throws -> [Donante] {
        let respuesta: [DonanteRespuesta] = try await APIService.get("/admin/donors")
        return respuesta.map { donante in
            donante.donante
        }
    }
}
