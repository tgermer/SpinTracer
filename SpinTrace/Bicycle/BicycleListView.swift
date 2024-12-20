import SwiftUI
import SwiftData

struct BicycleListView: View {
    @Environment(\.modelContext) var modelContext

    @Query(sort: \Bicycle.name) var bicycles: [Bicycle]

    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    @State private var newBicycleName: String = ""
    @State private var newBicycleSheet: Bool = false

    var body: some View {
        NavigationStack {

            content

                .navigationTitle("tab-bicycles")
                .toolbar {
                    Button(
                        "Add", systemImage: "plus",
                        action: { newBicycleSheet.toggle() })
                }
                .sheet(
                    isPresented: $newBicycleSheet,
                    onDismiss: didDismiss
                ) {
                    Form {
                        Section("New Bicycle Name") {
                            HStack {
                                TextField(
                                    "New Bicycle Name", text: $newBicycleName)
                                Button("Add", action: addBicycle)
                                    .disabled(newBicycleName.isEmpty)
                            }
                        }
                    }

                    .presentationDetents([.fraction(0.2), .medium, .large])
                }
                .alert("Fehler", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage ?? "Ein unbekannter Fehler ist aufgetreten.")
                }
                .refreshable {
                    await refreshData()  // Asynchrones Laden von Daten
                }
        }
    }

    
    func addBicycle() {
        var uniqueName = newBicycleName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Suche nach bestehenden Fahrrädern mit demselben Namen
        let existingNames: [String]
            do {
                existingNames = try modelContext.fetch(FetchDescriptor<Bicycle>()).map { $0.name }
            } catch {
                print("Fehler beim Abrufen bestehender Fahrräder: \(error.localizedDescription)")
                return
            }
        
        // Falls der Name bereits existiert, füge eine Zahl hinzu
        var counter = 1
        while existingNames.contains(uniqueName) {
            uniqueName = "\(newBicycleName) \(counter)"
            counter += 1
        }
        
        // Neues Fahrrad erstellen und speichern
        let newBicycle = Bicycle(name: uniqueName)
        withAnimation {
            modelContext.insert(newBicycle)
        }
        do {
            try modelContext.save()
            print("Fahrrad erfolgreich gespeichert: \(uniqueName)")
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
        }
        
        // Eingabefeld zurücksetzen
        newBicycleName = ""
        newBicycleSheet = false
    }

    func deleteBicycle(_ indexSet: IndexSet) {
        for index in indexSet {
            let bicycle = bicycles[index]
            withAnimation {
                modelContext.delete(bicycle)
            }
        }
    }

    func didDismiss() {
        newBicycleSheet = false
    }

    // Asynchrone Funktion, um die Daten zu aktualisieren
    func refreshData() async {
        // Hier kannst du die Logik zum Laden von neuen Daten implementieren
        // Zum Beispiel: Neue Daten von einer API nachladen oder das Modell aktualisieren
        try? await Task.sleep(nanoseconds: 1_000_000_000)  // Beispiel für Verzögerung

        // Modellkontext speichern (nachdem neue Daten hinzugefügt oder geändert wurden)
        try? modelContext.save()
    }

    @ViewBuilder
    private var content: some View {
        if bicycles.isEmpty {
            emptyView
        } else {
            listView
        }
    }

    var emptyView: some View {
        ContentUnavailableView(
            label: {
                Label("No Bicycles", systemImage: "bicycle")
                    .symbolRenderingMode(.hierarchical)
            },
            description: {
                Text("Bicycles you add will appear here.")
            },
            actions: {
                Button("Add Bicycle") {
                    newBicycleSheet.toggle()
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            }
        )
    }

    var listView: some View {
        List {
            ForEach(bicycles) { bicycle in
                NavigationLink(
                    destination: BicycleDetailView(bicycle: bicycle)
                ) {
                    BicycleRowView(bicycle: bicycle)
                }
            }
            .onDelete(perform: deleteBicycle)
        }
    }
}

struct BicycleRowView: View {
    let bicycle: Bicycle
    
    var body: some View {
        HStack {
            Image(systemName: "bicycle.circle.fill")
                .resizable()
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color(red: bicycle.colorRed, green: bicycle.colorGreen, blue: bicycle.colorBlue))
                .frame(width: 40, height: 40)
//            Circle()
//                .fill(Color(red: bicycle.colorRed, green:  bicycle.colorGreen, blue: bicycle.colorBlue))
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(bicycle.name)
                    .font(.headline)
                Text("Total: \(Int(bicycle.totalMileage)) km")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
//                Text("Current: \(Int(bicycle.purchaseMileage)) km")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NavigationView {
        BicycleListView()
            .modelContainer(for: Bicycle.self, inMemory: false)
    }
    .navigationTitle("tab-bicycle")
    .navigationBarTitleDisplayMode(.large)
}
