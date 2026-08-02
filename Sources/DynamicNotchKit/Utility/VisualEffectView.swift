//
//  VisualEffectView.swift
//  DynamicNotchKit
//
//  Created by Kai Azim on 2024-04-06.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context _: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        visualEffectView.isEmphasized = true
        return visualEffectView
    }

    func updateNSView(_: NSVisualEffectView, context _: Context) {}
}

extension View {
    @ViewBuilder
    func applyTransparency(topCornerRadius: CGFloat, bottomCornerRadius: CGFloat) -> some View {
        if #available(macOS 26, *) {
            self
                .glassEffect(in: NotchShape(
                    topCornerRadius: topCornerRadius,
                    bottomCornerRadius: bottomCornerRadius
                ))
                
        } else {
            self
                .background {
                    VisualEffectView(material: .popover, blendingMode: .behindWindow)
                        .overlay {
                            NotchShape(
                                topCornerRadius: topCornerRadius,
                                bottomCornerRadius: bottomCornerRadius
                            )
                                .stroke(.quaternary, lineWidth: 1)
                        }
                }
        }
    }
}
