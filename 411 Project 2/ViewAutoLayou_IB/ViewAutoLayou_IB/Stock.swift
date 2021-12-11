//
//  Stock.swift
//  ViewAutoLayou_IB
//
//  Created by Gabriel Suzuki on 11/17/21.
//
// Provides a struct and class to organize the data.

import UIKit
//struct used to get the information from the JSON
struct DailyPrices: Codable {
    let date: String
    let open: Double
    let high : Double
    let low : Double
    let close : Double
    let volume : Int
}

//Class used to organize the information of each stock.
class Company : Codable{
    var stockID : Int = 0
    var date: String
    var open: Double
    var high : Double
    var low : Double
    var close : Double
    var volume : Int
    var symbol : String = ""
    var amount : Int = 0
    
    // Designated Initializer
    init?(sym : String, dat : String, ope : Double, hig : Double, lo: Double, clo : Double, vol : Int, amo : Int, stoID : Int) {
        if (sym.isEmpty) {
            return nil
        }
        stockID = stoID
        symbol = sym
        date = dat
        open = ope
        high = hig
        low = lo
        close = clo
        volume = vol
        amount = amo
    }
    
    // Convenience Initializer
    convenience init?(p : Company) {
        self.init(sym: p.symbol, dat: p.date, ope: p.open, hig: p.high, lo: p.low, clo: p.close, vol:p.volume, amo: p.amount, stoID: p.stockID)
    }
}
