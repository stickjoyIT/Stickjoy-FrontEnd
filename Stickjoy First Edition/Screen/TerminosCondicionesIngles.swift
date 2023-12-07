//
//  TerminosCondicionesIngles.swift
//  Stickjoy First Edition
//
//  Created by admin on 10/10/23.
//

import SwiftUI

struct TerminosCondicionesIngles: View {
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
                    /*PolicyEnPart1()
                    PolicyEnPart2()
                    PolicyEnPart3()
                    PolicyEnPart4()
                    PolicyEnPart5()
                    TerminosEnPart1()
                    TerminosEnPart2()
                    TerminosEnPart3()
                    TerminosEnPart4()*/
                    storyboardPoliticasTerminosIngles().edgesIgnoringSafeArea(.all)
                }//.padding(.horizontal)
            //}.padding()
        }
    }
}

struct PolicyEnPart1: View {
    var body: some View {
        Text("Privacy Policies")
            .font(.title)
            .fontWeight(.bold)
                        
        Text("Privacy and security of our users are of utmost importance to us. Therefore, we have developed this Privacy Policy to explain how we collect, use, disclose, and protect personal information on our social network with personal content. By using our services, you agree to the terms of this policy and consent to our practices of collecting and using information.")
                        
        Text("Collection of Personal Information:")
            .font(.title2)
            .fontWeight(.bold)
        
        Text("G. Registration Information: When you sign up for STICKJOY, we collect your name, email address, and password.")
        Text("H. Profile Information: You may provide additional information in your profile, such as your photos, location, date of birth, and other optional details.")
        Text("I. Personal Content: The platform allows you to share personal content, such as posts, photos, videos, and comments. The information you choose to share will be stored on our servers.")
        Text("J. Contact Information: If you choose to provide your contact information, such as your phone number, email address, or other contact details, we may collect and store that information.")
        Text("K. Usage Information: We collect information about how you use our social network, including your interactions, searches, browsing history, time spent on certain activities, and other data related to your behavior on the platform.")
        Text("L. Third-Party Information: We may receive information from third parties, such as service providers and business partners, who help us enhance and personalize your experience on our social network.")
    }
}

struct PolicyEnPart2: View {
    var body: some View {
        Text("Use of Collected Information:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("H. Enhancing User Experience: We use the collected information to personalize your experience on STICKJOY, provide relevant content, and improve our services.")
        Text("I. Communication: We may use your contact information to send you updates, notifications, and communications related to your account, services, and new or modified features.")
        Text("J. Advertising: We may use the collected information to display personalized ads based on your interests and preferences.")
        Text("K. Social Features: When you share personal content on our social network, you understand and agree that other users may access, view, comment on, or share that content within the platform and on third-party platforms, according to the privacy settings you have selected.")
        Text("L. Analysis and Statistics: We use anonymous and aggregated data for analysis and to generate statistics that help us understand and improve our social network.")
        Text("M. Security and Fraud Prevention: We employ security measures to protect your personal information and prevent unauthorized access. We may also use personal information to detect and prevent fraudulent or abusive activities on our platform.")
        Text("N. Legal Compliance: We may use your information to comply with applicable laws and regulations, as well as to respond to legal requests and protect our legal rights.")
    }
}

struct PolicyEnPart3: View {
    var body: some View {
        Text("Sharing Information with Third Parties:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("E. Service Providers: We may share your information with third parties who assist us in providing and improving our services, such as hosting providers, marketing services, analytics services, and payment processors.")
        
        Text("F. Business Partners: On occasion, we may share information with business partners in order to offer you joint products, services, or promotions that we believe may be of interest to you.")
        
        Text("G. Consent: We will not share your personal information with unaffiliated third parties without your consent, unless we are legally obligated to do so or it is necessary to protect our rights, safety, or property, or those of our users.")
        
        Text("H. Legal Compliance: We may share your information in response to a valid legal request, such as a court order or subpoena.")
    }
}

struct PolicyEnPart4: View {
    var body: some View {
        Text("Information Security:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("We implement reasonable security measures to protect your personal information against unauthorized access, disclosure, or alteration; however, no platform is entirely secure, and we cannot guarantee the absolute security of your personal information.")
        
        Text("Data Retention:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("We will retain your personal information for as long as necessary to fulfill the purposes outlined in this policy, unless the law requires or allows for a longer retention period.")
        
        Text("Privacy of Minors:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Our social network is not directed at minors. We do not intentionally collect personal information from minors. If you are a parent, legal guardian, or responsible party and believe that your child has provided us with personal information, please contact us immediately, and we will take the necessary steps to delete that information from our records.")
    }
}

struct PolicyEnPart5: View {
    var body: some View {
        Text("Changes to the Privacy Policy:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("We reserve the right to modify this Privacy Policy at any time. We will notify you of any significant changes through our platform or other means of communication. We recommend that you periodically review this policy to stay informed about how we protect your personal information.")
        
        Text("Your Rights:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("You have the right to access, correct, update, and delete your personal information. You can do so through your account settings or by contacting our support team.")
        
        Text("For any questions or concerns about our Privacy Policy, please contact us at administracion@stickjoy.app")
    }
}

struct TerminosEnPart1:View {
    var body: some View {
        Text("Terms and Conditions")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Welcome to our personal content social network. Before using our platform, we ask that you carefully read these Terms and Conditions of Use, as they set forth the legal terms and conditions governing your access and use of our social network. By using our platform, you agree to comply with these Terms and Conditions. If you do not agree with any of the terms set forth here, we recommend that you do not use our social network.")
        
        Text("Use of the Platform:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("D. Eligibility: You must be of legal age and have the legal capacity to use our social network. If you are a minor, you must have the consent and supervision of your parents or legal guardians to use our services.")
        
        Text("E. Account Registration: To access certain features and functions of our social network, you may need to register and create an account. The information you provide during the registration process must be accurate, current, and complete. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur in your account.")
        
        Text("F. Acceptable Use: By using our social network, you agree not to violate any applicable laws or infringe upon the rights of third parties. You must not post illegal, defamatory, obscene, offensive, discriminatory, or content that violates the intellectual property rights of third parties. Furthermore, you must not use our platform for spam, phishing, or any other malicious activity.")
    }
}

struct TerminosEnPart2:View {
    var body: some View {
        Text("User-Generated Content:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("D. Ownership of Content: You are solely responsible for the content you share on our social network. You retain ownership of your copyright and other intellectual property rights in the content you post. However, by posting content on our platform, you grant us a non-exclusive, transferable, sublicensable, worldwide license to use, reproduce, modify, adapt, distribute, and display such content in connection with the services we provide.")
        
        Text("E. Content Privacy: We respect your privacy and are committed to safeguarding the confidentiality of your personal content. However, please be aware that any content you post on our social network may be visible to other users and may be shared beyond our platform. We recommend exercising caution when sharing sensitive personal content.")
        
        Text("F. We reserve the right to remove any content that we deem inappropriate, illegal, offensive, or in violation of these Terms and Conditions of Use.")
        
        Text("Privacy:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Your privacy is important to us. Please refer to our Privacy Policy to understand how we collect, use, and protect your personal information on our social network.")
        
        Text("External Links:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Our social network may contain links to third-party websites. We have no control over the content, privacy policy, or practices of these websites, and we are not responsible for them.")
    }
}

struct TerminosEnPart3:View {
    var body: some View {
        Text("Intellectual Property Rights:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Platform Rights: Our social network and all associated intellectual property rights, including copyrights, trademarks, and patents, are exclusively owned by us. You do not have the right to use our brand, logos, trade names, or other corporate identity elements without our express written consent.")
        
        Text("Third-Party Rights: Respect the intellectual property rights of third parties. You must not post content that infringes upon the copyrights, trademarks, or other intellectual property rights of third parties. If we receive a valid notice of infringement, we reserve the right to remove such content and take necessary actions.")
        
        Text("Limitation of Liability:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Disclaimer of Warranties: Our social network is provided 'as is' and 'as available.' We do not offer any express or implied warranties regarding its operation, accuracy, reliability, or fitness for a particular purpose. You use our platform at your own risk.")
        
        Text("Limitation of Liability: To the fullest extent permitted by law, we shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising from the use of our social network or any interaction with other users.")
    }
}

struct TerminosEnPart4:View {
    var body: some View {
        Text("Modifications and Termination:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("We reserve the right to modify, suspend, or discontinue our social network at any time and without prior notice. In the event that our social network closes permanently, we will not be responsible for the recovery of your data and content uploaded to the platform, nor for the refund of subscription fees if applicable. We also reserve the right to terminate your access to our platform if we believe you have violated these Terms and Conditions.")
        
        Text("These Terms and Conditions of Use constitute the entire agreement between you and us regarding your use of our social network. If you have any questions or concerns, please feel free to contact us through the support channels provided on our platform.")
        
        Text("Applicable Law:")
            .font(.title)
            .fontWeight(.bold)
        
        Text("These terms and conditions shall be governed and interpreted in accordance with the laws of the country or jurisdiction where our company is established.")
        
        Text("Contact")
            .font(.title)
            .fontWeight(.bold)
        
        Text("If you have any questions or concerns about these Terms and Conditions of Use, you can contact us through our support channel at administracion@stickjoy.app.")
    }
}

struct TerminosCondicionesIngles_Previews: PreviewProvider {
    static var previews: some View {
        TerminosCondicionesIngles()
    }
}

struct storyboardPoliticasTerminosIngles:UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let story = UIStoryboard(name: "Politicas", bundle: Bundle.main)
        let controller = story.instantiateViewController(identifier: "politicasEN")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
