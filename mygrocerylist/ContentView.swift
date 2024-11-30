//
//  ContentView.swift
//  mygrocerylist
//
//  Created by Jean on 30/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query  private var items: [Item]
    
    func addEssentialFoods() {
        modelContext.insert(Item(title: "Bakery & Bread", isCompleted: false))
        modelContext.insert(Item(title: "Meat & Seafood", isCompleted: true))
        modelContext.insert(Item(title: "Cereals & Grains", isCompleted: .random()))
        modelContext.insert(Item(title: "Pasta & Rice", isCompleted: .random()))
        modelContext.insert(Item(title: "Cheese & Eggs", isCompleted: .random()))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical,2)
                        .foregroundStyle(item.isCompleted ? Color.accentColor : Color.primary)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true)  {
                            Button("Done", systemImage:  item.isCompleted ? "x.circle" : "checkmark.circle")
                            {
                                item.isCompleted.toggle()
                            }
                            .tint(item.isCompleted ?  .accentColor: .green)
                        }
                }
            }
            .navigationBarTitle("My Grocery List")
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing)
                    {Button {
                        addEssentialFoods()
                    } label: {
                        Label("Add Essential Foods", systemImage: "carrot")
                    }
                    }
                }
            }
            .overlay {
                
                if items.isEmpty {
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle",description: Text("No items in your cart"))
                }
            }
        }
    }
}
#Preview("Sample Data") {
    let sampleData: [Item]  = [
        Item(title: "Bakery & Bread", isCompleted: false),
        Item(title: "Meat & Seafood", isCompleted: true),
        Item(title: "Cereals & Grains", isCompleted: .random()),
        Item(title: "Pasta & Rice", isCompleted: .random()),
        Item(title: "Cheese & Eggs", isCompleted: .random())
    ]
    
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    for item in sampleData {
        container.mainContext
            .insert(item)
    }
    
    return ContentView()
        .modelContainer(container
        )
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
