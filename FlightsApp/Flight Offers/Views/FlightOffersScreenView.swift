import SwiftUI

struct FlightOffersScreenView: View {
    @StateObject private var viewModel: FlightOffersViewModel
    @State private var showingFilterSheet = false
    @State private var filterOptions = FilterOptions()
    
    init(fromCity: String, toCity: String, adults: Int, kids: Int, flightClass: String) {
        _viewModel = StateObject(wrappedValue: FlightOffersViewModel(fromCity: fromCity, toCity: toCity, adults: adults, kids: kids, flightClass: flightClass))
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(red: 235/255, green: 242/255, blue: 250/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(Color(red: 36/255, green: 97/255, blue: 223/255))
                            .frame(height: 180)
                            .edgesIgnoringSafeArea(.top)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "airplane")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                            Text("FLY MOSTAR")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 145)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 15) {
                            VStack(alignment: .leading) {
                                Text("Showing")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                Text("\(viewModel.flightOffers.count) Results")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            Text("Edit search preferences")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                showingFilterSheet = true
                            }) {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                    .offset(y: -40)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding(.top, 50)
                    } else if viewModel.flightOffers.isEmpty {
                        VStack {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.red)
                            Text("No flight offers found.")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        .padding(.top, 50)
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(viewModel.flightOffers) { offer in
                                    FlightOfferCardView(offer: offer)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                        .offset(y: -20)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterOffersView(filters: $filterOptions)
                .onDisappear {
                    viewModel.applyFilters(filters: filterOptions)
                }
        }
    }
}


#Preview {
    FlightOffersScreenView(fromCity: "Mostar", toCity: "Sarajevo", adults: 1, kids: 0, flightClass: "Economy")
}
