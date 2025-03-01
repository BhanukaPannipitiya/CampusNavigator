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
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
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
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mint, lineWidth: 0.8)
            )
            //.buttonStyle(PlainButtonStyle())
            .foregroundColor(.primary)
        }
    }
}


struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LabelTextField(
                title: "Dr. John Johnes",
                description: "Schedule a meeting.",
                destination: AnyView(Text("Meeting Lecturers"))
            )
            .previewLayout(.sizeThatFits)
            .padding()
            
        }
    }
}
