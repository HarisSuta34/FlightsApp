import SwiftUI

struct PassengerDetailsView: View {
    @Binding var status: CompletionStatus
    @Binding var details: PassengerDetails
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: PassengerDetailsViewModel

    init(status: Binding<CompletionStatus>, details: Binding<PassengerDetails>) {
        _status = status
        _details = details
        _viewModel = StateObject(wrappedValue: PassengerDetailsViewModel(
            initialDetails: details.wrappedValue))
    }
    
    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea()
            
            Form {
                Section(header: Text("Personal Information").foregroundColor(.white)) {
                    TextField("First Name", text: $viewModel.passengerDetails.firstName)
                        .listRowBackground(Color.white)
                    TextField("Last Name", text: $viewModel.passengerDetails.lastName)
                        .listRowBackground(Color.white)
                    TextField("Nationality", text: $viewModel.passengerDetails.nationality)
                        .listRowBackground(Color.white)
                    
                    DatePicker("Date of Birth", selection: $viewModel.passengerDetails.dateOfBirth, displayedComponents: .date)
                        .listRowBackground(Color.white)
                    
                    Picker("Gender", selection: $viewModel.passengerDetails.gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                    .listRowBackground(Color.white)
                }
                
                Section {
                    HStack {
                        
                       /* Button(action: {
                            viewModel.resetDetails()
                            //details = viewModel.passengerDetails
                            status = .incomplete
                            dismiss()
                        }) {
                            Text("Reset Details")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        }
                        .background(Color.green)*/
                        
                        
                        Button("Reset Details") {
                            viewModel.resetDetails()
                            details = PassengerDetails()
                            //details = viewModel.passengerDetails
                            status = .incomplete
                            dismiss()
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.white)
                        
                       /* Button(action: {
                            //details = viewModel.passengerDetails
                            status = .completed
                            dismiss()
                        }) {
                            Text("Save Details")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                        .background(Color.gray)*/
                        
                    }
                    .padding(.vertical, 8)
                    //.listRowBackground(Color.white)
                }
                HStack{
                    Button("Save Details") {
                        details = viewModel.passengerDetails
                        status = .completed
                        dismiss()
                    }
                    .disabled(!viewModel.isFormValid)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.white)
                    .padding(.trailing, 5)
                }
                .padding(.vertical, 8)
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
