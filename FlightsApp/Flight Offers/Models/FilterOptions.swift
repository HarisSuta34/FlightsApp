//
//  FilterOptions.swift
//

import Foundation

// MARK: - FilterOptions struct to hold filter data
// This struct will be used by both the View and the ViewModel
struct FilterOptions {
    var maxPrice: Double = 500
    // Additional filters like airline, stops, etc. can be added here
}
