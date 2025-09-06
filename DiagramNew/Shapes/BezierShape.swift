//
//  BezierShape.swift
//  DiagramNew
//
//  Created by Phil Kirby on 5/10/25.
//
import SwiftUI

struct BezierShape: Shape {

    var startPoint: CGPoint
    var curves: [Curve]

    init(startPoint: CGPoint, curves: [Curve]) {
        self.startPoint = startPoint
        self.curves = curves
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        // Move the the start point
        let startPoint = CGPoint(x: startPoint.x*width, y: startPoint.y*height)
        path.move(to: startPoint)

        // Draw the curves
        for c in curves {
            path.addCurve(to: CGPoint(x: c.destination.x*width, y: c.destination.y*height),
                          control1: CGPoint(x: c.control1.x*width, y: c.control1.y*height),
                          control2: CGPoint(x: c.control2.x*width, y: c.control2.y*height))
        }

        return path
    }
}

struct Curve {
    var destination: CGPoint
    var control1: CGPoint
    var control2: CGPoint
}
