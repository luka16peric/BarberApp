import Foundation
import Combine // OVO JE KLJUČNO DA NESTANE GREŠKA

class AuthService: ObservableObject {
    
    // Funkcija za registraciju
    func register(firstName: String, lastName: String, email: String, password: String, role: String) {
        
        guard let url = URL(string: "http://localhost:5078/api/auth/register") else { return }
        
        let body: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "passwordHash": password,
            "role": role
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Greška pri pakiranju: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Greška u komunikaciji: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status servera: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("✅ USPJEH: Korisnik spremljen u bazu!")
                } else {
                    print("⚠️ Server odbio (Status: \(httpResponse.statusCode))")
                }
            }
        }.resume()
    }
}
