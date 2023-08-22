//
//  AdminPanelScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 11/08/23.
//  Nombre en Lista de Requerimientos: 14. Pop Up Menu - Panel de Admin
//  Paulo: Se convierte en pantalla en vez de Pop Up Menu. En este file, como tiene varias secciones, las puse aquí para no hacer muchos files. Recordar que esta pantalla solo es para los administradores del álbum.
//  ¿Qué falta?: Falta conectar con información real. La información que se necesita conectar está separada y ahí se indica en cada una. Borrar colaborador, y botón de invitar colaboradores que te lleve a InviteCollaboratorsScreen.swift.
//  Nota Importante: recomiendo que toda la info del álbum, esté guardada en el File Model/Album Info/AlbumContent.swift.

import SwiftUI

struct AdminPanelScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Text("Admin Panel")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                //Este VStack es para que esto esté leading y el título centered.
                VStack(alignment: .leading){
                    
                    //Esto está en este mismo código, abajo.
                    AlbumInfoSection()
                    
                    Divider()
                    
                    //Esto está en este mismo código, abajo.
                    CollaboratorsSection()
                    
                    Spacer()
                }
                    
                    VStack(alignment: .center) {
                        Button(action: {
                            //Añadir acción, te lleva a InviteCollaboratorsScreen para añadir colaboradores.
                        }) {
                            Text("Invite new collaborators")
                                .foregroundColor(.black)
                                .frame(width: 250)
                                .padding()
                                .background(Color.customYellow)
                                .cornerRadius(32)
                        }
                        .padding()
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AdminPanelScreen_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanelScreen()
    }
}

// Sección de Información de Álbum
struct AlbumInfoSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Album Name:")
                //Aquí va nombre original del album
                Text("Album Name")
                    .bold()
            }
            HStack {
                Text("Album Administrator:")
                //Aquí va nombre original del username
                Text("@username")
                    .bold()
            }
            HStack{
                Text("Album Creation:")
                //Aquí va fecha original de creación
                Text("12/05/23")
                    .bold()
            }
            HStack{
                Text("Album Creation: YYYY-MM-DD")
                //Aquí va fecha original de actualización (última subida o modificación)
                Text("23/05/23")
                    .bold()
            }
            HStack{
                Text("Album Last Update:")
                //Aquí va la cantidad original de elementos
                Text("89")
                    .bold()
            }
            HStack{
                Text("Album Type")
                //Aquí va el tipo de privacidad real
                Text("Collaborative")
                    .bold()
            }
            HStack{
                Text("Album Privacy:")
                //Aquí va el tipo de privacidad real
                Text("Private")
                    .bold()
            }
            HStack{
                Text("Number of Collaborators:")
                //Aquí va el número real de colaboradores
                Text("5")
                    .bold()
            }
        }
        .padding()
    }
}

//Sección de Colaboradores
struct CollaboratorsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Collaborators")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            // Este número de 5, es para datos dummies, debe llamar a los colaboradores reales.
            ForEach(0..<5) { _ in
                //Manda llamar a los colaboradores, está aquí abajo en el documento.
                CollaboratorRow()
            }
        }
        .padding(.bottom)
    }
}




// Sección de colaboradores. Debe llamar de back, los colaboradores que son
struct CollaboratorRow: View {
    var body: some View {
        HStack {
            //Aquí debe llamar a la foto real del colaborador.
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
        
            VStack(alignment: .leading, spacing: 8) {
                //Aquí debe llamar al colaborador real (Nombre de pila)
                Text("Collaborator Name")
                    .font(.headline)
                //Aquí debe llamar al colaborador real (Usuario)
                Text("@collaborator_username")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Delete") {
                // No tenemos en la lista de requerimientos el "Estás seguro que quieres eliminar colaborador?", entonces que lo elimine sin permis. En caso de que si se pueda, ya está este popover hecho: DeleteCollaboratorMenu.swift
            }
            .padding(8)
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(32)
        }
        .padding(.horizontal)
    }
}



//Esta sección la pusp ChatGPT
struct FilledButtonStyle: ButtonStyle {
    
    let color: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
