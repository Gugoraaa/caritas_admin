import SwiftUI

struct DonantesView: View {
    @State private var busqueda = ""
    @State private var filtroRiesgo = "Todos"
    @State private var filtroMetodo = "Todos"
    @State private var filtroCaso: Int? = nil

    @State private var donantes: [Donante] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var hasLoaded = false

    let opcionesRiesgo = ["Todos", "Bajo", "Medio", "Alto"]
    let opcionesMetodo = ["Todos", "Efectivo", "SPEI"]

    struct OpcionCaso: Identifiable {
        var id: Int
        var nombre: String
    }

    var opcionesCaso: [OpcionCaso] {
        var opciones: [OpcionCaso] = []
        let ordenados = donantes.sorted { ($0.casoId ?? 0) < ($1.casoId ?? 0) }
        for donante in ordenados {
            if let id = donante.casoId, !opciones.contains(where: { $0.id == id }) {
                opciones.append(OpcionCaso(id: id, nombre: donante.casoNombreCorto ?? "Caso \(id)"))
            }
        }
        return opciones
    }

    var donantesFiltrados: [Donante] {
        return donantes.filter { donante in
            let coincideBusqueda = busqueda.isEmpty
                || donante.nombre.localizedStandardContains(busqueda)
                || (donante.colonia?.localizedStandardContains(busqueda) ?? false)
            let coincideRiesgo = filtroRiesgo == "Todos" || donante.riesgo == filtroRiesgo
            let coincideMetodo = filtroMetodo == "Todos" || donante.metodoPago == filtroMetodo
            let coincideCaso = filtroCaso == nil || donante.casoId == filtroCaso
            return coincideBusqueda && coincideRiesgo && coincideMetodo && coincideCaso
        }
    }

    func cargarDonantes() async {
        isLoading = true
        errorMessage = nil
        do {
            donantes = try await DonantesService.obtenerDonantes()
        } catch let error as APIError {
            errorMessage = error.mensaje
        } catch {
            errorMessage = APIError.desconocido.mensaje
        }
        isLoading = false
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Palette.fondo
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Donantes")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)
                            Spacer()
                            Text(mesActual())
                                .font(.title3)
                                .foregroundColor(Palette.textoSecundario)
                        }

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Palette.textoSecundario)
                            TextField("Buscar por nombre o colonia", text: $busqueda)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 16)
                        .frame(minHeight: 48)
                        .background(Palette.chip)
                        .clipShape(.rect(cornerRadius: 12))

                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 10) {
                                    etiquetaFiltro("RIESGO")
                                    ForEach(opcionesRiesgo, id: \.self) { opcion in
                                        ChipFiltro(texto: opcion, seleccionado: filtroRiesgo == opcion) {
                                            filtroRiesgo = opcion
                                        }
                                    }

                                    Divider()
                                        .frame(height: 24)
                                        .padding(.horizontal, 6)

                                    etiquetaFiltro("MÉTODO")
                                    ForEach(opcionesMetodo, id: \.self) { opcion in
                                        ChipFiltro(texto: opcion, seleccionado: filtroMetodo == opcion) {
                                            filtroMetodo = opcion
                                        }
                                    }
                                }

                                HStack(spacing: 10) {
                                    etiquetaFiltro("CASO")
                                    ChipFiltro(texto: "Todos", seleccionado: filtroCaso == nil) {
                                        filtroCaso = nil
                                    }
                                    ForEach(opcionesCaso) { opcion in
                                        ChipFiltro(texto: opcion.nombre, seleccionado: filtroCaso == opcion.id) {
                                            filtroCaso = opcion.id
                                        }
                                    }
                                }
                            }
                        }

                        if isLoading && donantes.isEmpty {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.top, 48)
                        } else if let errorMessage = errorMessage, donantes.isEmpty {
                            MensajeError(mensaje: errorMessage) {
                                Task {
                                    await cargarDonantes()
                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                encabezadoTabla

                                if donantesFiltrados.isEmpty {
                                    Divider()
                                    Text(donantes.isEmpty
                                         ? "No hay donantes registrados."
                                         : "No hay donantes con estos filtros.")
                                        .font(.body)
                                        .foregroundColor(Palette.textoSecundario)
                                        .padding(32)
                                }

                                ForEach(donantesFiltrados) { donante in
                                    Divider()
                                    NavigationLink {
                                        DonanteDetalleView(donante: donante)
                                    } label: {
                                        DonanteRow(donante: donante)
                                            .background(Palette.superficie)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .background(Palette.superficie)
                            .clipShape(.rect(cornerRadius: 16))
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 24)
                }
                .refreshable {
                    await cargarDonantes()
                }
            }
            .toolbar(.hidden)
        }
        .task {
            if !hasLoaded {
                hasLoaded = true
                await cargarDonantes()
            }
        }
    }

    func etiquetaFiltro(_ texto: String) -> some View {
        Text(texto)
            .font(.subheadline)
            .foregroundColor(Palette.textoSecundario)
            .frame(width: 72, alignment: .leading)
    }

    var encabezadoTabla: some View {
        HStack(spacing: 16) {
            Text("\(donantesFiltrados.count) DONANTES")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("CASO")
                .frame(width: 170, alignment: .leading)
            Text("MONTO")
                .frame(width: 100, alignment: .trailing)
            Text("ÚLTIMO")
                .frame(width: 110, alignment: .trailing)
            Text("RIESGO")
                .frame(width: 90, alignment: .trailing)
            Spacer()
                .frame(width: 12)
        }
        .font(.footnote)
        .bold()
        .foregroundColor(Palette.textoSecundario)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

#Preview {
    DonantesView()
}
