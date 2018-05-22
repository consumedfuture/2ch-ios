//
//  ThreadListViewController.swift
//  2ch ios
//
//  Created by Александр Лычагов on 08.05.2018.
//  Copyright © 2018 Lychagov. All rights reserved.
//

import UIKit
import AlamofireImage

struct File : Codable{
    let displayname : String?
    let thumbnail : String?
    let path: String?
}

struct BoardWithThreads : Codable{
    let Board : String
    let BoardName: String
    let threads : [Thread]
    struct Thread : Codable{
        let comment : String
        let num: String
        let posts_count : Int
        let subject : String
        let files : [File]?
    }
}

class ThreadListViewController: UITableViewController {

    let cellIdentifier = "threadIdentifier"

    public var boardId : String? = ""
    var board : BoardWithThreads?
    
    func setup() {
        
        guard let url = URL(string: "https://2ch.hk/\(boardId!)/catalog_num.json") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let _threads = try JSONDecoder().decode(BoardWithThreads.self, from: data)
                DispatchQueue.main.async {
                    self.board = _threads
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
        self.navigationItem.title = boardId!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return board?.threads.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ThreadViewCell
        guard let thread = board?.threads[indexPath.row] else {return cell!}
        guard let thumb = thread.files?[0].thumbnail else {return cell!}
        guard let url = URL(string: "https://2ch.hk/\(thumb)") else {return cell!}
        cell?.threadImage?.af_setImage(withURL: url)
        cell?.threadTitle?.text = thread.subject
        cell?.threadComment?.text = thread.comment
        cell?.threadComment.sizeToFit()
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let picViewController = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewContoller") as? PictureViewController else {
//            return
//        }
//        guard let thread = board?.threads[indexPath.row] else {return}
//        let files = thread.files
//
//        picViewController.pictures = files
//
//        self.navigationController?.pushViewController(picViewController, animated: true)
        guard let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostListViewController") as? PostListViewController else { return }
        guard let thread = board?.threads[indexPath.row].num else {return}
        postViewController.boardId = boardId!
        postViewController.threadId = thread
        
        self.navigationController?.pushViewController(postViewController, animated: true)
    }


}
