import Foundation

class PassengerDetailsViewModel: ObservableObject {
    
    @Published var passengerDetails: PassengerDetails
    
    init(initialDetails: PassengerDetails) {
        self.passengerDetails = initialDetails
    }
    
    var isFormValid: Bool {
        !passengerDetails.firstName.isEmpty && !passengerDetails.lastName.isEmpty && !passengerDetails.nationality.isEmpty
    }
    
    func resetDetails() {
        passengerDetails = PassengerDetails()
    }
    
    func updateDetails(with newDetails: PassengerDetails) {
            self.passengerDetails = newDetails
        }
}
