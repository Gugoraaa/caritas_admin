import SwiftUI

struct ContentView: View {
    private enum Seccion: String, CaseIterable {
        case resumen = "Resumen"
        case llamadas = "Llamadas"
        case donantes = "Donantes"
        case casos = "Casos"
        case usuarios = "Usuarios"
    }

    @State private var seleccion: Seccion = .resumen

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                ForEach(Seccion.allCases, id: \.self) { seccion in
                    Button(seccion.rawValue) { seleccion = seccion }
                        .font(.subheadline.bold())
                        .foregroundColor(seleccion == seccion ? .white : Palette.textoPrincipal)
                        .padding(.horizontal, 14)
                        .frame(minHeight: 36)
                        .background(seleccion == seccion ? Palette.acento : .clear)
                        .clipShape(.capsule)
                        .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(Palette.superficie)
            .clipShape(.capsule)
            .padding(.top, 12)

            Group {
                switch seleccion {
                case .resumen: ResumenView()
                case .llamadas: LlamadasView()
                case .donantes: DonantesView()
                case .casos: CasosView()
                case .usuarios: UsuariosView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Palette.fondo.ignoresSafeArea())
        .tint(Palette.acento)
    }
}

#Preview {
    ContentView()
}
