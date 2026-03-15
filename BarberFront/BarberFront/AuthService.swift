import SwiftUI
import Combine // OVO JE KLJUČNA LINIJA KOJA TI FALI NA SLICI

class AuthService: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Privremeni login da možemo raditi na dizajnu
        print("Pokušaj prijave s: \(email)")
        completion(true)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, role: String) {
        print("Registracija pozvana")
    }
}
