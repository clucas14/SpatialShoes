//
//  BackButton.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 12/9/24.
//

import SwiftUI

fileprivate struct ToolBar: ViewModifier {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.dismiss) private var dismiss
    
    @State var shoe: ShoeModel?
    @State var backButton: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                if let shoe {
                    if backButton {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack {
                                Button {
                                    shoesVM.selectedShoe = nil
                                    shoesVM.visibility = .all
                                } label: {
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.backward")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .padding(14)
                                        
                                        Text("Atrás")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                            .padding(.trailing, 24)
                                    }
                                }
                                .buttonStyle(BackButtonStyle())
                                .hoverEffectGroup()
                                Text(shoe.name)
                                    .font(.title)
                                    .padding(.leading)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text(shoe.name)
                                .font(.title)
                                .offset(x: 72)
                        }
                    }
                    ToolbarItem(placement: .bottomOrnament) {
                        ToolBarOrnament(shoe: shoe)
                    }
                }
            }
            .onChange(of: shoesVM.selectedShoe) {
                shoe = shoesVM.selectedShoe
            }
    }
}

extension View {
    func toolBar(shoe: ShoeModel, backButton: Bool) -> some View {
        modifier(ToolBar(shoe: shoe, backButton: backButton))
    }
}
