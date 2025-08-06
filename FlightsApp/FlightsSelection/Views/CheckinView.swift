import SwiftUI
import PhotosUI



struct CheckinView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    @State private var passportDetails = PassportDetails()
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    private var isFormValid: Bool {
        !passportDetails.passportNumber.isEmpty && !passportDetails.countryOfIssue.isEmpty
    }
    
    private var isCheckinComplete: Bool {
        isFormValid || selectedImageData != nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Passport Details").foregroundColor(.white)) {
                    TextField("Passport Number", text: $passportDetails.passportNumber)
                        .listRowBackground(Color.white)
                    
                    TextField("Country of Issue", text: $passportDetails.countryOfIssue)
                        .listRowBackground(Color.white)
                    
                    DatePicker("Expiration Date", selection: $passportDetails.expirationDate, displayedComponents: .date)
                        .listRowBackground(Color.white)
                }
                
                Section(header: Text("Upload Passport Photo (Optional)").foregroundColor(.white)) {
                    HStack {
                        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
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
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select a photo", systemImage: "photo.on.rectangle.angled")
                            .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.white)
                    .onChange(of: selectedItem) { oldItem, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
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
                    status = .completed
                    dismiss()
                }) {
                    Text("Complete")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isCheckinComplete ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isCheckinComplete)
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
    CheckinView(status: .constant(.incomplete))
}
