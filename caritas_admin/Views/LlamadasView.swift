import SwiftUI

struct LlamadasView: View {
    @State private var llamadas: [LlamadaAdmin] = []
    @State private var filtroUsuario: Int?
    @State private var cargando = false
    @State private var cargado = false
    @State private var error: String?

    private var responsables: [(id: Int, nombre: String)] {
        var vistos = Set<Int>()
        return llamadas.compactMap { llamada in
            guard let id = llamada.userId, let nombre = llamada.userName,
                  vistos.insert(id).inserted else { return nil }
            return (id: id, nombre: nombre)
        }
        .sorted { $0.nombre < $1.nombre }
    }

    private var visibles: [LlamadaAdmin] {
        llamadas.filter { filtroUsuario == nil || $0.userId == filtroUsuario }
    }

    private func cargar() async {
        cargando = true
        error = nil
        do {
            llamadas = try await AdminService.llamadas()
        } catch let fallo as APIError {
            error = fallo.mensaje
        } catch {
            self.error = APIError.desconocido.mensaje
        }
        cargando = false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Llamadas")
                    .font(.largeTitle.bold())
                    .foregroundColor(Palette.textoPrincipal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ChipFiltro(texto: "Todas", seleccionado: filtroUsuario == nil) {
                            filtroUsuario = nil
                        }
                        ForEach(responsables, id: \.id) { persona in
                            ChipFiltro(texto: persona.nombre,
                                       seleccionado: filtroUsuario == persona.id) {
                                filtroUsuario = persona.id
                            }
                        }
                    }
                }

                Text(filtroUsuario == nil ? "Todas las telemarketistas" :
                        (responsables.first { $0.id == filtroUsuario }?.nombre ?? "Sin responsable"))
                    .font(.subheadline)
                    .foregroundColor(Palette.textoSecundario)

                if cargando && llamadas.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 48)
                } else if let error, llamadas.isEmpty {
                    MensajeError(mensaje: error) { Task { await cargar() } }
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            Text("\(visibles.count) LLAMADAS · DONANTE / RESULTADO")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("TELEMARKETISTA")
                                .frame(width: 160, alignment: .leading)
                            Text("AGENDADA")
                                .frame(width: 130, alignment: .trailing)
                        }
                        .font(.caption.bold())
                        .foregroundColor(Palette.textoSecundario)
                        .padding(18)

                        if visibles.isEmpty {
                            Divider()
                            Text(llamadas.isEmpty ? "No hay llamadas registradas." :
                                    "No hay llamadas para esta persona.")
                                .foregroundColor(Palette.textoSecundario)
                                .frame(maxWidth: .infinity)
                                .padding(32)
                        }

                        ForEach(visibles) { llamada in
                            Divider()
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(colorResultado(llamada.result))
                                    .frame(width: 7, height: 7)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(llamada.donorFullName)
                                        .foregroundColor(Palette.textoPrincipal)
                                    Text(llamada.callStatus == "agendada" ? "Pendiente" :
                                            llamada.result.capitalized)
                                        .font(.subheadline.bold())
                                        .foregroundColor(colorResultado(llamada.result))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text(llamada.userName ?? "Sin responsable")
                                    .frame(width: 160, alignment: .leading)
                                Text(fechaAgendada(llamada.scheduledDate))
                                    .frame(width: 130, alignment: .trailing)
                            }
                            .font(.subheadline)
                            .foregroundColor(Palette.textoSecundario)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                        }
                    }
                    .background(Palette.superficie)
                    .clipShape(.rect(cornerRadius: 16))
                }
                if let error, !llamadas.isEmpty {
                    Text(error).foregroundColor(Palette.error)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
        }
        .background(Palette.fondo.ignoresSafeArea())
        .refreshable { await cargar() }
        .task {
            if !cargado {
                cargado = true
                await cargar()
            }
        }
    }

    private func colorResultado(_ resultado: String) -> Color {
        switch resultado.lowercased() {
        case "promesa de donativo", "compromiso confirmado":
            return Palette.colorRiesgo("Bajo")
        case "rechazó", "solicitar baja":
            return Palette.colorRiesgo("Alto")
        case "volver a llamar", "solicita volver a llamar":
            return Palette.acento
        default:
            return Palette.textoSecundario
        }
    }

    private func fechaAgendada(_ texto: String?) -> String {
        guard let texto, let fecha = fechaDesdeAPI(texto) else { return "Sin fecha" }
        let hora = String(texto.dropFirst(11).prefix(5))
        return "\(formatoFecha(fecha)) · \(hora)"
    }
}
