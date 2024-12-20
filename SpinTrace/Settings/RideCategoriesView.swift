//
//  CategoriesView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 11.12.24.
//

import SwiftData
import SwiftUI

struct RideCategoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RideCategory.orderIndex, order: .forward) private
        var categories: [RideCategory]
    
    @Query var rides: [Ride]

    @State private var newCategoryName: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationStack {
            List {
                // Abschnitt: Vorhandene Kategorien anzeigen und sortieren
                ForEach(categories) { category in
                    Text(category.name)
                }
                .onMove(perform: moveCategory)
                .onDelete(perform: deleteCategory)

                // Abschnitt: Neue Kategorie hinzufügen
                HStack {
                    TextField("Neue Kategorie", text: $newCategoryName)
                    Button(action: addCategory) {
                        Label("Hinzufügen", systemImage: "plus")
                    }
                    .disabled(
                        newCategoryName.trimmingCharacters(in: .whitespaces)
                            .isEmpty)
                }
            }
            .toolbar {
                EditButton()  // Ermöglicht das Löschen und Sortieren
            }
            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Kategorie löschen"),
                            message: Text("Die 'No category'-Kategorie kann nicht gelöscht werden."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            .navigationTitle("Kategorien")
        }
    }

    // Funktion zum Hinzufügen einer neuen Kategorie
    private func addCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let newCategory = RideCategory(name: trimmedName)
        withAnimation {
            modelContext.insert(newCategory)
        }
        newCategoryName = ""
    }

    // Funktion zum Löschen von Kategorien
    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            
            // Verhindere das Löschen der "No category"-Kategorie
            if category.name == "No category" {
                // Zeige eine Benachrichtigung an, dass die Kategorie nicht gelöscht werden kann
                showAlert = true
                return  // Beende die Funktion hier, wenn es die "No category"-Kategorie ist
            }
            
            // Finde die "No category"-Kategorie in der Liste, falls sie existiert
            var noCategory = categories.first { $0.name == "No category" }
            
            // Wenn "No category" noch nicht existiert, erstelle sie
            if noCategory == nil {
                noCategory = RideCategory(name: "No category", orderIndex: -1)
                withAnimation {
                    modelContext.insert(noCategory!)
                }
            }
            
            // Alle betroffenen Rides finden, deren Kategorie die zu löschende Kategorie ist
            let affectedRides = rides.filter { $0.category == category }
            
            // Setze die betroffene Kategorie der Rides auf "No category"
            for ride in affectedRides {
                ride.category = noCategory
            }
            
            // Lösche die Kategorie aus dem Modellkontext
            withAnimation {
                modelContext.delete(category)
            }
            
            // Speichere die Änderungen im Modell
            try? modelContext.save()
        }
    }

    private func moveCategory(from source: IndexSet, to destination: Int) {
        // Erstelle ein Array mit den Kategorien, die verschoben werden sollen
        let movingCategories = source.map { categories[$0] }

        // Erstelle eine kopierte Liste der Kategorien
        var reorderedCategories = categories

        // Entferne die Kategorien aus den ursprünglichen Positionen
        reorderedCategories.remove(atOffsets: source)

        // Füge die verschobenen Kategorien an der neuen Position ein
        reorderedCategories.insert(
            contentsOf: movingCategories, at: destination)

        // Persistiere die neue Reihenfolge
        for (index, category) in reorderedCategories.enumerated() {
            category.orderIndex = index  // Aktualisiere die Reihenfolge im Model
        }
    }
}

#Preview {
    RideCategoriesView()
}
