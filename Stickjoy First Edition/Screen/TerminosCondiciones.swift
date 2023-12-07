//
//  TerminosCondiciones.swift
//  Stickjoy First Edition
//
//  Created by admin on 15/09/23.
//

import SwiftUI
import UIKit

struct TerminosCondiciones: View {
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left.circle.fill")
            })
            .font(.title)
            .foregroundColor(.gray)
            .padding(.horizontal, 10)
            .padding(.top, 10)
            //ScrollView {
                VStack(alignment:.leading, spacing: 4) {
                    /*PolicyView()
                    Policy_part()
                    Policy_part2()
                    Policy_part3()
                    Terms()
                    terms_part2()
                    Terms_part3()
                    Terms_part4()*/
                    storyboardPoliticasTerminosEspaniol().edgesIgnoringSafeArea(.all)
                }
            //}.padding()
        }
    }
}

struct PolicyView: View {
    var body: some View {
        Text("Políticas de Privacidad")
            .font(.title)
            .fontWeight(.bold)
                        
        JustifiedText("La privacidad y la seguridad de nuestros usuarios son de suma importancia para nosotros. Por lo tanto, hemos desarrollado esta Política de Privacidad para explicar cómo recopilamos, utilizamos, divulgamos y protegemos la información personal en nuestra red social con contenido personal. Al utilizar nuestros servicios, usted acepta los términos de esta política y está de acuerdo con nuestras prácticas de recopilación y uso de información.").frame(width: 250, height:400)
        
        Text("Recopilación de Información Personal:")
            .font(.title2)
            .fontWeight(.bold)
        
        Text("A. Información de registro: Al registrarse en STICKJOY, recopilamos su nombre, dirección de correo electrónico y contraseña.")
        Text("B. Información de perfil: Puede proporcionar información adicional en su perfil, como sus fotos, ubicación, fecha de nacimiento y otros detalles opcionales.")
        Text("C. Contenido personal: La plataforma permite compartir contenido personal, como publicaciones, fotos, videos y comentarios. La información que elija compartir se almacenará en nuestros servidores.")
        Text("D. Información de contacto: Si elige proporcionar su información de contacto, como su número de teléfono, dirección de correo electrónico u otros detalles de contacto, podemos recopilar y almacenar esa información.")
        Text("E. Información de uso: Recopilamos información sobre cómo utiliza nuestra red social, incluyendo sus interacciones, búsquedas, historial de navegación, tiempo dedicado a ciertas actividades y otros datos relacionados con su comportamiento en la plataforma.")
        Text("F. Información de terceros: Podemos recibir información de terceros, como proveedores de servicios y socios comerciales, que nos ayudan a mejorar y personalizar su experiencia en nuestra red social.")
        
    }
}
    
struct Policy_part:View {
    var body: some View {
        Text("Uso de la información recopilada:")
            .font(.title2)
            .fontWeight(.bold)
        
        Text("A. Mejora de la experiencia del usuario: Utilizamos la información recopilada para personalizar su experiencia en STICKJOY, brindar contenido relevante y mejorar nuestros servicios.")
        Text("B. Comunicación: Podemos utilizar su información de contacto para enviarle actualizaciones, notificaciones y comunicaciones relacionadas con su cuenta, servicios y funciones nuevas o modificadas.")
        Text("C. Publicidad: Podemos utilizar la información recopilada para mostrar anuncios personalizados basados en sus intereses y preferencias.")
        Text("D. Funcionalidades sociales: Al compartir contenido personal en nuestra red social, comprende y acepta que otros usuarios podrán acceder, ver, comentar o compartir dentro de la plataforma y en plataformas de terceros dicho contenido, de acuerdo con la configuración de privacidad que haya seleccionado.")
        Text("E. Análisis y estadísticas: Utilizamos datos anónimos y agregados para realizar análisis y generar estadísticas que nos ayuden a comprender y mejorar nuestra red social.")
        Text("F. Seguridad y Prevención del Fraude: Utilizamos medidas de seguridad para proteger su información personal y prevenir el acceso no autorizado. También podemos utilizar información personal para detectar y prevenir actividades fraudulentas o abusivas en nuestra plataforma.")
        Text("G. Cumplimiento legal: Podemos utilizar su información para cumplir con las leyes y regulaciones aplicables, así como para responder a solicitudes legales y proteger nuestros derechos legales.")
                        
        
    }
}

struct Policy_part2: View {
    var body: some View {
        Text("Compartir información con terceros:")
            .font(.title2)
            .fontWeight(.bold)
        
        Text("A. Proveedores de servicios: Podemos compartir su información con terceros que nos ayuden a proporcionar y mejorar nuestros servicios, como proveedores de alojamiento, de marketing, servicios de análisis y procesadores de pagos.")
        Text("B. Socios comerciales: En ocasiones, podemos compartir información con socios comerciales con el fin de ofrecerle productos, servicios o promociones conjuntas que consideremos de su interés.")
        Text("C. Consentimiento: No compartiremos su información personal con terceros no afiliados sin su consentimiento, a menos que estemos legalmente obligados a hacerlo o sea necesario para proteger nuestros derechos, seguridad o propiedad, o los de nuestros usuarios.")
        Text("D. Cumplimiento legal: Podemos compartir su información en respuesta a una solicitud legal válida, como una orden judicial o una citación.")
                        
        Text("Seguridad de la información:")
            .font(.title2)
            .fontWeight(.bold)
                        
        Text("Implementamos medidas de seguridad razonables para proteger su información personal contra acceso no autorizado, divulgación o alteración; sin embargo, ninguna plataforma es completamente segura, y no podemos garantizar la seguridad absoluta de su información personal.")
                        
        Text("Retención de datos:")
            .font(.title2)
            .fontWeight(.bold)
        
        Text("Mantendremos su información personal durante el tiempo que sea necesario para cumplir con los fines establecidos en esta política, a menos que la ley exija o permita un período de retención más largo.")
    }
}

struct Policy_part3:View {
    var body: some View {
        Text("Privacidad de los menores")
                            .font(.title2)
                            .fontWeight(.bold)
                        
        Text("Nuestra red social no está dirigida a menores de edad. No recopilamos intencionalmente información personal de menores. Si usted es padre, tutor legal o responsable y cree que su hijo nos ha proporcionado información personal, contáctenos de inmediato y tomaremos las medidas necesarias para eliminar esa información de nuestros registros.")
                        
        Text("Cambios en la política de privacidad:")
                            .font(.title2)
                            .fontWeight(.bold)
                        
        Text("Nos reservamos el derecho de modificar esta Política de Privacidad en cualquier momento. Le notificaremos sobre cualquier cambio significativo a través de nuestra plataforma o mediante otros medios de comunicación. Le recomendamos que revise periódicamente esta política para mantenerse informado sobre cómo protegemos su información personal.")
                        
        Text("Sus derechos:")
                            .font(.title2)
                            .fontWeight(.bold)
        Text("Usted tiene el derecho de acceder, corregir, actualizar y eliminar su información personal. Puede hacerlo a través de la configuración de su cuenta o poniéndose en contacto con nuestro equipo de soporte.")
                        
        Text("Para cualquier consulta o inquietud sobre nuestra Política de Privacidad, por favor contáctenos a través de administracion@stickjoy.app o utilizando los canales de contacto proporcionados en nuestro sitio web.")
                        
                        Spacer()
    }
}

struct Terms:View {
    var body: some View {
        Text("Términos y Condiciones")
            .font(.title)
            .fontWeight(.bold)
                        
        Text("Bienvenid@ a nuestra red social con contenido personal. Antes de utilizar nuestra plataforma, te pedimos que leas detenidamente estos Términos y Condiciones de Uso, ya que establecen los Términos Legales y Condiciones que rigen tu acceso y uso de nuestra red social. Al utilizar nuestra plataforma, aceptas cumplir con estos Términos y Condiciones. Si no estás de acuerdo con alguno de los Términos aquí establecidos, te recomendamos que no utilices nuestra red social.")
                        
        Text("Uso de la Plataforma")
            .font(.title2)
            .fontWeight(.bold)
        
        Text("A. Elegibilidad: Debes ser mayor de edad y tener la capacidad legal para utilizar nuestra red social. Si eres menor de edad, debes contar con el consentimiento y supervisión de tus padres o tutores legales para utilizar nuestros servicios.")
        Text("B. Registro de cuenta: Para acceder a ciertas características y funciones de nuestra red social, es posible que debas registrarte y crear una cuenta. La información que proporciones durante el proceso de registro debe ser precisa, actualizada y completa. Eres responsable de mantener la confidencialidad de tus credenciales de inicio de sesión y de todas las actividades que ocurran en tu cuenta.")
        Text("C. Uso aceptable: Al utilizar nuestra red social, aceptas no violar ninguna ley aplicable ni infringir los derechos de terceros. No debes publicar contenido ilegal, difamatorio, obsceno, ofensivo, discriminatorio o que viole los derechos de propiedad intelectual de terceros. Asimismo, no debes utilizar nuestra plataforma para actividades de spam, phishing o cualquier otro tipo de actividad maliciosa.")
                        
    }
}

struct terms_part2: View{
    var body: some View {
        Text("Contenido Generado por el Usuario:")
                            .font(.title2)
                            .fontWeight(.bold)
        
        Text("A. Propiedad del contenido: Eres el único responsable del contenido que compartes en nuestra red social. Mantienes la propiedad de tus derechos de autor y otros derechos de propiedad intelectual sobre el contenido que publiques. Sin embargo, al publicar contenido en nuestra plataforma, nos otorgas una licencia no exclusiva, transferible, sublicenciable y mundial para utilizar, reproducir, modificar, adaptar, distribuir y mostrar dicho contenido en relación con los servicios que ofrecemos.")
        Text("B. Privacidad del Contenido: Respetamos tu privacidad y nos comprometemos a proteger la confidencialidad de tu contenido personal. Sin embargo, debes tener en cuenta que cualquier contenido que publiques en nuestra red social puede ser visible para otros usuarios y puede ser compartido más allá de nuestra plataforma. Te recomendamos que tengas precaución al compartir contenido personal sensible.")
        Text("C. Nos reservamos el derecho de eliminar cualquier contenido que consideremos inapropiado, ilegal, ofensivo o que viole estos Términos y Condiciones de Uso")
                        
        Text("Privacidad:")
                            .font(.title2)
                            .fontWeight(.bold)
                        
        Text("Su privacidad es importante para nosotros. Consulte nuestra Política de Privacidad para comprender cómo recopilamos, utilizamos y protegemos su información personal en nuestra red social.")
                        
        Text("Enlaces Externos:")
                            .font(.title2)
                            .fontWeight(.bold)
                        
        Text("Nuestra red social puede contener enlaces a sitios web de terceros. No tenemos control sobre el contenido, la política de privacidad o las prácticas de dichos sitios web, y no nos hacemos responsables de ellos.")
        
        
    }
}

struct Terms_part3:View {
    var body: some View {
        Text("Derechos de Propiedad Intelectual:")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Derechos de la plataforma: Nuestra red social y todos los derechos de propiedad intelectual asociados, incluidos los derechos de autor, marcas comerciales y patentes, son propiedad exclusiva nuestra. No tienes derecho a utilizar nuestra marca, logotipos, nombres comerciales u otros elementos de identidad corporativa sin nuestro consentimiento expreso por escrito.")
                        Text("Derechos de terceros: Respetar los derechos de propiedad intelectual de terceros. No debes publicar contenido que infrinja los derechos de autor, marcas comerciales u otros derechos de propiedad intelectual de terceros. Si recibimos una notificación válida de infracción, nos reservamos el derecho de eliminar dicho contenido y tomar las medidas necesarias.")
                        
                        Text("Limitación de Responsabilidad:")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Exclusión de Garantías: Nuestra red social se proporciona \"tal cual\" y \"según disponibilidad\". No ofrecemos ninguna garantía expresa o implícita con respecto a su funcionamiento, precisión, confiabilidad o idoneidad para un propósito particular. Utilizas nuestra plataforma bajo tu propio riesgo.")
                        Text("Limitación de Responsabilidad: En la medida máxima permitida por la ley, no seremos responsables por ningún daño directo, indirecto, incidental, consecuencial o punitivo derivado del uso de nuestra red social o de cualquier interacción con otros usuarios.")
                        
                        Text("Modificaciones y Terminación:")
                            .font(.title2)
                            .fontWeight(.bold)
        
        
    }
}

struct Terms_part4: View {
    var body: some View {
        Text("Nos reservamos el derecho de modificar, suspender o interrumpir nuestra red social en cualquier momento y sin previo aviso. En caso de que nuestra red social cierre de forma definitiva, no nos haremos responsables de la recuperación de tus datos y contenido subido en la plataforma ni del reembolso del dinero en caso de pago de suscripción.  También nos reservamos el derecho de terminar tu acceso a nuestra plataforma si consideramos que has violado estos Términos y Condiciones.")
                        
                        Text("Estos Términos y Condiciones de Uso constituyen el acuerdo completo entre tú y nosotros con respecto a tu uso de nuestra red social. Si tienes alguna pregunta o inquietud, no dudes en comunicarte con nosotros a través de los canales de soporte proporcionados en nuestra plataforma.")
                        
                        Text("Legislación Aplicable")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Estos términos y condiciones se regirán e interpretarán de acuerdo con las leyes del país o jurisdicción donde se encuentra establecida nuestra empresa.")
                        
                        Text("Contacto")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Si tiene alguna pregunta o inquietud acerca de estos Términos y Condiciones de Uso, puede ponerse en contacto con nosotros a través de nuestro canal de soporte: administracion@stickjoy.app")
                        
                        Spacer()
    }
}

struct TerminosCondiciones_Previews: PreviewProvider {
    static var previews: some View {
        TerminosCondiciones()
    }
}

struct JustifiedText: View {
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .frame(width: geometry.size.width, alignment: .leading)
        }
    }
}

struct storyboardPoliticasTerminosEspaniol:UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let story = UIStoryboard(name: "Politicas", bundle: Bundle.main)
        let controller = story.instantiateViewController(identifier: "politicas")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
