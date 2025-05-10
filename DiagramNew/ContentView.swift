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
            let origin = CGPoint(x: center.x - 25, y: center.y - 25)
            let size = CGSize(width: 50, height: 50)
            let roundedRectBounds = CGRect(origin: origin, size: size)
            
//            roundedRectBounds.size = CGSize(width: 0.5 * rect.width, height: 0.5 * rect.height)
            let cornerSize = CGSize(width: 10, height: 10)
            let roundedRect = RoundedRectangle(cornerSize: cornerSize).path(in: roundedRectBounds)
            context.stroke(roundedRect,
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
            let rect = CGRect(origin: .zero, size: size)
            print("size: \(size)")

            // Border
            let canvasBorder = Rectangle().path(in: rect)
            context.stroke(canvasBorder,
                    with: .color(.green),
                    lineWidth: 4)
            
            // OpenArrowhead
            var openArrowheadBounds = CGRect()
            openArrowheadBounds.size = CGSize(width: 0.5 * rect.width, height: 0.5 * rect.height)
            let openArrowhead = OpenArrowhead().path(in: openArrowheadBounds)
            context.stroke(openArrowhead,
                    with: .color(.red),
                    lineWidth: 4)
            
            // RoundedRect
            var roundedRectBounds = CGRect()
            roundedRectBounds.size = CGSize(width: 0.5 * rect.width, height: 0.5 * rect.height)
            let cornerSize = CGSize(width: 25, height: 25)
            let roundedRect = RoundedRectangle(cornerSize: cornerSize).path(in: roundedRectBounds)
            context.stroke(roundedRect,
                    with: .color(.red),
                    lineWidth: 4)
            
            // Triangle
            let triangle = DiagramTriangle().path(in: rect)
            context.stroke(triangle,
                    with: .color(.blue),
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
