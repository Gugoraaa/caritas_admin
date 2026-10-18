import SwiftUI

struct UsuariosView: View {
    @State private var usuarios: [UsuarioAdmin] = []
    @State private var cargando = false
    @State private var cargado = false
    @State private var error: String?
    @State private var confirmarSalida = false

    private func cargar() async {
        cargando = true
        error = nil
        do {
            usuarios = try await AdminService.usuarios()
        } catch let fallo as APIError {
            error = fallo.mensaje
        } catch {
            self.error = APIError.desconocido.mensaje
        }
        cargando = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Usuarios")
                .font(.largeTitle.bold())
                .foregroundColor(Palette.textoPrincipal)

            if cargando && usuarios.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else if let error, usuarios.isEmpty {
                MensajeError(mensaje: error) { Task { await cargar() } }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        if usuarios.isEmpty {
                            Text("No hay usuarios registrados.")
                                .foregroundColor(Palette.textoSecundario)
                                .frame(maxWidth: .infinity)
                                .padding(28)
                        }
                        ForEach(usuarios) { usuario in
                            if usuario.id != usuarios.first?.id { Divider() }
                            HStack(spacing: 12) {
                                Text(iniciales(usuario.name))
                                    .font(.subheadline.bold())
                                    .foregroundColor(Palette.acento)
                                    .frame(width: 36, height: 36)
                                    .background(Palette.chip)
                                    .clipShape(.circle)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(usuario.name)
                                        .foregroundColor(Palette.textoPrincipal)
                                    Text(usuario.role.capitalized)
                                        .font(.subheadline)
                                        .foregroundColor(Palette.textoSecundario)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .frame(minHeight: 60)
                        }
                    }
                    .background(Palette.superficie)
                    .clipShape(.rect(cornerRadius: 16))
                }
                .refreshable { await cargar() }
            }

            if let error, !usuarios.isEmpty {
                Text(error).foregroundColor(Palette.error)
            }
            Spacer(minLength: 0)
            Button("Cerrar sesión") { confirmarSalida = true }
                .foregroundColor(Palette.error)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Palette.superficie)
                .clipShape(.rect(cornerRadius: 12))
                .buttonStyle(.plain)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 24)
        .background(Palette.fondo.ignoresSafeArea())
        .task {
            if !cargado {
                cargado = true
                await cargar()
            }
        }
        .alert("¿Quieres cerrar sesión?", isPresented: $confirmarSalida) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                UserSessionHelper.cerrarSesion()
            }
        }
    }
}
