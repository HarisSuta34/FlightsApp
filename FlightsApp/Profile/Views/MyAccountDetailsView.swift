import SwiftUI

struct MyAccountDetailsView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)

            VStack(spacing: 20) {
                Text("Account Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 15) {
                    AccountDetailRowView(title: "Email", value: viewModel.email, icon: "envelope.fill")

                    AccountDetailRowView(title: "Username", value: viewModel.username ?? "Not set", icon: "person.fill")

                    if let creationDate = viewModel.creationDate {
                        AccountDetailRowView(title: "Member Since", value: creationDate.formatted(date: .long, time: .shortened), icon: "calendar")
                    } else {
                        AccountDetailRowView(title: "Member Since", value: "N/A", icon: "calendar")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle("Account Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Account Details")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyAccountDetailsView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
