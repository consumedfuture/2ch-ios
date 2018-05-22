//
//  BoardListViewController.swift
//  2ch ios
//
//  Created by Александр Лычагов on 07.05.2018.
//  Copyright © 2018 Lychagov. All rights reserved.
//

import UIKit

struct Board : Codable{
    let name : String
    let id : String
}


class BoardListViewController: UITableViewController {
    let cellIdentifier = "boardIdentifier"

    //var boards = [String: [Board]]()
    var boards = Dictionary<String, [Board]>()

    private func getValueOfBoard(_indexPath: IndexPath) -> Board{
        let key = Array(boards.keys)[_indexPath.section]
        let array = boards[key]!
        let value = array[_indexPath.row]
        return value
    }
    
    func setup() {

        guard let url = URL(string: "https://2ch.hk/makaba/mobile.fcgi?task=get_boards") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let _boards = try JSONDecoder().decode(Dictionary<String, [Board]>.self, from: data)
                DispatchQueue.main.async {
                    self.boards = _boards
                    self.tableView.reloadData()
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return boards.keys.count
        //return 0
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = Array(boards.keys)[section]
        guard let array = boards[key] else {
            return 0
        }
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let value = getValueOfBoard(_indexPath: indexPath)
        cell.textLabel?.text = value.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(boards.keys)[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let threadListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThreadListViewController") as? ThreadListViewController else {
            return
        }
        let board = getValueOfBoard(_indexPath: indexPath)
        
        threadListViewController.boardId = board.id
        
        self.navigationController?.pushViewController(threadListViewController, animated: true)
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

}
