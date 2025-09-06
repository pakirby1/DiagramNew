//
//  BezierDiagramView.swift
//  DiagramNew
//
//  Created by Phil Kirby on 9/6/25.
//


import SwiftUI

struct BezierDiagramView: View {
    var body: some View {
        Canvas { context, size in
            // Anchors
            let anchorA = CGPoint(x: 80, y: 160)
            let anchorB = CGPoint(x: 440, y: 160)

            // Control points
            let controlA = CGPoint(x: 170, y: 40)   // A.control2 (outgoing)
            let controlB = CGPoint(x: 350, y: 40)   // B.control1 (incoming)

            // --- Curve ---
            var path = Path()
            path.move(to: anchorA)
            path.addCurve(to: anchorB, control1: controlA, control2: controlB)
            context.stroke(path, with: .color(.blue), lineWidth: 2)

            // --- Arms (dashed lines) ---
            var arm1 = Path()
            arm1.move(to: anchorA)
            arm1.addLine(to: controlA)
            context.stroke(
                arm1,
                with: .color(.gray.opacity(0.6)),
                style: StrokeStyle(lineWidth: 1, dash: [5, 4])
            )

            var arm2 = Path()
            arm2.move(to: anchorB)
            arm2.addLine(to: controlB)
            context.stroke(
                arm2,
                with: .color(.gray.opacity(0.6)),
                style: StrokeStyle(lineWidth: 1, dash: [5, 4])
            )

            // --- Draw points ---
            let anchorStyle = GraphicsContext.Shading.color(.black)
            let controlStyle = GraphicsContext.Shading.color(.orange)

            context.fill(Path(ellipseIn: CGRect(x: anchorA.x-5, y: anchorA.y-5, width: 10, height: 10)), with: anchorStyle)
            context.fill(Path(ellipseIn: CGRect(x: anchorB.x-5, y: anchorB.y-5, width: 10, height: 10)), with: anchorStyle)

            context.fill(Path(ellipseIn: CGRect(x: controlA.x-4, y: controlA.y-4, width: 8, height: 8)), with: controlStyle)
            context.fill(Path(ellipseIn: CGRect(x: controlB.x-4, y: controlB.y-4, width: 8, height: 8)), with: controlStyle)
        }
        .frame(width: 520, height: 220)
        .background(Color.white)
    }
}

#Preview {
    BezierDiagramView()
}
