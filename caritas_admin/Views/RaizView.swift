import SwiftUI

// Decide qué se muestra al abrir la app: Login o las pestañas (ContentView)
struct RaizView: View {
    // UserSessionHelper cambia esta llave al iniciar o cerrar sesión (también
    // cuando el API responde 401) y esta vista se redibuja sola.
    @AppStorage(UserSessionHelper.sesionActivaKey) private var sesionActiva = false
    @State private var verificando = true

    func verificarSesion() async {
        guard KeychainHelper.leerToken() != nil else {
            UserSessionHelper.cerrarSesion()
            verificando = false
            return
        }

        do {
            let usuario = try await AuthService.usuarioActual()
            UserSessionHelper.guardarUsuario(usuario)
            sesionActiva = true
        } catch APIError.sinAutenticacion {
            // APIService ya cerró la sesión al recibir el 401
            sesionActiva = false
        } catch {
            // Sin conexión o error del servidor: se conserva el token y se entra;
            // si el token ya no sirve, el primer 401 regresa a Login.
            sesionActiva = true
        }
        verificando = false
    }

    var body: some View {
        Group {
            if verificando {
                ZStack {
                    Palette.fondo
                        .ignoresSafeArea()
                    ProgressView()
                }
            } else if sesionActiva {
                ContentView()
            } else {
                LoginView()
            }
        }
        .task {
            await verificarSesion()
        }
    }
}

#Preview {
    RaizView()
}
