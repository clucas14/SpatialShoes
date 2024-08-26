//
//  PruebasForm.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 21/8/24.
//

import SwiftUI

struct CustomFormView: View {
    let tittle: String
    let arrayStrings: [(String,String)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(tittle)
                .padding(.bottom, -5)
                .padding(.leading, 15)
            HStack {
                VStack(alignment: .leading) {
                    ForEach(Array(arrayStrings.enumerated()), id: \.0.hashValue) { index, tupla in
                        HStack {
                            Text(tupla.0)
                            Spacer()
                            Text(tupla.1)
                        }
                        .foregroundStyle(.opacity(0.9))
                        .padding(.horizontal,15)
                        if index != arrayStrings.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.vertical, 15)
            }
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
    }
}

#Preview(windowStyle: .automatic) {
    CustomFormView(tittle: "Datos" ,arrayStrings: [("Colors: ", ShoeModel.test.listColors), ("Sizes: ", ShoeModel.test.listSize)])
}
