//
//  LabelTextField.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-18.
//

import SwiftUI

struct LabelTextField: View {
    let title: String
    let description: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .bold()
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

//Preview with sample data
struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(
            title: "Dr.John Johnes",
            description: "Schedule a meeting."
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
