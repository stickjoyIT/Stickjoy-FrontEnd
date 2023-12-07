import SwiftUI
import UIKit

@available(iOS 16.0, *)
struct SharedScreen: View {
    @Environment(\.displayScale) var displayScale
        
        @State private var sheetPresented : Bool = false
        
        @State private var text : String = "Hello World"
        
        var body: some View {
            
            VStack(alignment: .center, spacing:30) {
       
                view()
           
                form()
                
                Button(action: {
                    
                    withAnimation{
                   
                        self.sheetPresented = true
                       
                    }
                        
                }){
                    Text("Generate & Share")
                }
                
            }
            .sheet(isPresented: $sheetPresented, content: {
                    
                if let data = render() {
           
                    ShareView(activityItems: [data])
               
                }
                
            })
        }
    }

@available(iOS 16.0, *)
extension SharedScreen {
        
        private func view () -> some View {
            
            VStack {
                
                VStack {
                    Image("profilePicture2").frame(width: UIScreen.main.bounds.width, height: 250)
                        .cornerRadius(2)
                        
                    Text(text)
                        .font(.headline)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple, lineWidth: 1)
                )
                
            }
            .padding(2)
            .background(.clear)
        }
        
    }

@available(iOS 16.0, *)
extension SharedScreen {
        
        private func form() ->some View {
            
            Form{
                
                TextField("Text here...", text : $text)
                  
            }
            .frame(width:200, height:100,alignment: .center)
            .cornerRadius(10)
        }
    }

@available(iOS 16.0, *)
extension SharedScreen {
      
        @MainActor
        private func render() -> UIImage?{
            
            let renderer = ImageRenderer(content: view())

            renderer.scale = displayScale
         
            return renderer.uiImage
        }
    }

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) ->
        UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
               applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
               context: UIViewControllerRepresentableContext<ShareView>) {
        // empty
    }
}


