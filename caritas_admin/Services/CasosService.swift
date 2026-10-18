import Foundation

struct CasosService {

    static func obtenerCasos() async throws -> [Caso] {
        let respuesta: [CausaRespuesta] = try await APIService.get("/causas")
        return respuesta.map { causa in
            causa.caso
        }
    }
}
