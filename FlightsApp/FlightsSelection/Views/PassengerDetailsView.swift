import SwiftUI

struct PassengerDetailsView: View {
    @Binding var status: CompletionStatus
    @Binding var details: PassengerDetails
    @Environment(\.dismiss) var dismiss
    
    private var isFormValid: Bool {
        !details.firstName.isEmpty && !details.lastName.isEmpty && !details.nationality.isEmpty
    }
    
    private func resetForm() {
        details = PassengerDetails()
        status = .incomplete
        dismiss()
    }
    
    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea()
            
            Form {
                Section(header: Text("Personal Information").foregroundColor(.white)) {
                    TextField("First Name", text: $details.firstName)
                        .listRowBackground(Color.white)
                    TextField("Last Name", text: $details.lastName)
                        .listRowBackground(Color.white)
                    TextField("Nationality", text: $details.nationality)
                        .listRowBackground(Color.white)
                    
                    DatePicker("Date of Birth", selection: $details.dateOfBirth, displayedComponents: .date)
                        .listRowBackground(Color.white)
                    
                    Picker("Gender", selection: $details.gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                    .listRowBackground(Color.white)
                }
                
                Section {
                    HStack {
                        Button("Reset Details") {
                            resetForm()
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.white)
                        
                        Button("Save Details") {
                            status = .completed
                            dismiss()
                        }
                        .disabled(!isFormValid)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.white)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.white)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Passenger Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(red: 36/255, green: 97/255, blue: 223/255), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
