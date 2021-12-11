//
//  SummaryViewController.swift
//  ViewAutoLayou_IB
//
//  Created by Gabriel Suzuki on 12/10/21.
//
// This program will be used for adding stocks and showing them off on a table.
import UIKit

class SimpleSummaryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //finds the number of rows in the table based on the count of listedCompanies
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = self.listedCompanies.count
        return cnt
    }
    
    //Fills each cell will the symbol, the shares owned, and the current cost of each stock
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "SimpleStudentSummaryCell", for: indexPath)
        let addText = self.listedCompanies[indexPath.row].symbol + " Cost: $" + String(self.listedCompanies[indexPath.row].close)
        var last = stocks.getStocksList()
        var newLast : Company = self.listedCompanies[indexPath.row]
        //var curr : Company = last
        
        let curr = self.listedCompanies[indexPath.row]
        for i in last {
            if curr.symbol == i.symbol {
                newLast = i
            }
        }
        //let subText = " Shares Owned: " + String(self.listedCompanies[indexPath.row].amount)
        let subText = " Shares Owned: " + String(newLast.amount)
        cell.textLabel?.text = addText
        cell.detailTextLabel?.text = subText
        return cell
    }
    
    //Allows for the deletion of stocks in both the database and the tableview
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let stock = stocks.getStocksList()[row]
            stocks.deleteStock(sObj: stock)
            self.listedCompanies.remove(at: indexPath.row)
            tblView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    //Uses a API call to find information on the stock and then adds it to the database
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let currentDate = formatDate()
        tblView.reloadData()
        let amount : Int? = Int(amountTextField.text ?? "0")
        if let c = addTextField.text {
            let jsonUrlStringPrice = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol="+c+"&outputsize=100&apikey=MIHCFBCUGBQHA61G"
              //API key need to be claim in AlphaVantage
                let dataTask = URLSession.shared.dataTask(with: URL(string: jsonUrlStringPrice)!){ (data, response, err) in
                            guard let data = data else {return}
                            
                            do{
                                var currentStockDate = ""
                                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                                var symbols = ""
                                
                                if let information = json["Meta Data"] as? NSDictionary{
                                    if let symbol = information["2. Symbol"]{
                                        symbols = symbol as! String
                                        if let range = symbols.range(of: ":"){
                                            symbols = String(symbols[range.upperBound...])
                                        }
                                    }
                                    if let lastRefreshed = information["3. Last Refreshed"]{
                                        currentStockDate = lastRefreshed as! String
                                        if let range = currentStockDate.range(of: ":"){
                                            currentStockDate = String(currentStockDate[range.upperBound...])
                                        }
                                    }
                                }
                                if let prices = json["Time Series (Daily)"] as? NSDictionary{
                                    guard let priceArray = prices as? [String: AnyObject] else {return}
                                    self.arrangeDate = []
                                        for (key, value) in priceArray{
                                            if key == currentStockDate {
                                                guard let open = value["1. open"] as? String else {return}
                                                guard let high = value["2. high"] as? String else {return}
                                                guard let low = value["3. low"] as? String else {return}
                                                guard let close = value["4. close"] as? String else {return}
                                                guard let volume = value["5. volume"] as? String else {return}
                                                self.arrangeDate.append([key, open, high, low, close, volume])
                                            }
                                        }
                                }
                                var tempFinalArray = [DailyPrices]()
                                for var data in self.arrangeDate{
                                    tempFinalArray.append(DailyPrices(date: data[0], open: Double(data[1])!, high: Double(data[2])!, low: Double(data[3])!, close: Double(data[4])!, volume: Int(data[5])!))
                                }

                                for i in tempFinalArray {
                                    if amount != nil{
                                        var stockID = 0
                                        var row = 0
                                        if self.stocks.getStocksList().count == 0 {
                                            stockID = 0
                                        } else {
                                            row = self.stocks.getStocksList().count - 1
                                            stockID = self.stocks.getStocksList()[row].stockID + 1
                                        }
                                        if symbols != "" {
                                            if i != nil {
                                                self.stocks.createStock(stObj: Company(sym: symbols, dat: i.date, ope: i.open, hig: i.high, lo: i.low, clo: i.close, vol: i.volume, /*stdt: currentDate,*/ amo: amount!, stoID: stockID)!)
                                                self.listedCompanies.append(Company(sym: symbols, dat: i.date, ope: i.open, hig: i.high, lo: i.low, clo: i.close, vol: i.volume, /*stdt: currentDate,*/ amo: amount!, stoID: stockID)!)
                                            }
                                        }
                                       
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tblView.reloadData()
                                }
                                
                           }catch let err{
                                print(err)
                           }
                }
                dataTask.resume()
            tblView.reloadData()
        }
        
    }
    
    var tblArray = [String]()
    var stocks = StockDatabase.get()
    var arrangeDate = [[String]]()
    var listedCompanies = [Company]()

    var companies = [String]()

    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet var addTextField : UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet var tblView : UITableView!
    var pressed = false
    
    //I am using this to test some things to refresh the page while running
    @IBAction func refreshBtnClicked(_ sender: UIBarButtonItem) {
        tblView.reloadData()
    }
    
    //When clicked the title will change and the editing mode will also change
    @IBAction func delBtnClicked(_ sender: UIButton) {
        if tblView.isEditing {
            sender.setTitle("DELETE", for: .normal)
            tblView.setEditing(false, animated: true)
        } else {
            sender.setTitle("DONE", for: .normal)
            tblView.setEditing(true, animated: true)
        }
    }
    
    //it will pull each stock from the database to get the past information and the will make API calls for each one to get the current information on the stock
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.isEditing = false
        let databaseCompany = stocks.getStocksList()
        var amount = [Int]()
        for item in databaseCompany{
            companies.append(item.symbol)
            amount.append(item.amount)
        }
        let currentDate = formatDate()
        self.listedCompanies = []
        var count = 0
        for company in companies{
          let jsonUrlStringPrice = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol="+company+"&outputsize=100&apikey=MIHCFBCUGBQHA61G"
          //API key need to be claim in AlphaVantage
            let dataTask = URLSession.shared.dataTask(with: URL(string: jsonUrlStringPrice)!){ (data, response, err) in
                        guard let data = data else {return}
                        
                        do{
                            var currentStockDate = ""
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                            var symbols = ""
                            
                            if let information = json["Meta Data"] as? NSDictionary{
                                if let symbol = information["2. Symbol"]{
                                    symbols = symbol as! String
                                    if let range = symbols.range(of: ":"){
                                        symbols = String(symbols[range.upperBound...])
                                    }
                                }

                                if let lastRefreshed = information["3. Last Refreshed"]{
                                    currentStockDate = lastRefreshed as! String
                                    if let range = currentStockDate.range(of: ":"){
                                        currentStockDate = String(currentStockDate[range.upperBound...])
                                    }
                                }
                            }
                            
                            if let prices = json["Time Series (Daily)"] as? NSDictionary{
                                guard let priceArray = prices as? [String: AnyObject] else {return}
                                self.arrangeDate = []
                                    for (key, value) in priceArray{
                                        if key == currentStockDate {
                                            
                                            guard let open = value["1. open"] as? String else {return}
                                            guard let high = value["2. high"] as? String else {return}
                                            guard let low = value["3. low"] as? String else {return}
                                            guard let close = value["4. close"] as? String else {return}
                                            guard let volume = value["5. volume"] as? String else {return}
                                            self.arrangeDate.append([key, open, high, low, close, volume])
                                        }
                                    }
                            }

                            var tempFinalArray = [DailyPrices]()
                            
                            for var data in self.arrangeDate{
                                tempFinalArray.append(DailyPrices(date: data[0], open: Double(data[1])!, high: Double(data[2])!, low: Double(data[3])!, close: Double(data[4])!, volume: Int(data[5])!))
                            }
                            
                            var stockID = 1
                            for i in tempFinalArray {
                                if symbols != "" {
                                    if i != nil {
                                        self.listedCompanies.append(Company(sym: symbols, dat: i.date, ope: i.open, hig: i.high, lo: i.low, clo: i.close, vol: i.volume, amo: amount[count], stoID: stockID)!)
                                           stockID += 1
                                           count += 1
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                       }catch let err{
                            print(err)
                       }
            }
            dataTask.resume()
        }
        tblView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        tblView.reloadData()
    }
    
    //When clicking on a cell the program will segue to the other view controller initialize it with information from both the past and current versions of the stock
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case "ShowDetails":
            if let row = tblView.indexPathForSelectedRow?.row {
                var last = stocks.getStocksList()
                var newLast : Company = self.listedCompanies[row]
                //var curr : Company = last
                
                let curr = self.listedCompanies[row]
                for i in last {
                    if curr.symbol == i.symbol {
                        newLast = i
                    }
                }
                //let curr = self.listedCompanies[row]
                let viewController = segue.destination as! ViewController
                viewController.row = row
                viewController.last = newLast
                viewController.current = curr
            }
        default:
            print("Unexpected segure identifier ... ")
        }
    }
    
    //function used to find the current date in the correct format
    func formatDate() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return (String(year) + "-" + String(month) + "-" + String(day))
    }
}
