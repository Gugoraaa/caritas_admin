import SwiftUI

struct MensajeError: View {
    var mensaje: String
    var reintentar: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(Palette.error)

            Text(mensaje)
                .font(.body)
                .foregroundColor(Palette.textoPrincipal)
                .multilineTextAlignment(.center)

            Button {
                reintentar()
            } label: {
                Text("Reintentar")
                    .font(.headline)
                    .foregroundColor(Palette.superficie)
                    .padding(.horizontal, 24)
                    .frame(minHeight: 44)
                    .background(Palette.acento)
                    .clipShape(.capsule)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Palette.superficie)
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    MensajeError(mensaje: "No fue posible conectarse al servidor.") {}
        .padding()
        .background(Palette.fondo)
}
