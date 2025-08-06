//
//  Seat.swift
//  FlightsApp
//
//  Created by Haris Suta on 6. 8. 2025..
//

import Foundation

struct Seat: Identifiable {
    let id = UUID()
    let row: Int
    let column: String
    var status: SeatStatus
    var seatNumber: String { "\(row)\(column)" }
}
