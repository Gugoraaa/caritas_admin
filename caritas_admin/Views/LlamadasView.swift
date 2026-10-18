import SwiftUI

// Pantalla pendiente: por ahora solo muestra el título
struct LlamadasView: View {
    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                Text("Llamadas")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Palette.textoPrincipal)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
        }
    }
}

#Preview {
    LlamadasView()
}
