//
//  MyArcShape.swift
//  DiagramNew
//
//  Created by Phil Kirby on 9/8/25.
//
import SwiftUI

struct MyArcShape: Shape {
    func path(in rect: CGRect) -> Path {
//        originalPath(in: rect)
        receiveSymbol(in: rect)
    }
    
	func originalPath(in rect: CGRect) -> Path {
		var path = Path()
		let center = CGPoint(x: rect.midX, y: rect.midY)        
		let radius = min(rect.width, rect.height) / 2                
		
		path.addArc(center: center,                     
			radius: radius,                     
			startAngle: .degrees(-90),
			endAngle: .degrees(0),                     
			clockwise: false)
		
		return path    
	}
    
    func newPath(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(90),
            clockwise: false)
        
        return path
    }
    
    func receiveSymbol(in rect: CGRect) -> Path {
        print("\(rect)")
        let length = 150.00
        var path = Path()
        let center = CGPoint(x: rect.minX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let lineStart: CGPoint = CGPoint(x: rect.minX + radius, y: rect.midY)
        let lineEnd: CGPoint = CGPoint(x: lineStart.x + length, y: rect.midY)
        
        path.addArc(center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(90),
            clockwise: false)
        path.move(to: lineStart)
        path.addLine(to: lineEnd)
//        path.closeSubpath()
        
        return path
    }
}

struct MyArcView: View {
    var body: some View {
        MyArcShape()
            .stroke(Color.blue, lineWidth: 10)
//            .border(Color.white, width: 1)
    }
}
	
