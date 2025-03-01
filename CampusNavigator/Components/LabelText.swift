//
//  LabelText.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-25.
//
import SwiftUI

struct LabelText: View {
    let title: String
    
    var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .bold()
                }
                Spacer()
            }
            .padding()
            .frame(width: 200)
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


struct LabelText_Previews: PreviewProvider {
    static var previews: some View {
            LabelText(
                title: "Available Time"
            )
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
