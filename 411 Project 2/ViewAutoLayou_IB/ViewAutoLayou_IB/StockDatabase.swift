//
//  StockDatabase.swift
//  ViewAutoLayou_IB
//
//  Created by Gabriel Suzuki on 12/10/21.
//

//import Foundation
import SQLite

//
class Database {
    var conn : Connection!
    var stockTbl : Table!
    var stockID : Expression<Int>!
    var symCol : Expression<String>!
    var dateCol : Expression<String>!
    var openCol : Expression<Double>!
    var highCol : Expression<Double>!
    var lowCol : Expression<Double>!
    var closeCol : Expression<Double>!
    var volumeCol : Expression<Int>!
    var amountCol : Expression<Int>!
    
    init() {
        let rootPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = rootPath.appendingPathComponent("Campus.sqlite").path
        print("Sqlite database location: \(dbPath)")
        
        // Create/open the database connection
        conn = try! Connection(dbPath)

        initialize()
    }

    func initialize() {
        stockTbl = Table("Stocks")
        stockID = Expression<Int>("id")
        symCol = Expression<String>("company_name")
        dateCol = Expression<String>("date")
        openCol = Expression<Double>("open")
        highCol = Expression<Double>("high")
        lowCol = Expression<Double>("low")
        closeCol = Expression<Double>("close")
        volumeCol = Expression<Int>("volume")
        amountCol = Expression<Int>("amount")
        let crTbl = stockTbl.create(ifNotExists: true) { t in
            t.column(stockID)
            t.column(symCol)
            t.column(dateCol)
            t.column(openCol)
            t.column(highCol)
            t.column(lowCol)
            t.column(closeCol)
            t.column(volumeCol)
            t.column(amountCol)
        }
        try! conn.run(crTbl)
}
}
// Singleton object
class StockDatabase {

    static private var instance : StockDatabase!
    var database = Database()
    
    static func get() -> StockDatabase {
        if instance == nil {
            instance = StockDatabase()
        }
        return instance
    }
    
    func createStock(stObj : Company) {
        let conn = database.conn!
        let tbl = database.stockTbl!
        let insStmt = tbl.insert(database.symCol <- stObj.symbol, database.dateCol <- stObj.date, database.openCol <- stObj.open, database.highCol <- stObj.high, database.lowCol <- stObj.low, database.closeCol <- stObj.close, database.volumeCol <- stObj.volume,database.amountCol <- stObj.amount, database.stockID <- stObj.stockID)
        try! conn.run(insStmt)
    }
    
    func getStocksList() -> [Company] {
        var list = [Company]()
        let conn = database.conn!
        let tbl = database.stockTbl!
        let rs = try! conn.prepare(tbl)
        for r in rs {
            let stObj = try! Company(sym: r.get(database.symCol), dat: r.get(database.dateCol), ope: r.get(database.openCol), hig: r.get(database.highCol), lo: r.get(database.lowCol), clo: r.get(database.closeCol), vol: r.get(database.volumeCol),amo: r.get(database.amountCol), stoID: r.get(database.stockID))
            list.append(stObj!)
        }
        return list
    }
    
    
    func deleteStock(sObj : Company) {
        print("Deleting company : \(sObj.symbol)")
        let tbl = database.stockTbl!
        let conn = database.conn!
        let filterTbl = tbl.filter(database.stockID == sObj.stockID)
        try! conn.run(filterTbl.delete())
    }
}

