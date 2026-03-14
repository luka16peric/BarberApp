import SwiftUI

struct ContentView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var role = "Client"
    @State private var isRegistering = false
    
    @StateObject var authService = AuthService()

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        Image(systemName: "scissors")
                            .font(.system(size: 70))
                            .foregroundColor(.brown)
                            .padding(.bottom, 5)
                        Text("BARBER PRO")
                            .font(.system(size: 24, weight: .black, design: .serif))
                    }
                    .padding(.top, 30)
                    
                    VStack(spacing: 15) {
                        if isRegistering {
                            CustomTextField(placeholder: "Ime", text: $firstName)
                            CustomTextField(placeholder: "Prezime", text: $lastName)
                        }
                        
                        CustomTextField(placeholder: "Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Lozinka", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        if isRegistering {
                            Picker("Uloga", selection: $role) {
                                Text("Klijent").tag("Client")
                                Text("Barber").tag("Barber")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        if isRegistering {
                            authService.register(
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                password: password,
                                role: role
                            )
                        } else {
                            print("Prijavljivanje...")
                        }
                    }) {
                        Text(isRegistering ? "KREIRAJ RAČUN" : "PRIJAVI SE")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button(action: { isRegistering.toggle() }) {
                        Text(isRegistering ? "Već imaš račun? Prijavi se" : "Nemaš račun? Registriraj se")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// OVO JE DIO KOJI JE NEDOSTAJAO (CustomTextField)
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
