import SwiftUI
import PhotosUI

struct CheckinView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    // NOVO: Binding varijable za PassportDetails i sliku
    @Binding var passportDetails: PassportDetails
    @Binding var selectedImageData: Data?
    
    @StateObject private var viewModel: CheckinViewModel
    
    // NOVO: Inicijalizator za ViewModel
    init(status: Binding<CompletionStatus>, passportDetails: Binding<PassportDetails>, selectedImageData: Binding<Data?>) {
        _status = status
        _passportDetails = passportDetails
        _selectedImageData = selectedImageData
        _viewModel = StateObject(wrappedValue: CheckinViewModel(
            initialDetails: passportDetails.wrappedValue,
            initialImageData: selectedImageData.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Passport Details").foregroundColor(.white)) {
                    TextField("Passport Number", text: $viewModel.passportDetails.passportNumber)
                        .listRowBackground(Color.white)
                    
                    TextField("Country of Issue", text: $viewModel.passportDetails.countryOfIssue)
                        .listRowBackground(Color.white)
                    
                    DatePicker("Expiration Date", selection: $viewModel.passportDetails.expirationDate, displayedComponents: .date)
                        .listRowBackground(Color.white)
                }
                
                Section(header: Text("Upload Passport Photo (Optional)").foregroundColor(.white)) {
                    HStack {
                        if let selectedImageData = viewModel.selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .listRowBackground(Color.white)
                    
                    PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                        Label("Select a photo", systemImage: "photo.on.rectangle.angled")
                            .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.white)
                    .onChange(of: viewModel.selectedItem) { oldItem, newItem in
                        viewModel.handlePhotoPickerChange(newItem: newItem)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 36/255, green: 97/255, blue: 223/255))
            
            HStack(spacing: 20) {
                Button(action: {
                    status = .incomplete
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // NOVO: Ažuriramo stanje u FlightSelectionSheetView
                    passportDetails = viewModel.passportDetails
                    selectedImageData = viewModel.selectedImageData
                    status = .completed
                    dismiss()
                }) {
                    Text("Complete")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isCheckinComplete ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isCheckinComplete)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("Online Check-in")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(red: 36/255, green: 97/255, blue: 223/255), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    CheckinView(status: .constant(.incomplete), passportDetails: .constant(PassportDetails()), selectedImageData: .constant(nil))
}
