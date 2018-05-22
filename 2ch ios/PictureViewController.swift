//
//  PictureViewController.swift
//  2ch ios
//
//  Created by Александр Лычагов on 22.05.2018.
//  Copyright © 2018 Lychagov. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {

    @IBOutlet var galleryView: GalleryView!

    public var pictures: [File]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadImages(){
        guard let pictures = pictures else {return}
        galleryView.loadUrls(urls: pictures)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
