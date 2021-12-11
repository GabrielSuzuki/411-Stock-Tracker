//
//  ViewController.swift
//  ViewAutoLayou_IB
//
//  Created by James Shen on 9/29/21.
//
// Alpha api key:MIHCFBCUGBQHA61G
/*import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstName : UITextField!
    @IBOutlet var lastName : UITextField!
    @IBOutlet var cwid : UITextField!
    @IBOutlet var btn : UIButton!
    
    @IBOutlet var outputLabel : UILabel!
    
    var store = CampusStore.get()
    var student : Student!
    
    @IBAction func btnClicked(_ sender: UIButton) {
        let stObj = Student(fn: firstName.text!, ln: lastName.text!, g: .male)
        stObj?.cwid = Int(cwid.text!)
        store.createStudent(stObj: stObj!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if student != nil {
            firstName.text = student.firstName
            lastName.text = student.lastName
            cwid.text = String(student.cwid)
     
            firstName.isUserInteractionEnabled = false
            lastName.isUserInteractionEnabled = false
            cwid.isUserInteractionEnabled = false
            btn.isUserInteractionEnabled = false
        } 
    }


}
*/
