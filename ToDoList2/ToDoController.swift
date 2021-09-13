//
//  ToDoController.swift
//  ToDoList2
//
//  Created by Dayna Grigsby on 9/12/21.
//

import UIKit
import FirebaseDatabase

class ToDoController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let ref = Database.database().reference() //reference to database
    
    var things = [String]() //the string array that stores the list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddTapped(_ sender: Any) { //when user taps add button, notification pops up and they can add the note
        let alert = UIAlertController(title: "Add list item", message: nil, preferredStyle: UIAlertController.Style.alert) //titles the alert
        alert.addTextField {(thingTF) in
            thingTF.placeholder = "Enter list item" //placeholder where user enters to do list item
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let thing = alert.textFields?.first?.text else {return}
            self.things.append(thing) //puts the entry into the array
            self.tableView.reloadData() //reloads the table so that it updates
            self.ref.child("note\(self.things.count)").setValue(thing)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ToDoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return things.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let thing = things[indexPath.row]
        cell.textLabel?.text = thing
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        things.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        print(indexPath.row)
        ref.child("note\(indexPath.row + 1)").removeValue()
    }
}
