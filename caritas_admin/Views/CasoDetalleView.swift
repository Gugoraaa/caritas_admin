import SwiftUI

struct CasoDetalleView: View {
    var caso: Caso

    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .center, spacing: 20) {
                            ClaveCaso(clave: caso.clave, casoId: caso.id, tamano: 80)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(caso.nombre)
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(Palette.textoPrincipal)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(caso.beneficiarios)
                                    .font(.title3)
                                    .foregroundColor(Palette.textoSecundario)
                            }
                        }

                        VStack(spacing: 10) {
                            ProgressView(value: min(caso.recaudado, caso.meta), total: caso.meta)
                                .tint(Palette.colorCaso(caso.id))
                                .scaleEffect(x: 1, y: 2)

                            HStack {
                                Text("\(formatoPesos(caso.recaudado)) recaudado")
                                    .bold()
                                    .foregroundColor(Palette.textoPrincipal)
                                Spacer()
                                Text("\(caso.porcentaje)% del objetivo")
                                    .foregroundColor(Palette.textoSecundario)
                            }
                            .font(.headline)
                        }
                    }
                    .padding(28)
                    .background(Palette.superficie)
                    .clipShape(.rect(cornerRadius: 24))

                    HStack(alignment: .top, spacing: 24) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Información")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)
                                .padding(.bottom, 8)

                            DatoRow(etiqueta: "Beneficiario", valor: caso.beneficiarios)
                            Divider()
                            DatoRow(etiqueta: "Responsable", valor: caso.responsable)
                            Divider()
                            DatoRow(etiqueta: "Lugar", valor: caso.lugar)
                            Divider()
                            if let fechaFin = caso.fechaFin {
                                DatoRow(etiqueta: "Fecha límite", valor: formatoMes(fechaFin))
                            } else {
                                DatoRow(etiqueta: "Fecha límite", valor: "Sin registro")
                            }
                            Divider()
                            DatoRow(etiqueta: "Objetivo", valor: formatoPesos(caso.meta))
                        }
                        .padding(28)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.superficie)
                        .clipShape(.rect(cornerRadius: 24))

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Descripción")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)

                            Text(caso.objetivo.isEmpty ? "Sin descripción." : caso.objetivo)
                                .font(.body)
                                .foregroundColor(Palette.textoPrincipal)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(28)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.superficie)
                        .clipShape(.rect(cornerRadius: 24))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
            }
        }
        .navigationTitle("Caso")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CasoDetalleView(caso: casosEjemplo[0])
    }
}
