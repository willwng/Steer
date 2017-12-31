//
//  HomeTableViewController.swift
//  Steer
//
//  Created by Mac Sierra on 12/24/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit
import iCalKit
import SQLite3

class HomeTableViewController: UITableViewController {

    var output = [String]()
    var ids = [Int]()
    var db: OpaquePointer?
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Classes.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Classes (id INTEGER PRIMARY KEY NOT NULL, name TEXT, url TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        loadClassData()
        
    }

    @IBAction func Refresh(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
        self.courses.removeAll()
        self.loadClassData()
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HomeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let course = courses[indexPath.row]
        
        cell.classLabel.text = course.title
        cell.taskLabel.text = course.description

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.courses.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteRow(row: indexPath.row + ids.first!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.courses.removeAll()
        self.loadClassData()
        self.tableView.reloadData()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    private func deleteRow(row: Int){
        let deleteString = "DELETE FROM Classes WHERE id = \(row);"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    private func loadClassData() {
        let queryString = "SELECT * FROM Classes ORDER BY id"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var coursesData = [CourseData]()
        ids.removeAll()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = Int(sqlite3_column_int(stmt, 0))
            ids.append(id)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let url = String(cString: sqlite3_column_text(stmt, 2))
            coursesData.append(CourseData(name: String(describing: name), url: String(describing: url)))
        }
        
        for classes in coursesData{
            var data = ""
            let url = URL(string: classes.url)
            guard let cals = try? iCal.load(url: url!) else {
                return
            }
            output.removeAll()
            for cal in cals {
                for event in cal.subComponents where event is Event {
                    data = String(describing: event)
                    data += "\n"
                    output.append(data)
                }
            }
            output = output.reversed()
            data = output.joined()
            data = data.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
            if (data.isEmpty) {
                //Say something
            }
            let class1 = Course(title: classes.name, description: data)
            courses += [class1]
        }
    }
}

