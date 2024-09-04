//
//  DragGesture.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 18/8/24.
//

import SwiftUI

struct HandleDragGesture {
    var free: Bool
    @Binding var currentRotation: CGFloat
    
    @Binding var lastDragValue: CGFloat
    @Binding var velocity: CGFloat
    
    func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = value.translation.width - lastDragValue
                velocity = delta / 10
                lastDragValue = value.translation.width
                if free {
                    currentRotation += velocity
                }
            }
            .onEnded { _ in
                lastDragValue = 0.0
                if free {
                    startInertial()
                }
            }
    }
    func startInertial() {
        let inertialTimer =  Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            if abs(velocity) < 0.01 {
                timer.invalidate()
            } else {
                velocity *= 0.95
                currentRotation += velocity
            }
        }
        RunLoop.current.add(inertialTimer, forMode: .common)
    }
}
