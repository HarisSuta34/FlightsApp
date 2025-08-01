import SwiftUI

struct ReturnDatePickerView: View {
    
    @ObservedObject var homeScreenViewModel: HomeScreenViewModel

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { homeScreenViewModel.showingReturnDatePicker = false }
                .padding()
                Spacer()
                Button("Done") { homeScreenViewModel.showingReturnDatePicker = false }
                .padding()
            }
            DatePicker(
                "Choose return date",
                selection: Binding(
                    get: { homeScreenViewModel.returnDate ?? homeScreenViewModel.departureDate },
                    set: { homeScreenViewModel.returnDate = $0 }
                ),
                in: homeScreenViewModel.departureDate...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }
}

#Preview {
    ReturnDatePickerView(homeScreenViewModel: HomeScreenViewModel())
}
