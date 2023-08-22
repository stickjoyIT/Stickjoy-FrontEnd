//
//  TermsAndConditions.swift
//  Stickjoy First Edition
//
//  Created by Paulo García on 15/08/23.
//  Paulo: TermsAndConditions es el archivo desde el cual TermsAndConditionsMenu jala la información. 

import SwiftUI

struct TermsAndConditions: View {
    var body: some View {
        Text("Terms, Conditions and Privacy Policies go here")
            .multilineTextAlignment(.center)
            .font(.title)
    }
}

struct TermsAndConditions_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}
