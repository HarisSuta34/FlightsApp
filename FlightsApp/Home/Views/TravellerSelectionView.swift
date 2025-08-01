import SwiftUI

struct TravellerSelectionView: View {
    @Binding var showingSheet: Bool
    @Binding var numberOfAdults: Int
    @Binding var numberOfKids: Int
    
    @State private var tempAdults: Int
    @State private var tempKids: Int
    
    init(showingSheet: Binding<Bool>, numberOfAdults: Binding<Int>, numberOfKids: Binding<Int>) {
        self._showingSheet = showingSheet
        self._numberOfAdults = numberOfAdults
        self._numberOfKids = numberOfKids
        
        self._tempAdults = State(initialValue: numberOfAdults.wrappedValue)
        self._tempKids = State(initialValue: numberOfKids.wrappedValue)
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
                    numberOfAdults = tempAdults
                    numberOfKids = tempKids
                    showingSheet = false
                }
                .padding()
            }
            
            Spacer()

            VStack(spacing: 20) {
                HStack {
                    Text("Adults")
                        .font(.headline)
                    Spacer()
                    Stepper("", value: $tempAdults, in: 1...10)
                    Text("\(tempAdults)")
                        .font(.title2)
                        .frame(width: 40, alignment: .trailing)
                }
                
                HStack {
                    Text("Children")
                        .font(.headline)
                    Spacer()
                    Stepper("", value: $tempKids, in: 0...5)
                    Text("\(tempKids)")
                        .font(.title2)
                        .frame(width: 40, alignment: .trailing)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    TravellerSelectionView(
        showingSheet: .constant(true),
        numberOfAdults: .constant(2),
        numberOfKids: .constant(1)     
    )
}
