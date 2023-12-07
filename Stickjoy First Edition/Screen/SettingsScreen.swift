//
//  SettingsScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre de Lista de Requerimientos: 3. Pop Up Menu - Configuraciones
//  Paulo: Este pop up se convirtió en pantalla por temas de facilidad de navegación.
//  ¿Qué falta?: Faltan acciones de botones. Que si se apaguen notificaciones, falta que el botón de copiar link, se copie en portapapeles para pegar en donde sea y enviar a tus amigos. 

import SwiftUI
import StoreKit
import FirebaseMessaging
import Firebase

@available(iOS 16.0, *)
struct SettingsScreen: View {
    
    @EnvironmentObject private var store: Store
    @ObservedObject var uvm = UsuariosViewModel()
    @State private var isNotificationsEnabled = false
    @State private var selectedLanguage = "English"
    @State private var isTermsAndConditionsMenuPresented = false // Add this state variable
    @Binding var logueado:Bool
    @Binding var lenguaje:String
    @State var isAlert = false
    @State private var deleteAc = false
    @State var policy = false
    @State var termsEn = false
    @State var mySuscript = false
    var body: some View {
        
        VStack(alignment: .leading){
            HStack {
                Text(lenguaje == "es" ? "Configuraciones" : "Settings")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Image("stickjoyLogo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(32)
            }
            .padding(.horizontal, 24)
            .padding(.top, 6)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    /*Toggle(lenguaje == "es" ? "Notificaciones" : "Notifications", isOn: $isNotificationsEnabled)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                        .padding()
                        .onChange(of: isNotificationsEnabled) { newVal in
                            UserDefaults.standard.set(isNotificationsEnabled, forKey: "notifications")
                        }*/
                    
                    Button(action: {
                        // Añadir acción de abrir pantalla de Suscripción
                        mySuscript = true
                    }) {
                        Text(lenguaje == "es" ? "Mi suscripción" : "My subscription")
                            .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                            .padding()
                            .foregroundColor(Color.white)
                            .bold()
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .fullScreenCover(isPresented: $mySuscript, content: {
                        SubscriptionScreen()
                    })
                    
                    /*Button(action: {
                    }) {
                        Text(lenguaje == "es" ? "Copiar enlace de Stickjoy" : "Copy Stickjoy Link")
                            .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                            .padding()
                            .foregroundColor(Color.black)
                            .bold()
                            .background(Color.yellow)
                            .cornerRadius(16)
                    }.opacity(0.0)
                        .hidden()*/
                    
                    Text(lenguaje == "es" ? "Lenguaje" : "Language")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                        .padding()
                        .cornerRadius(16)
                    
                    HStack(alignment:.center) {
                        Button(action: {
                            lenguaje = "es"
                            UserDefaults.standard.set(lenguaje, forKey: "lenguaje")
                        }) {
                            HStack {
                                Text("Español")
                                    .fontWeight(lenguaje == "es" ? .bold : .regular)
                                    //.background(.thinMaterial)
                                    .cornerRadius(8)
                                    .padding()
                                Spacer()
                                if lenguaje == "es" {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(16)
                        
                        Button(action: {
                            lenguaje = "en"
                            UserDefaults.standard.set(lenguaje, forKey: "lenguaje")
                        }) {
                            HStack {
                                Text("English")
                                    .fontWeight(lenguaje == "en" ? .bold : .regular)
                                    //.background(.thinMaterial)
                                    .cornerRadius(8)
                                    .padding()
                                Spacer()
                                if lenguaje == "en" {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Set frame width to infinity
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(16)
                        
                        
                    }
                    
                    Button(lenguaje == "es" ? "Términos, Condiciones y Políticas de Privacidad" : "Terms, Conditions and Privacy Policies") {
                        if lenguaje == "es" {
                            policy = true
                        } else {
                            termsEn = true
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    .sheet(isPresented:$policy,content: {
                        TerminosCondiciones()
                    })
                    .sheet(isPresented:$termsEn,content: {
                        TerminosCondicionesIngles()
                    })
                    
                    Button(action: {
                        //Añadir acción de abrir popover: LogOutMenu para cerrar sesión
                        //logueado = false
                        isAlert = true
                    }) {
                        Text(lenguaje == "es" ? "Cerrar sesión" : "Log out")
                        .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(16)
                    }.confirmationDialog(lenguaje == "es" ? "Cerrar sesión" : "Log out", isPresented: $isAlert){
                        Button(lenguaje == "es" ? "Cerrar sesión" : "Log out", role: .destructive) {
                            UserDefaults.standard.set(false,forKey: "login")
                            logueado = false
                            let tokenPush = Messaging.messaging().fcmToken ?? ""
                            //print("token Uni:", tokenPush)
                            let idUser = UserDefaults.standard.string(forKey: "id") ?? ""
                            deleteDevice(id_device: tokenPush, id_user: idUser)
                        }
                        Button(lenguaje == "es" ? "Cancelar" : "Cancel", role: .cancel) {
                        }
                    } message : {
                        Text("¿Estás seguro de que quieres cerrar sesión?").font(.largeTitle)
                    }
                    
                    Button(action: {
                        //Añadir acción de abrir popover: LogOutMenu para cerrar sesión
                        deleteAc = true
                    }) {
                        
                        Text(lenguaje == "es" ? "Eliminar cuenta" : "Delete account")
                        .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(16)
                        
                    }.confirmationDialog(lenguaje == "es" ? "Eliminar cuenta" : "Delete account", isPresented: $deleteAc){
                        Button(lenguaje == "es" ? "Eliminar mi cuenta" : "Delete my account", role: .destructive) {
                            deleteAccount()
                        }
                        Button(lenguaje == "es" ? "Cancelar" : "Cancel", role: .cancel) {
                        }
                    } message : {
                        Text(lenguaje == "es" ? "¿Estás seguro de que quieres eliminar tu cuenta?" : "Are you sure you want to delete your account?").font(.largeTitle)
                    }
                    
                        Button(action: {
                            // Reemplaza "+1234567890" con el número de teléfono del destinatario, incluyendo el código de país pero sin espacios ni caracteres especiales.
                            let phoneNumber = "3310272570"
                            
                            // Escapar caracteres especiales en el número de teléfono
                            if let escapedPhoneNumber = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                                // Crear la URL de WhatsApp con el número de teléfono
                                if let whatsappURL = URL(string: "whatsapp://send?phone=\(escapedPhoneNumber)") {
                                    // Verificar si WhatsApp está instalado en el dispositivo
                                    if UIApplication.shared.canOpenURL(whatsappURL) {
                                        // Abrir WhatsApp con el chat directo al número especificado
                                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                                    } else {
                                        // WhatsApp no está instalado, puedes mostrar un mensaje de error
                                        print("WhatsApp no está instalado en este dispositivo.")
                                    }
                                }
                            }
                        }) {
                            Text(lenguaje == "es" ? "Contáctanos" : "Contact us")
                                .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
                                .padding()
                                .background(.thinMaterial)
                                .cornerRadius(16)
                        }
                    
                    
                   // Spacer()
                    
                }
                .padding(24)
                .navigationBarTitle(lenguaje == "es" ? "Configuraciones" : "Settings")
                .sheet(isPresented: $isTermsAndConditionsMenuPresented) {
                    TermsAndConditionsMenu(isPresented: $isTermsAndConditionsMenuPresented)
            }
                .onAppear{
                    let notifi = UserDefaults.standard.bool(forKey: "notifications")
                    isNotificationsEnabled = notifi
                    let id = UserDefaults.standard.string(forKey: "id") ?? ""
                    getDevices(id_user: id)
                    lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
                    print(lenguaje)
                }
            }
        }
    }
    
    func deleteDevice(id_device:String, id_user:String){
        uvm.deleteIdDevice(id_device: id_device, id_user: id_user)
    }
    func getDevices(id_user:String){
        uvm.getDevicesUser(id_user: id_user, devices: { devices in
            
        })
    }
    func deleteAccount(){
        let id = UserDefaults.standard.string(forKey: "id") ?? ""
        uvm.deleteAccount(id_user: id, responseData: { resp in
            if resp.status == 200 {
                UserDefaults.standard.set(false,forKey: "login")
                logueado = false
                let tokenPush = Messaging.messaging().fcmToken ?? ""
                print("token Uni:", tokenPush)
                let idUser = UserDefaults.standard.string(forKey: "id") ?? ""
                deleteDevice(id_device: tokenPush, id_user: idUser)
            } else {
                
            }
        })
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            SettingsScreen(logueado: .constant(false), lenguaje: .constant("es"))
        } else {
            // Fallback on earlier versions
        }
    }
}

struct BookRow: View {
    
    let book : SuscriptionItem
    let action : () -> Void
    
    var body: some View{
        Button(action:action) {
            HStack{
                VStack(alignment: .leading){
                    Text(book.title).bold()
                    Text(book.description).font(.body)
                }
                Spacer()
                if let price = book.price, book.lock {
                    VStack {
                        Text(price)
                        Text("Mensual")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Set frame width to infinity
            .foregroundColor(Color.black)
            .bold()
            .padding()
            .background(Color.white)
            .cornerRadius(64)
        }
    }
}

