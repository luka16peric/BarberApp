import SwiftUI
import Combine

class AuthService: ObservableObject {
    // Ova varijabla kontrolira koji ekran korisnik vidi
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Provjeri je li ovo tvoj port u Visual Studiju (Swagger URL)
    private let baseURL = "http://localhost:5078/api/Auth"

    // MARK: - LOGIN
    func login(email: String, password: String) {
        guard let url = URL(string: "\(baseURL)/login") else { return }
        
        // Resetiramo stanje prije slanja
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                // 1. Provjera mrežne greške
                if let error = error {
                    self.errorMessage = "Mrežna greška: \(error.localizedDescription)"
                    print("❌ Error: \(error)")
                    return
                }
                
                // 2. Provjera HTTP odgovora
                if let httpResponse = response as? HTTPURLResponse {
                    print("📩 Status Code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        print("✅ Login uspješan!")
                        withAnimation {
                            self.isAuthenticated = true
                        }
                    } else if httpResponse.statusCode == 401 {
                        self.errorMessage = "Pogrešan email ili lozinka."
                        self.isAuthenticated = false
                    } else {
                        self.errorMessage = "Greška servera: \(httpResponse.statusCode)"
                        self.isAuthenticated = false
                    }
                }
            }
        }.resume()
    }

    // MARK: - REGISTER
    func register(firstName: String, lastName: String, email: String, password: String) {
        guard let url = URL(string: "\(baseURL)/register") else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // PAŽNJA: Nazivi polja MORAJU biti isti kao u tvom C# RegisterDto-u
        let body: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "passwordHash": password, // C# često traži 'passwordHash' u DTO-u
            "phoneNumber": "000000000",
            "role": "Client"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        print("✅ Registracija uspješna!")
                        // Možeš dodati logiku da ga odmah ulogiraš ili vratiš na login
                    } else {
                        print("❌ Registracija neuspješna: \(httpResponse.statusCode)")
                        if let data = data, let msg = String(data: data, encoding: .utf8) {
                            print("Detalji: \(msg)")
                        }
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - LOGOUT
    func logout() {
        withAnimation {
            self.isAuthenticated = false
        }
    }
}
