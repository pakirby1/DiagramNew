//
//  OpenArrowhead.swift
//  DiagramNew
//
//  Created by Phil Kirby on 5/9/25.
//
import SwiftUI

struct OpenArrowhead: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.11058*width, y: 0.44*height))
        path.addLine(to: CGPoint(x: 0.5*width, y: 0.44*height))
        path.move(to: CGPoint(x: 0.62*width, y: 0.44*height))
        path.addLine(to: CGPoint(x: 0.5*width, y: 0.38*height))
        path.addLine(to: CGPoint(x: 0.5*width, y: 0.5*height))
        path.addLine(to: CGPoint(x: 0.62*width, y: 0.44*height))
        path.closeSubpath()
        return path
    }
}
