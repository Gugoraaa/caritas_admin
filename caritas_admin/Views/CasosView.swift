import SwiftUI

struct CasosView: View {
    @State private var casos: [Caso] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var hasLoaded = false

    // Dos columnas del mismo ancho
    let columnas = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]

    func cargarCasos() async {
        isLoading = true
        errorMessage = nil
        do {
            casos = try await CasosService.obtenerCasos()
        } catch let error as APIError {
            errorMessage = error.mensaje
        } catch {
            errorMessage = APIError.desconocido.mensaje
        }
        isLoading = false
    }

    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Casos")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Palette.textoPrincipal)

                    Text("Cada donativo se asigna a una causa. Consulta el objetivo y a quién beneficia antes de llamar.")
                        .font(.title3)
                        .foregroundColor(Palette.textoSecundario)

                    if isLoading && casos.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 48)
                    } else if let errorMessage = errorMessage, casos.isEmpty {
                        MensajeError(mensaje: errorMessage) {
                            Task {
                                await cargarCasos()
                            }
                        }
                        .padding(.top, 12)
                    } else if casos.isEmpty {
                        Text("No hay casos registrados.")
                            .font(.body)
                            .foregroundColor(Palette.textoSecundario)
                            .padding(.top, 12)
                    } else {
                        LazyVGrid(columns: columnas, alignment: .leading, spacing: 24) {
                            ForEach(casos) { caso in
                                CasoCard(caso: caso)
                            }
                        }
                        .padding(.top, 12)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
            }
            .refreshable {
                await cargarCasos()
            }
        }
        .task {
            // Solo la primera vez; después se actualiza deslizando hacia abajo
            if !hasLoaded {
                hasLoaded = true
                await cargarCasos()
            }
        }
    }
}

#Preview {
    CasosView()
}
