//
//  ContentView.swift
//  DiagramNew
//
//  Created by Phil Kirby on 5/9/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
//        new_body
//        bezier_body
        ZStack {
            MyArcView()
        }.frame(width: 200, height: 100)
        
//        AnimateableLineView()
    }

    var new_body: some View {
        OpenArrowhead()
            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
    }
    
    var bezier_body: some View {
        BezierDiagramView()
    }
    /// Renders Shapes within a `Canvas` object
    var old_body: some View {
        Canvas(
            opaque: true,
            colorMode: .linear,
            rendersAsynchronously: false
        ) { context, size in
            // canvas
            // size: (900.0, 422.0)
            let rect = CGRect(origin: .zero, size: size)
            print("size: \(size)")

            // Canvas mid point (450, 211)
            let center: CGPoint = .init(x: size.width / 2, y: size.height / 2)
            
            // Border
            let canvasBorder = Rectangle().path(in: rect)
            context.stroke(canvasBorder,
                    with: .color(.green),
                    lineWidth: 4)
            
            // Rectangle Properties
            let rectangleSize:CGFloat = 50
            let cornerSize = CGSize(width: 10, height: 10)
            let size = CGSize(width: rectangleSize, height: rectangleSize)
            
            // RoundedRect (Left)
            // (25.0, 186.0, 50.0, 50.0)
            let left_origin = CGPoint(x: 25, y: center.y - (rectangleSize / 2))
            drawRoundedRect(context: context, origin: left_origin, size: size, cornerSize: cornerSize, id: "Left", color: .color(.red))

            // RoundedRect (Middle)
            // center_roundedRectBounds: (425.0, 186.0, 50.0, 50.0)
            let center_origin = CGPoint(x: center.x - (rectangleSize / 2), y: center.y - (rectangleSize / 2))
            drawRoundedRect(context: context, origin: center_origin, size: size, cornerSize: cornerSize, id: "Center", color: .color(.green))
            
            let right_origin = CGPoint(x: rect.width - 25 - rectangleSize, y: center.y - (rectangleSize / 2))
            drawRoundedRect(context: context, origin: right_origin, size: size, cornerSize: cornerSize, id: "Right", color: .color(.blue))
        }
    }
    
    /// Draws a rounded rectanle within the ``GraphicsContext``
    /// at the `origin` with a `size`
    ///
    /// - Parameters:
    ///     - context: The ``GraphicsContext``
    ///
    func drawRoundedRect(context: GraphicsContext,
                         origin: CGPoint,
                         size: CGSize,
                         cornerSize: CGSize,
                         id: String,
                         color: GraphicsContext.Shading)
    {
        // RoundedRect (Left)
        // (25.0, 186.0, 50.0, 50.0)
        let roundedRectBounds = CGRect(origin: origin, size: size)
        print("\(id) roundedRectBounds: \(roundedRectBounds)")
        let roundedRect = RoundedRectangle(cornerSize: cornerSize).path(in: roundedRectBounds)
        context.stroke(roundedRect,
                with: color,
                lineWidth: 4)
    }
    
    var originalBody: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
