//
//  ToDoController.swift
//  ToDoList2
//
//  Created by Dayna Grigsby on 9/12/21.
//

import UIKit

class ToDoController: UIViewController {

    @IBOutlet weak var viewTable: UITableView!
    
    var things = [String]() //the string array that stores the list
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
