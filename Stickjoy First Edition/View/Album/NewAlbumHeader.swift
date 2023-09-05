//
//  NewAlbumHeader.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 16/08/23.
//

import SwiftUI



struct NewAlbumHeader: View {
    //Adopción de Modo claro oscuro
    @Environment (\.colorScheme) var scheme
    @ObservedObject var editorVal = SetEditor()
    @State var nombreAlbum = "Nombre del album"
    @ObservedObject var avm = AlbumViewModel()
    
    @Binding var editorB:Bool
    @Binding var nameAlbum:String
    @Binding var imgPortda:String
    @Binding var descripAlbum:String
    @Binding var imges:[String]
    @Binding var id_album:String
    
    let nameUser = UserDefaults.standard.string(forKey: "nombre") ?? "Name User"
    
    @State var editNameAlbum = true
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            (scheme == .dark ? Color.black : Color.white)
            
            VStack(alignment: .leading, spacing: 8) {
                
                AsyncImage(url: URL(string: imgPortda)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                    .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image("ProfilePic")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill).background(Color(hex: "9dc3e6"))
                }
            //Esto es para que al dar scroll se vaya la imagen y se quede el encabezado
                .frame(width: UIScreen.main.bounds.width, height: 250)
                .cornerRadius(2)
            //Esto es para que la imagen no se salga del header cuando se de scroll hacia arriba y tope. para eso es el "-" en offset
                
                //Título de álbum
                
                HStack {
                    //Busca el título default del álbum
                    if editorB {
                        TextField("Nombre del Album",text: $nameAlbum)
                            .font(.system(size: 24))
                            .fontWeight(.light)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                    } else {
                        Text(nameAlbum)
                            .font(.system(size: 24))
                            .fontWeight(.light)
                    }
                    
                }.padding(.leading,10)
                .padding(.trailing, 10)
                
                //Muestra administrador del álbum
                Text("@"+(nameUser.replacingOccurrences(of: " ", with: "")))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                if editorB {
                    TextField("Descripcion del Album",text: $descripAlbum)
                        .autocorrectionDisabled(true)
                        .font(.system(size: 12))
                        .textInputAutocapitalization(.none)
                        .padding(.leading,10)
                        .padding(.trailing, 10)
                } else {
                    Text(descripAlbum)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .fontWeight(.light)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
            }
            .padding(0)
            .edgesIgnoringSafeArea(.top)
            //Layout de botones de regresar y editar
            
            if !editorB {
                HStack {
                    //Botón de regresar
                    Button(action: {
                        
                        // Add your action here
                        self.presentationMode.wrappedValue.dismiss()
                        
                        nameAlbum = ""
                        
                    }) {
                        Image(systemName: "arrow.backward.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .background(
                                            LinearGradient(
                                                colors: [.customBlue, .blue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                                
                                            )
                                        )
                            .cornerRadius(20)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                    
                    Spacer()
                    
                    //Botón para entrar a editor de album
                    Button(action: {
                        // Add your action here
                        editorB = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title).foregroundColor(.white)
                            .background(
                                            LinearGradient(
                                                colors: [.customBlue, .blue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                            .cornerRadius(20)
                    }
                    //Añadí este frame para que el nombre de album quepa
                    .frame(width: 20, height: 20)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 20)
            }
            
        }
        .edgesIgnoringSafeArea(.horizontal) // Extend the header to the screen edges
        .onAppear{
            
        }
    }
}

struct NewAlbumHeader_Previews: PreviewProvider {
    static var previews: some View {
        NewAlbumHeader(editorB:.constant(false), nameAlbum: .constant(""), imgPortda: .constant(""), descripAlbum: .constant(""), imges: .constant([]), id_album: .constant(""))
    }
}
