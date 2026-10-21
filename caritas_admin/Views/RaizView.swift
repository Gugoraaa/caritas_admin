import SwiftUI

struct RaizView: View {
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
            sesionActiva = false
        } catch {
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
