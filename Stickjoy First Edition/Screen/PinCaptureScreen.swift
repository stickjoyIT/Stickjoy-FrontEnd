//
//  PinCaptureScreen.swift
//  Stickjoy First Edition
//
//  Created by admin on 16/10/23.
//

import SwiftUI
import UserNotifications
import FirebaseMessaging
import Firebase
import Combine

struct PinCaptureScreen: View {
    @State private var text = ""
    @State private var keyPressed: String = ""
    @ObservedObject var uvm:UsuariosViewModel
    @Environment (\.dismiss) var dismiss
    @Environment (\.colorScheme) var scheme
    // Para adaptacion de dark y light mode
    let numberOfFields: Int
    @FocusState private var fieldFocus: Int?
    @State var enterValue = ["","","",""]
    @State var oldValue = ""
    @State var completeCode = false
    @State var alertReturn = false
    @State var pending = false
    
    @State var timeRemaining = 10 // Establece el tiempo inicial en segundos
    @State var timer: Timer?
    @State var intentos = 1
    @Binding var email:String
    @Binding var mensajeRegistro:String
    @State var alertMensaje = false
    @State var mensaje = ""
    @State var showAlertregister = false
    @Binding var lenguaje:String
    @Binding var idUser:String
    @State var alertPindValid = false
    @Binding var logueado:Bool
    @State var loadinSendPin = false
    var body: some View {
        VStack {
            HStack(alignment:.center) {
                Button(action: {
                    alertReturn = true
                    print("salir del pin code")
                }, label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                })
                .alert(isPresented: $alertReturn){
                    Alert(
                        title: Text(lenguaje == "es" ? "Mensaje" : "Message"),
                        message: Text(lenguaje == "es" ? "Para volver a ingresar, deberás solicitar otro PIN" : "To access again, you will need to request another PIN"),
                        primaryButton: .destructive(Text(lenguaje == "es" ? "Salirme" : "Go back")) {
                            uvm.deleteInactiveUser(idUser: idUser, responseData: { resp in
                                if resp.status == 200 {
                                    dismiss() // regresa al registro
                                    UserDefaults.standard.set(false, forKey: "validate")
                                }
                            })
                        },
                        secondaryButton: .cancel(Text(lenguaje == "es" ? "Cancelar" : "Cancel")) {
                            alertReturn = false // Cierra la alerta
                        }
                    )
                }
                Spacer()
                Text("PIN de Activación").font(.title)
                Spacer()
            }
            .padding()
            Text(mensajeRegistro)
                .font(.caption)
                .foregroundColor(Color.secondary)
            HStack(spacing: 20) {
                ForEach(0..<numberOfFields, id: \.self) { index in
                    TextField("", text: $enterValue[index], onEditingChanged: { editing in
                        if editing {
                            oldValue = enterValue[index]
                        }
                    })
                    .keyboardType(.numberPad)
                    .frame(width: 60, height: 60)
                    .cornerRadius(5)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(scheme == .dark ? .white : .black, lineWidth: 1)
                    )
                    .onChange(of: enterValue[index]) { newValue in
                        if !newValue.isEmpty {
                            // Update to new value if there is already an value.
                            if enterValue[index].count > 1 {
                                let currentValue = Array(enterValue[index])
                                
                                // ADD THIS IF YOU DON'T HAVE TO HIDE THE KEYBOARD WHEN THEY ENTERED
                                // THE LAST VALUE.
                                if oldValue.count == 0 {
                                   enterValue[index] = String(enterValue[index].suffix(1))
                                   return
                                 }
                                if !oldValue.isEmpty {
                                    if currentValue[0] == Character(oldValue) {
                                        enterValue[index] = String(enterValue[index].suffix(1))
                                    } else {
                                        enterValue[index] = String(enterValue[index].prefix(1))
                                    }
                                }
                            }
                            
                            // MARK: - Move to Next
                            if index == numberOfFields-1 {
                                // COMMENT IF YOU DON'T HAVE TO HIDE THE KEYBOARD WHEN THEY ENTERED
                                // THE LAST VALUE.
                                //fieldFocus = nil
                                completeCode = true
                            } else {
                                fieldFocus = (fieldFocus ?? 0) + 1
                            }
                        } else {
                            // MARK: - Move back
                            completeCode = false
                            fieldFocus = (fieldFocus ?? 0) - 1
                        }
                    }
                }
            }
            .padding()
            VStack(alignment:.trailing, spacing: 10) {
                Text(lenguaje == "es" ? "Si no te llegó el PIN, da clic en el siguiente botón:" : "If you didn´t receive the PIN, click on the following button:")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                HStack {
                    if !pending {
                        Button(lenguaje == "es" ? "Volver a enviar PIN" : "Send PIN again"){
                            alertMensaje = true
                        }
                        .alert(isPresented: $alertMensaje, content: {
                            Alert(
                                title: Text("Mensaje"),
                                message: Text(lenguaje == "es" ? "Se envió otro PIN a tu correo" : "We sent another PIN to your email"),
                                primaryButton: .default(Text("")){
                                    mensaje = "Se envió otro PIN a tu correo"
                                    intentos = intentos + 1
                                    switch intentos {
                                    case 1 :
                                        timeRemaining = 10
                                    case 2:
                                        timeRemaining = 30
                                    case 3:
                                        timeRemaining = 60
                                    default:
                                        timeRemaining = 10
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        pending = true
                                        startTimer()
                                    }
                                },
                                secondaryButton: .default(Text("Ok")){
                                    mensaje = "Se envió otro PIN a tu correo"
                                    intentos = intentos + 1
                                    switch intentos {
                                    case 1 :
                                        timeRemaining = 10
                                    case 2:
                                        timeRemaining = 30
                                    case 3:
                                        timeRemaining = 60
                                    default:
                                        timeRemaining = 10
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        pending = true
                                        startTimer()
                                    }
                                }
                            )
                        })
                    } else {
                        Text("\(timeRemaining) S")
                            .font(.title)
                            .onAppear {
                                // Iniciar el temporizador cuando aparece la vista
                            }
                            .onDisappear {
                                // Detener el temporizador cuando la vista desaparece
                                timer?.invalidate()
                            }
                    }
                }
            }
            Button(action: {
                if !loadinSendPin {
                    loadinSendPin = true
                    pending = false
                    timer?.invalidate()
                    let pinCode = enterValue.joined(separator: "")
                    uvm.validatePinCode(email: email, pin: Int(pinCode) ?? 0, responseData: { resp in
                        loadinSendPin = false
                        if resp.status == 200 {
                            let tokenPush = Messaging.messaging().fcmToken ?? ""
                            UserDefaults.standard.set(idUser, forKey: "id")
                            UserDefaults.standard.set(true, forKey: "login")
                            UserDefaults.standard.set(false, forKey: "validate")
                            saveIdDevice(id_device: tokenPush, id_user: idUser)
                            logueado = true
                        } else {
                            alertPindValid = true
                            mensaje = resp.message
                        }
                    })
                }
            }, label: {
                if !loadinSendPin {
                    Text("Validar")
                        .foregroundColor(completeCode && scheme == .dark ? Color.black : Color.white)
                        .frame(width: 250)
                        .padding()
                        .background(completeCode ? Color.primary : Color.secondary) // Set background color based on toggle state
                        .cornerRadius(80)
                        .padding()
                } else {
                    ProgressView()
                }
            })
            .disabled((!completeCode))
            .padding()
            .alert(isPresented: $alertPindValid, content: {
                Alert(title: Text("Mensaje"), message: Text(mensaje))
            })
            Spacer()
        }
        .onAppear {
            fieldFocus = 0
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                
            }
            intentos = 1
            timeRemaining = 10
            pending = true
            startTimer()
            nt()
            UserDefaults.standard.set(true, forKey: "validate")
        }
        .onDisappear{
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Cuando el tiempo llega a cero, detén el temporizador
                pending = false
                timer?.invalidate()
                if intentos == 3 {
                    uvm.deleteInactiveUser(idUser: idUser, responseData: { resp in
                        dismiss()
                        UserDefaults.standard.set(false, forKey: "validate")
                    })
                }
            }
        }
    }
    func nt () {
        let content = UNMutableNotificationContent()
        content.title = "Mensaje"
        content.title = "Se envio un PIN a tu correo"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    func resendPin(email:String){
        uvm.resendPin(email: email, responseData: { resp in
            alertMensaje = true
            if resp.status == 200 {
            } else {
                //mensaje = resp.message
            }
            
        })
    }
    func saveIdDevice(id_device:String, id_user:String){
        uvm.saveIdNotification(id_device: id_device, id_user: id_user)
    }
}

struct PinCaptureScreen_Previews: PreviewProvider {
    static var previews: some View {
        PinCaptureScreen(uvm: UsuariosViewModel(), numberOfFields: 4, email: .constant(""), mensajeRegistro: .constant("Fake"), lenguaje: .constant("es"), idUser: .constant(""), logueado: .constant(false))
    }
}
