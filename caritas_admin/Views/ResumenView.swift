import Charts
import SwiftUI

struct ResumenView: View {
    @State private var resumen: ResumenAdmin?
    @State private var casos: [Caso] = []
    @State private var metaSeleccionada: Double?
    @State private var cargando = false
    @State private var error: String?
    @State private var errorCasos: String?

    private let columnas = [
        GridItem(.flexible(), spacing: 16, alignment: .top),
        GridItem(.flexible(), spacing: 16, alignment: .top)
    ]

    private struct SegmentoRiesgo: Identifiable {
        let id: String
        let cantidad: Int
        let color: Color
    }

    private func cargar() async {
        cargando = true
        error = nil
        errorCasos = nil
        do {
            resumen = try await AdminService.resumen()
        } catch let fallo as APIError {
            error = fallo.mensaje
        } catch {
            self.error = APIError.desconocido.mensaje
        }

        do {
            casos = try await CasosService.obtenerCasos()
            metaSeleccionada = nil
        } catch let fallo as APIError {
            casos = []
            errorCasos = fallo.mensaje
        } catch {
            casos = []
            errorCasos = APIError.desconocido.mensaje
        }
        cargando = false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Resumen")
                        .font(.largeTitle.bold())
                        .foregroundColor(Palette.textoPrincipal)
                    Spacer()
                    if let resumen {
                        Text(nombreMes(resumen.period.start))
                            .foregroundColor(Palette.textoSecundario)
                    }
                }

                if let resumen {
                    contenido(resumen)
                } else if cargando {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                } else if let error {
                    MensajeError(mensaje: error) { Task { await cargar() } }
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
        }
        .background(Palette.fondo.ignoresSafeArea())
        .refreshable { await cargar() }
        .task { if resumen == nil { await cargar() } }
    }

    private func contenido(_ datos: ResumenAdmin) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 16) {
                tarjeta {
                    Text("RECAUDADO DEL MES")
                        .font(.caption.bold())
                        .foregroundColor(Palette.textoSecundario)
                    Text(pesos(datos.fundraising.total))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Palette.textoPrincipal)
                }
                tarjeta {
                    Text("LLAMADAS COMPLETADAS · HISTÓRICO")
                        .font(.caption.bold())
                        .foregroundColor(Palette.textoSecundario)
                    Text((datos.completedCallsTotal ?? datos.callOutcomes.reduce(0) { $0 + $1.callCount }).formatted())
                        .font(.title.bold())
                }
                tarjeta {
                    Text("DONANTES REGISTRADOS")
                        .font(.caption.bold())
                        .foregroundColor(Palette.textoSecundario)
                    Text(datos.donorRisk.total.formatted())
                        .font(.title.bold())
                }
            }

            LazyVGrid(columns: columnas, alignment: .leading, spacing: 16) {
                seccion("RIESGO SEGÚN ÚLTIMA DONACIÓN") {
                    donaRiesgo(datos.donorRisk)
                }
                seccion("LLAMADAS COMPLETADAS POR RESPONSABLE · HISTÓRICO") {
                    llamadasPorResponsable(datos.callsByResponsible)
                }
            }

            seccion("META VS AVANCE POR CAUSA") {
                avancePorCausa()
            }

            seccion("RESULTADOS DE LLAMADAS · HISTÓRICO") {
                if datos.callOutcomes.isEmpty {
                    vacio("No hay resultados registrados.")
                } else {
                    ForEach(datos.callOutcomes) { resultado in
                        HStack {
                            Text(resultado.outcome.capitalized)
                            Spacer()
                            Text(resultado.callCount.formatted())
                                .foregroundColor(Palette.textoSecundario)
                        }
                        .font(.subheadline)
                    }
                }
            }

            if let error {
                Text(error)
                    .foregroundColor(Palette.error)
                    .font(.subheadline)
            }
        }
    }

    private func donaRiesgo(_ riesgo: ResumenAdmin.Riesgo) -> some View {
        let segmentos = [
            SegmentoRiesgo(id: "Bajo", cantidad: riesgo.green, color: Palette.colorRiesgo("Bajo")),
            SegmentoRiesgo(id: "Medio", cantidad: riesgo.yellow, color: Palette.colorRiesgo("Medio")),
            SegmentoRiesgo(id: "Alto", cantidad: riesgo.red, color: Palette.colorRiesgo("Alto"))
        ]
        return VStack(alignment: .leading, spacing: 12) {
            if riesgo.total == 0 {
                vacio("No hay donantes registrados.")
            } else {
                Chart(segmentos) { segmento in
                    SectorMark(angle: .value("Donantes", segmento.cantidad),
                               innerRadius: .ratio(0.62), angularInset: 2)
                        .foregroundStyle(segmento.color)
                }
                .chartLegend(.hidden)
                .frame(height: 220)
                .overlay {
                    VStack(spacing: 2) {
                        Text(riesgo.total.formatted()).font(.title.bold())
                        Text("donantes").font(.caption).foregroundColor(Palette.textoSecundario)
                    }
                }
                ForEach(segmentos) { segmento in
                    HStack {
                        Circle().fill(segmento.color).frame(width: 9, height: 9)
                        Text("Riesgo \(segmento.id.lowercased())")
                        Spacer()
                        Text("\(segmento.cantidad) · \(Int(Double(segmento.cantidad) / Double(riesgo.total) * 100))%")
                            .foregroundColor(Palette.textoSecundario)
                    }
                    .font(.subheadline)
                }
            }
        }
    }

    private func llamadasPorResponsable(_ responsables: [ResumenAdmin.Responsable]) -> some View {
        let ordenados = responsables.sorted { $0.callCount > $1.callCount }
        let maximo = ordenados.first?.callCount ?? 0
        let lideres = ordenados.filter { $0.callCount == maximo }.map(\.userName).joined(separator: ", ")
        return VStack(alignment: .leading, spacing: 12) {
            if ordenados.isEmpty {
                vacio("No hay llamadas completadas con responsable.")
            } else {
                Chart(ordenados) { persona in
                    RuleMark(xStart: .value("Inicio", 0),
                             xEnd: .value("Llamadas", persona.callCount),
                             y: .value("Responsable", persona.userName))
                        .foregroundStyle(Palette.acento.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 3))
                    PointMark(x: .value("Llamadas", persona.callCount),
                              y: .value("Responsable", persona.userName))
                        .foregroundStyle(Palette.acento)
                        .symbolSize(110)
                        .annotation(position: .trailing) {
                            Text(persona.callCount.formatted()).font(.caption.bold())
                        }
                }
                .chartXScale(domain: 0...(maximo + 3))
                .chartXAxisLabel("Llamadas completadas")
                .frame(height: max(130, CGFloat(ordenados.count) * 65))
                Text("Más llamadas: \(lideres) (\(maximo))")
                    .font(.subheadline)
                    .foregroundColor(Palette.textoSecundario)
            }
        }
    }

    private func avancePorCausa() -> some View {
        let validas = casos.filter { $0.meta > 0 }
        let metaMaxima = max(validas.map(\.meta).max() ?? 0, 1)
        let avanceMaximo = max(validas.map { $0.recaudado / $0.meta * 100 }.max() ?? 0, 20)
        let seleccionada = metaSeleccionada.flatMap { meta in
            validas.min { abs($0.meta - meta) < abs($1.meta - meta) }
        }
        return VStack(alignment: .leading, spacing: 12) {
            if let errorCasos {
                vacio(errorCasos)
            } else if validas.isEmpty {
                vacio("No hay causas con una meta registrada.")
            } else {
                Chart(validas) { caso in
                    PointMark(x: .value("Meta", caso.meta),
                              y: .value("Avance", caso.recaudado / caso.meta * 100))
                        .foregroundStyle(Palette.colorCaso(caso.id))
                        .symbolSize(130)
                }
                .chartXScale(domain: 0...(metaMaxima * 1.1))
                .chartYScale(domain: 0...(avanceMaximo * 1.1))
                .chartXAxisLabel("Meta (MXN)")
                .chartYAxisLabel("Avance (%)")
                .chartXSelection(value: $metaSeleccionada)
                .frame(height: 300)

                if let seleccionada {
                    Text("\(seleccionada.nombre): \(formatoPesos(seleccionada.recaudado)) de \(formatoPesos(seleccionada.meta)) (\(seleccionada.porcentaje)%)")
                        .font(.subheadline)
                        .foregroundColor(Palette.textoPrincipal)
                } else {
                    Text("Toca un punto para ver la causa y sus montos.")
                        .font(.subheadline)
                        .foregroundColor(Palette.textoSecundario)
                }
            }
        }
    }

    private func seccion<Contenido: View>(_ titulo: String,
                                          @ViewBuilder contenido: () -> Contenido) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.caption.bold())
                .foregroundColor(Palette.textoSecundario)
            tarjeta { VStack(alignment: .leading, spacing: 12, content: contenido) }
        }
    }

    private func tarjeta<Contenido: View>(@ViewBuilder contenido: () -> Contenido) -> some View {
        VStack(alignment: .leading, spacing: 8, content: contenido)
            .frame(maxWidth: .infinity, minHeight: 105, alignment: .topLeading)
            .padding(20)
            .background(Palette.superficie)
            .clipShape(.rect(cornerRadius: 16))
    }

    private func vacio(_ texto: String) -> some View {
        Text(texto).foregroundColor(Palette.textoSecundario)
    }

    private func pesos(_ texto: String) -> String {
        guard let cantidad = Double(texto) else { return "—" }
        return formatoPesos(cantidad)
    }

    private func nombreMes(_ fecha: String) -> String {
        guard let valor = fechaDesdeAPI(fecha + "T12:00:00") else { return fecha }
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_MX")
        formato.dateFormat = "MMMM yyyy"
        return formato.string(from: valor).capitalized
    }
}
