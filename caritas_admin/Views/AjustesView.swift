import SwiftUI

struct AjustesView: View {
    @AppStorage(UserSessionHelper.nombreKey) private var nombre = ""
    @AppStorage(UserSessionHelper.emailKey) private var email = ""
    @AppStorage(UserSessionHelper.rolKey) private var rol = ""
    @State private var showConfirmacion = false

    // "admin" o "Admin" -> "Administrador" (el backend no es consistente con mayúsculas)
    var rolTexto: String {
        switch rol.lowercased() {
        case "admin":       return "Administrador"
        case "coordinador": return "Coordinador"
        case "":            return "Sin registro"
        default:            return rol.capitalized
        }
    }

    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Ajustes")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Palette.textoPrincipal)

                // Datos del usuario
                VStack(spacing: 0) {
                    renglon(etiqueta: "Nombre", valor: nombre.isEmpty ? "Sin registro" : nombre)
                    Divider()
                    renglon(etiqueta: "Correo", valor: email.isEmpty ? "Sin registro" : email)
                    Divider()
                    renglon(etiqueta: "Rol", valor: rolTexto)
                }
                .background(Palette.superficie)
                .clipShape(.rect(cornerRadius: 16))

                Button {
                    showConfirmacion.toggle()
                } label: {
                    Text("Cerrar sesión")
                        .font(.headline)
                        .foregroundColor(Palette.error)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(Palette.superficie)
                        .clipShape(.rect(cornerRadius: 16))
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
        }
        .alert("¿Quieres cerrar sesión?", isPresented: $showConfirmacion) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                // RaizView regresa a LoginView al cambiar la sesión
                UserSessionHelper.cerrarSesion()
            }
        }
    }

    func renglon(etiqueta: String, valor: String) -> some View {
        HStack {
            Text(etiqueta)
                .foregroundColor(Palette.textoSecundario)
            Spacer()
            Text(valor)
                .foregroundColor(Palette.textoPrincipal)
                .multilineTextAlignment(.trailing)
        }
        .font(.body)
        .padding(.horizontal, 20)
        .frame(minHeight: 52)
    }
}

#Preview {
    AjustesView()
}
