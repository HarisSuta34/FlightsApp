import Foundation
import SwiftUI
import PhotosUI
import UIKit

@available(iOS 16.0, *)
class CheckinViewModel: ObservableObject {
        
    @Published var passportDetails: PassportDetails
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
        
    init(initialDetails: PassportDetails, initialImageData: Data?) {
        self.passportDetails = initialDetails
        self.selectedImageData = initialImageData
    }
        
    var isFormValid: Bool {
        !passportDetails.passportNumber.isEmpty && !passportDetails.countryOfIssue.isEmpty
    }
    
    var isCheckinComplete: Bool {
        isFormValid || selectedImageData != nil
    }
        
    func handlePhotoPickerChange(newItem: PhotosPickerItem?) {
        guard let newItem = newItem else { return }
        
        Task {
            if let data = try? await newItem.loadTransferable(type: Data.self) {
                DispatchQueue.main.async {
                    self.selectedImageData = data
                }
            }
        }
    }
    
}

