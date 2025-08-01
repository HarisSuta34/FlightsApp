import SwiftUI

struct FlightClassSelectionView: View {
    @Binding var showingSheet: Bool
    @Binding var selectedClass: String

    @State private var tempSelectedClass: String

    let flightClasses = ["Economy", "Premium Economy", "Business", "First Class"]

    init(showingSheet: Binding<Bool>, selectedClass: Binding<String>) {
        self._showingSheet = showingSheet
        self._selectedClass = selectedClass
        self._tempSelectedClass = State(initialValue: selectedClass.wrappedValue)
    }

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    showingSheet = false
                }
                .padding()
                Spacer()
                Button("Done") {
                    selectedClass = tempSelectedClass
                    showingSheet = false
                }
                .padding()
            }
            
            Spacer()

            Picker("Select Class", selection: $tempSelectedClass) {
                ForEach(flightClasses, id: \.self) { className in
                    Text(className).tag(className)
                }
            }
            .pickerStyle(.inline)
            .labelsHidden()
            
            Spacer()
        }
    }
}

#Preview {
    FlightClassSelectionView(
        showingSheet: .constant(true),
        selectedClass: .constant("Economy")
    )
}
