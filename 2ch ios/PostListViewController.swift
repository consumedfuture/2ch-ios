//
//  PostListViewController.swift
//  2ch ios
//
//  Created by Александр Лычагов on 22.05.2018.
//  Copyright © 2018 Lychagov. All rights reserved.
//

import UIKit

struct Post: Codable{
    let comment: String
    let date: String
    let name: String
    let num: String
    let parent: String
    let files: [File]
}

class PostListViewController: UITableViewController {

    public var boardId = ""
    public var threadId = ""
    var posts : [Post]?
    
    let cellIdentifier = "postIdentifier"

    func setup() {
        
        guard let url = URL(string: "https://2ch.hk/makaba/mobile.fcgi?task=get_thread&board=\(boardId)&thread=\(threadId)&num=\(threadId)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let _posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self.posts = _posts
                    self.tableView.reloadData()
                }
            }
            catch let jsonError {
                //let alert = UIAlertController(title: "Error", message: "Error in post list", preferredStyle = .alert)
                //alert.addAction
                print(jsonError)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        self.navigationItem.title = threadId
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostViewCell
        guard let post = posts?[indexPath.row] else {return cell!}
        if (post.files.count > 0){
            guard let thumb = post.files[0].thumbnail else {return cell!}
            guard let url = URL(string: "https://2ch.hk/\(thumb)") else {return cell!}
            cell?.postImage?.af_setImage(withURL: url)
        }
        
        cell?.postTitle?.text = "\(post.name) \(post.date) №\(post.num)"
        cell?.postBody?.text = post.comment
        cell?.postBody.sizeToFit()
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = posts?[indexPath.row] else {return}
        if (post.files.count > 0){
            let files = post.files
            guard let picViewController = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewContoller") as? PictureViewController else {
                return
            }
            picViewController.pictures = files
            self.navigationController?.pushViewController(picViewController, animated: true)
        }
        else {
            return
        }
    }
    

}
