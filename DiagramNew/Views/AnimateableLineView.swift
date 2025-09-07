//
//  Line.swift
//  DiagramNew
//
//  Created by Phil Kirby on 9/6/25.
//
import SwiftUI

struct Line: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct AnimatableLine: Shape {
    var start: CGPoint
    var end: CGPoint

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(
                AnimatablePair(start.x, start.y),
                AnimatablePair(end.x, end.y)
            )
        }
        set {
            start = CGPoint(x: newValue.first.first, y: newValue.first.second)
            end = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct AnimateableLineView : View {
    @State var startPoint: CGPoint = CGPoint(x: 50, y: 100)
    @State var endPoint: CGPoint = CGPoint(x: 250, y: 100)

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.green)
                    .frame(width: 50, height: 50)
                    .position(startPoint)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                startPoint = value.location
                            }
                    )
                
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .position(CGPoint(x:startPoint.x - 25, y: startPoint.y))
                
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
                    .position(endPoint)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                endPoint = value.location
                            }
                    )
                
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .position(CGPoint(x:endPoint.x + 25, y: endPoint.y))
                
                
                
                AnimatableLine(start: startPoint, end: endPoint)
                    .stroke(.white, lineWidth: 3)
                    .animation(.easeInOut(duration: 0.3), value: startPoint)
                    .animation(.easeInOut(duration: 0.3), value: endPoint)
            }
            
            HStack {
                Text("Start Point: \(startPoint.x), \(startPoint.y)")
                Text("End Point: \(endPoint.x), \(endPoint.y)")
            }
        }
    }
}

#Preview {
    AnimateableLineView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
