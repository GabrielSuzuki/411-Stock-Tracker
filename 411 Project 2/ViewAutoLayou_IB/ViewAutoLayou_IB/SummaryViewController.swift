//
//  SummaryViewController.swift
//  ViewAutoLayou_IB
//
//  Created by James Shen on 10/13/21.
//

/*import UIKit

class SummaryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = store.getStudents().count
        print("Numner of entries to display: \(cnt)")
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "StudentSummaryCell", for: indexPath)
        let student = store.getStudents()[indexPath.row]
        cell.textLabel?.text = student.fullName
        cell.detailTextLabel?.text = String(student.cwid)
        return cell
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let student = store.getStudents()[row]
            store.deleteStudent(sObj: student)
            //
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBOutlet var tblView : UITableView!
    var store = CampusStore.get()

    @IBAction func delBtnClicked(_ sender: UIButton) {
        print("isEditing : \(isEditing)")
        if tblView.isEditing {
            sender.setTitle("DELETE", for: .normal)
            //setEditing(false, animated: true)
            tblView.setEditing(false, animated: true)
        } else {
            sender.setTitle("DONE", for: .normal)
            tblView.setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self 
    }

    override func viewWillAppear(_ animated: Bool) {
        tblView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowDetails":
            if let row = tblView.indexPathForSelectedRow?.row {
                let stObj = store.getStudents()[row]
                let viewController = segue.destination as! ViewController
                viewController.student = stObj
            }
        case "AddStudent":
            let viewController = segue.destination as! ViewController
            viewController.student = nil 
        default:
            print("Unexpected segure identifier ... ")
        }
    }
}
*/
