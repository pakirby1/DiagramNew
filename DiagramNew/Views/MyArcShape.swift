//
//  MyArcShape.swift
//  DiagramNew
//
//  Created by Phil Kirby on 9/8/25.
//
import SwiftUI
import os

struct MyArcShape: Shape {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: AnimatableLine.self)
    )

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
        var path = Path()
        let center = CGPoint(x: rect.minX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let lineStart: CGPoint = CGPoint(x: rect.minX + radius, y: rect.midY)
        let lineEnd: CGPoint = CGPoint(x: rect.maxX, y: rect.midY)
        
        path.addArc(center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(90),
            clockwise: false)
        path.move(to: lineStart)
        path.addLine(to: lineEnd)
        
        Self.logger.trace("receiveSymbol() rect: \(rect.debugDescription)")
        
        return path
    }
}

struct MyArcView: View {
    let width: CGFloat
    let height: CGFloat
    let padding: CGFloat = 20.0
    
    var body: some View {
        ZStack {
            MyArcShape()
                .stroke(Color.blue, lineWidth: 10)
//                .border(Color.white, width: 1)
            
            Text("-90")
                .foregroundColor(.white) // Example: Set text color to white
                .font(.title) // Example: Set font style
                .offset(x: -(width / 2) - padding, y: -(height / 2) - padding)
            
            Text("90")
                .foregroundColor(.white) // Example: Set text color to white
                .font(.title) // Example: Set font style
                .offset(x: -(width / 2) - padding, y: (height / 2) + padding)
        }
            .frame(width: width, height: height)
//            .border(Color.white, width: 1)
    }
}

enum Labels {
    case topLeft
    case bottomLeft
    case topRight
    case bottomRight
    
    func postion() -> CGPoint {
        return CGPoint.zero
    }
}
	
