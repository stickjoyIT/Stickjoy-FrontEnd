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
    @Environment (\.dismiss) var dismiss
    @Binding var id_album:String
    @Binding var id_user:String
    @ObservedObject var avm = AlbumViewModel()
    @Binding var lenguaje:String
    @State var myId = UserDefaults.standard.string(forKey: "id") ?? ""
    @State var album_info = AlbumInfo(id: "", albumTitle: "", albumImage: "", albumAdministrator: "", albumCreation: "", albumUpdate: "", albumType: "", albumParticipants: "", albumPrivacy: 0, id_album: "", owner_id: "", description: "", userOwner: "", isCollap: false)
    @Binding var isColaborator:Bool
    @Binding var editC:Bool
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        //Añadir acción de regresar
                        dismiss()
                    }){
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    //Título
                    Text(lenguaje == "es" ? "Información de álbum" : "Album Information")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    Spacer()
                }
            }
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    //Este VStack es para que esto esté leading y el título centered.
                    VStack(alignment: .leading){
                        //Esto está en este mismo código, abajo.
                        AlbumInfoPanelSection(albumInfo: $album_info, lenguaje: $lenguaje)
                        Divider()
                        //Esto está en este mismo código, abajo.
                        //AlbumCollaboratorsSection()
                        Spacer()
                    }
                    if isColaborator {
                        VStack(alignment: .center) {
                            Button(action: {
                              //El botón de editar solo aparece solo está activado o visible si el usuario participa en ese álbum.
                                editC = true
                                dismiss()
                            }) {
                                Text(lenguaje == "es" ? "Editar álbum": "Edit album")
                                    .foregroundColor(.black)
                                    .frame(width: 250)
                                    .padding()
                                    .background(Color.customYellow)
                                    .cornerRadius(32)
                            }
                            
                            //Texto de aviso para usuarios que no son administradores. Recordar que si no es admin, no puede editar mas que eliminar sus propias fotos.
                            Text(lenguaje == "es" ? "Si no eres administrador, solo puedes eliminar el contenido que subiste" : "If you are not admin, you can only delete the content you uploaded.")
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                avm.getAlbumViewInfo(id_album: id_album, id_user: id_user, albumInfo: { albm in
                    album_info = albm
                }, isColaborator: { c in
                    isColaborator = c
                })
        }
        }
    }
}

struct AlbumInfoPanelScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlbumInfoPanelScreen(id_album: .constant(""), id_user: .constant(""), lenguaje: .constant("es"), isColaborator: .constant(false), editC: .constant(false))
    }
}

// Sección de Información de Álbum
struct AlbumInfoPanelSection: View {
    @Binding var albumInfo:AlbumInfo
    @Binding var lenguaje:String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(lenguaje == "es" ? "Nombre del álbum:" : "Album Name:")
                //Aquí va nombre original del album
                Text(albumInfo.albumTitle)
                    .bold()
            }
            HStack {
                Text(lenguaje == "es" ? "Administrador del álbum:" : "Album Administrator:")
                //Aquí va nombre original del username
                Text(albumInfo.albumAdministrator)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Fecha de creación:" : "Album Creation:")
                //Aquí va fecha original de creación
                Text(albumInfo.albumCreation)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Última actualización:" : "Album Last Update:")
                //Aquí va la cantidad original de elementos
                Text(albumInfo.albumUpdate)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Tipo de álbum:" : "Album Type:")
                //Aquí va el tipo de privacidad real
                Text(albumInfo.albumType)
                    .bold()
            }
            HStack{
                Text(lenguaje == "es" ? "Privacidad de álbum:" : "Album Privacy:")
                //Aquí va el tipo de privacidad real
                switch albumInfo.albumPrivacy {
                case 0:
                    Text(lenguaje == "es" ? "Privado" : "Privacy")
                        .bold()
                case 1:
                    Text(lenguaje == "es" ? "Amigos" : "Friends")
                        .bold()
                case 2:
                    Text(lenguaje == "es" ? "Público" : "Public")
                        .bold()
                default:
                    Text("")
                        .bold()
                }
            }
            HStack{
                Text(lenguaje == "es" ? "Número de colaboradores:" : "Number of Collaborators:")
                //Aquí va el número real de colaboradores
                Text(albumInfo.albumParticipants)
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
