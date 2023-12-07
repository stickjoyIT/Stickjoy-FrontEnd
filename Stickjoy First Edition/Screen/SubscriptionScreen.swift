//
//  SubscriptionScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 10/08/23.
//  Nombre de Lista de Requerimientos: 18. Pantalla de Suscripción
//  Paulo: Tiene un pop up menu ya conectado, solo falta poner la info dentro.
//  ¿Qué falta?: Acción de botón de continuar. Llenar el menú de términos de suscripción.

import SwiftUI
import StoreKit

struct SubscriptionScreen: View {
    @EnvironmentObject private var store: Store
    @State private var isTermsMenuPresented = false
    @State var lenguaje = "es"
    @Environment (\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment:.top) {
            Color.yellow.ignoresSafeArea()
            VStack(alignment:.center) {
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title)
                    })
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .center, spacing: 8) {
                    Text(lenguaje == "es" ? "Suscripción" : "Subscription")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical)
                        .foregroundColor(.black)
                    
                    SubscriptionBenefitsSection(lenguaje:$lenguaje)
                    
                    Text(lenguaje == "es" ? "Al suscribirte aceptas nuestros términos de suscripción." : "By clicking you accept our subscription terms.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text(lenguaje == "es" ? "Términos de suscripción" : "Subscription Terms")
                        .foregroundColor(.black)
                        .onTapGesture {
                            isTermsMenuPresented.toggle()
                        }
                        .sheet(isPresented: $isTermsMenuPresented) {
                            SubscriptionTermsMenu(isPresented: $isTermsMenuPresented)
                        }
                }
            }
        }
        .onAppear {
            lenguaje = UserDefaults.standard.string(forKey: "lenguaje") ?? "es"
        }
    }
}

struct SubscriptionBenefitsSection: View {
    @EnvironmentObject private var store: Store
    @Binding var lenguaje:String
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Text(lenguaje == "es" ? "Beneficios de suscripción" : "Subscription Benefits")
                .foregroundColor(.black)
                .font(.headline)
            VStack(alignment: .leading, spacing: 24) {
                HStack{
                    Image("stickjoyLogoBlue")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(32)
                    Text(lenguaje == "es" ?"No más publicidad dentro de tus álbumes." : "No more adds inside your albums.")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                }
                HStack{
                    Image("stickjoyLogoBlue")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(32)
                    Text(lenguaje == "es" ?"Sube varias fotos/videos a la vez." : "Upload multiple photos/videos at once.")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                }
                HStack{
                    ForEach(store.allBooks, id:\.self){ book in
                        if !book.lock {
                            
                        }else{
                            BookRow(book: book) {
                                if let product = store.product(for: book.id){
                                    store.purchaseProduct(product: product)
                                }
                            }
                        }
                    }
                }
                //.frame(width: 250, height: 80)
                .background(Color.yellow)
                .cornerRadius(64)
                
            }
            .frame(width: 250)
            .padding(.horizontal)
            .padding(.vertical, 50)
        }
    }
}

struct SubscriptionScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubscriptionScreen()
        }
    }
}
