//
//  PoliTextField.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct PoliTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var textColor: Color = .blackText
    var placeholderColor: Color = .textfield
    var backgroundColor: Color = .white
    var borderColor: Color = .textfield
    var cornerRadius: CGFloat = 8
    var padding: CGFloat = 24
    var frameHeight: CGFloat = 44

    var body: some View {
        ZStack(alignment: .leading) {
            // 조건부 플레이스홀더
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.horizontal, padding)
                    .font(.text5_medium_16)
            }

            if isSecure {
                SecureField("", text: $text)
                    .padding(padding)
                    .foregroundColor(textColor)
                    .font(.text5_medium_16)
            } else {
                TextField("", text: $text)
                    .padding(padding)
                    .foregroundColor(textColor)
                    .font(.text5_medium_16)
            }
        }
        .frame(height: frameHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .tint(.black)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}
