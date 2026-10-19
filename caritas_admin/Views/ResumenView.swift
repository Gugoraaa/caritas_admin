import SwiftUI

struct ResumenView: View {
    @State private var resumen: ResumenAdmin?
    @State private var cargando = false
    @State private var error: String?

    private let columnas = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    private func cargar() async {
        cargando = true
        error = nil
        do {
            resumen = try await AdminService.resumen()
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
                    Text("LLAMADAS COMPLETADAS")
                        .font(.caption.bold())
                        .foregroundColor(Palette.textoSecundario)
                    Text(datos.callsByResponsible.reduce(0) { $0 + $1.callCount }.formatted())
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
                seccion("RECAUDACIÓN POR SEMANA") {
                    let semanas = datos.fundraising.weeklyTotals
                    let maximo = max(semanas.compactMap { Double($0.total) }.max() ?? 0, 1)
                    if semanas.isEmpty {
                        vacio("No hay semanas registradas.")
                    } else {
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(Array(semanas.enumerated()), id: \.element.id) { indice, semana in
                                VStack(spacing: 6) {
                                    Text(pesos(semana.total))
                                        .font(.caption2.bold())
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Palette.acento)
                                        .frame(height: max(4, 105 * (Double(semana.total) ?? 0) / maximo))
                                    Text("S\(indice + 1)")
                                        .font(.caption)
                                        .foregroundColor(Palette.textoSecundario)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 155, alignment: .bottom)
                    }
                }

                seccion("RESULTADOS DE LLAMADAS · HISTÓRICO") {
                    let total = datos.callOutcomes.reduce(0) { $0 + $1.callCount }
                    if total == 0 {
                        vacio("No hay resultados registrados.")
                    } else {
                        ForEach(datos.callOutcomes) { resultado in
                            fila(resultado.outcome.capitalized, cantidad: resultado.callCount,
                                 total: total, color: Palette.acento)
                        }
                    }
                }

                seccion("LLAMADAS POR RESPONSABLE · HISTÓRICO") {
                    let maximo = datos.callsByResponsible.map(\.callCount).max() ?? 0
                    if datos.callsByResponsible.isEmpty {
                        vacio("No hay llamadas completadas.")
                    } else {
                        ForEach(datos.callsByResponsible) { persona in
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(persona.userName)
                                        .lineLimit(1)
                                    Spacer()
                                    Text("\(persona.callCount) llamadas · \(persona.promiseCount) promesas vinculadas")
                                        .foregroundColor(Palette.textoSecundario)
                                }
                                .font(.subheadline)
                                ProgressView(value: Double(persona.callCount), total: Double(max(maximo, 1)))
                                    .tint(Palette.acento)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                seccion("DISTRIBUCIÓN DE RIESGO") {
                    let riesgo = datos.donorRisk
                    if riesgo.total == 0 {
                        vacio("No hay donantes registrados.")
                    } else {
                        fila("Riesgo bajo", cantidad: riesgo.green, total: riesgo.total,
                             color: Palette.colorRiesgo("Bajo"))
                        fila("Riesgo medio", cantidad: riesgo.yellow, total: riesgo.total,
                             color: Palette.colorRiesgo("Medio"))
                        fila("Riesgo alto", cantidad: riesgo.red, total: riesgo.total,
                             color: Palette.colorRiesgo("Alto"))
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

    private func fila(_ titulo: String, cantidad: Int, total: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            HStack {
                Circle().fill(color).frame(width: 7, height: 7)
                Text(titulo).lineLimit(1)
                Spacer()
                Text(cantidad.formatted()).foregroundColor(Palette.textoSecundario)
                Text("\(Int(Double(cantidad) / Double(max(total, 1)) * 100))%")
                    .bold()
            }
            .font(.subheadline)
            ProgressView(value: Double(cantidad), total: Double(max(total, 1)))
                .tint(color)
        }
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
