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
        new_body
    }

    var new_body: some View {
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
            
            // RoundedRect (Left)
            // (25.0, 186.0, 50.0, 50.0)
            let left_origin = CGPoint(x: 25, y: center.y - (rectangleSize / 2))
            let size = CGSize(width: rectangleSize, height: rectangleSize)
            let left_roundedRectBounds = CGRect(origin: left_origin, size: size)
            print("left_roundedRectBounds: \(left_roundedRectBounds)")
            let left_roundedRect = RoundedRectangle(cornerSize: cornerSize).path(in: left_roundedRectBounds)
            context.stroke(left_roundedRect,
                    with: .color(.blue),
                    lineWidth: 4)

            // RoundedRect (Middle)
            // center_roundedRectBounds: (425.0, 186.0, 50.0, 50.0)
            let origin = CGPoint(x: center.x - (rectangleSize / 2), y: center.y - (rectangleSize / 2))
            let center_roundedRectBounds = CGRect(origin: origin, size: size)
            print("center_roundedRectBounds: \(center_roundedRectBounds)")
            let center_roundedRect = RoundedRectangle(cornerSize: cornerSize).path(in: center_roundedRectBounds)
            context.stroke(center_roundedRect,
                    with: .color(.red),
                    lineWidth: 4)
        }
    }
    
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
            
            // RoundedRect
            // (300.0, 61.0, 300.0, 300.0)
            let dim:CGFloat = 50
            let origin = CGPoint(x: center.x - (dim / 2), y: center.y - (dim / 2))
            let size = CGSize(width: dim, height: dim)
            let roundedRectBounds = CGRect(origin: origin, size: size)
            print("roundedRectBounds: \(roundedRectBounds)")
            
            let cornerSize = CGSize(width: 10, height: 10)
            let roundedRect = RoundedRectangle(cornerSize: cornerSize).path(in: roundedRectBounds)
            context.stroke(roundedRect,
                    with: .color(.red),
                    lineWidth: 4)
        }
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
