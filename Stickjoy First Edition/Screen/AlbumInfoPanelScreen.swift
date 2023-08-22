//
//  InfoPanelScreen.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 17/08/23.
//  Nombre en Lista de Requerimientos: 15. Pop Up Menu - Información de Álbum
//  Paulo: este pop up se convierte en pantalla ppor temas de navegación. Este album info puede acceder quien sea que tenga acceso al álbum, incluso si es público puedo acceder. El botón de editar solo puede acitvarse si participo.
//  ¿Qué falta?: Navegación (a diferencia del panel, este tiene botón de back porque se ingresa desde un botón en el encabezado del álbum. Conectar info con back (album, nombre, colaboradores, etc.), Botón de editar solo aparezca  o se active al ser participante.
//  Nota Importante: recomiendo que toda la info del álbum, esté guardada en el File Model/Album Info/AlbumContent.swift.

import SwiftUI

struct AlbumInfoPanelScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Button(action: {
                    //Añadir acción de regresar
                }){
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack(alignment: .center) {
                    
                    //Título
                    Text("Album Information")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                }
                
                //Este VStack es para que esto esté leading y el título centered.
                VStack(alignment: .leading){
                    
                    //Esto está en este mismo código, abajo.
                    AlbumInfoPanelSection()
                    
                    Divider()
                    
                    //Esto está en este mismo código, abajo.
                    AlbumCollaboratorsSection()
                    
                    Spacer()
                }
                    
                    VStack(alignment: .center) {
                        Button(action: {
                            
                          //El botón de editar solo aparece solo está activado o visible si el usuario participa en ese álbum.
                        }) {
                            Text("Edit Album")
                                .foregroundColor(.black)
                                .frame(width: 250)
                                .padding()
                                .background(Color.customYellow)
                                .cornerRadius(32)
                        }
                        
                        //Texto de aviso para usuarios que no son administradores. Recordar que si no es admin, no puede editar mas que eliminar sus propias fotos.
                        Text("If you are not admin, you can only delete the content you uploaded.")
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumInfoPanelScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlbumInfoPanelScreen()
    }
}

// Sección de Información de Álbum
struct AlbumInfoPanelSection: View {
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
struct AlbumCollaboratorsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Collaborators")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            // Este número de 5, es para datos dummies, debe llamar a los colaboradores reales.
            ForEach(0..<5) { _ in
                //Manda llamar a los colaboradores, está aquí abajo en el documento.
                InfoCollaboratorRow()
            }
        }
        .padding(.bottom)
    }
}




// Sección de colaboradores. Debe llamar de back, los colaboradores que son
struct InfoCollaboratorRow: View {
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
        }
        .padding(.horizontal)
    }
}



//Esta sección la puso ChatGPT
struct PanelFilledButtonStyle: ButtonStyle {
    
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
