//
//  ContentView.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 17/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var mensajeError: String = ""
    @State private var nums: Int = 124892
    @State private var isNavigating = false
    @State private var navigateNoOrders = false
    var body: some View {
        NavigationStack() {
            VStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 435, height: 200)
                  .background(
                    Image("top0")
                        .resizable(resizingMode: .stretch)
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 435, height: 200)
                      .clipped()
                  )
                
                HStack{Spacer()}
                Image("logo")
                    .resizable()
                    .frame(width: 311, height: 153)
                VStack{
                    
                    Text("Inicia sesión para\ncontinuar")
                        .foregroundColor(Color(red: 121/255, green: 125/255, blue: 127/255))
                        .font(.system(size: 24).bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 34)
                    TextField("", text: $username, prompt: Text("Usuario \(nums, specifier: "%")").foregroundColor(Color(red: 189/255, green: 195/255, blue: 199/255)))
                        .padding([.leading, .trailing], 42)
                        .padding(.top, 40)
                        .foregroundColor(Color(red: 0, green: 59/255, blue: 92/255))
                        .font(.system(size: 20).bold())
                        .accentColor(Color(red: 0, green: 59/255, blue: 92/255))
                    Rectangle()
                        .fill(Color(red: 0, green: 0.61, blue: 0.65))
                        .frame(height: 2)
                        .padding(.horizontal, 28)
                    SecureField("", text: $password, prompt: Text("Contraseña").foregroundColor(Color(red: 189/255, green: 195/255, blue: 199/255)))
                        .padding([.leading, .trailing], 42)
                        .padding(.top, 40)
                        .foregroundColor(Color(red: 0, green: 59/255, blue: 92/255))
                        .font(.system(size: 20).bold())
                    Rectangle()
                        .fill(Color(red: 0, green: 0.61, blue: 0.65))
                        .frame(height: 2)
                        .padding(.horizontal, 28)
                    Text(mensajeError)
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Iniciar Sesión", action: {
                        loginManager(username: username, password: password) { userId in
                            if (userId == 1) {
                                mensajeError = ""
                                UserDefaults.standard.setValue(userId, forKey: "userId")
                                navigateNoOrders = true
                            } else if (userId == 2) {
                                mensajeError = "Ha ocurrido un error. \n Revise su conexión a Internet"
                                navigateNoOrders = false
                            } else {
                                mensajeError = "Credenciales Incorrectas"
                                navigateNoOrders = false
                            }
                        }
                    })
                        .frame(width: 308, height: 54)
                        .background(Color(red: 0, green: 0.61, blue: 0.65))
                        .cornerRadius(50)
                        .font(.system(size: 24).bold())
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .navigationDestination(isPresented: $isNavigating) {
                            Dashboard().navigationBarBackButtonHidden()
                        }
                        .navigationDestination(isPresented: $navigateNoOrders) {
                            Dashboard().navigationBarBackButtonHidden()
                        }
                    
                    Spacer()
                }
                .frame(width: 348, height: 413)
                .background()
                .background(Color.black
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 1, y: 1))
                .cornerRadius(5)
                
                
                Spacer()
            }
            .ignoresSafeArea()
            .padding()
            .background(Color.white)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


