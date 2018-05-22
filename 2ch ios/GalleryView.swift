
//
//  GalleryView.swift
//  2ch ios
//
//  Created by Александр Лычагов on 22.05.2018.
//  Copyright © 2018 Lychagov. All rights reserved.
//

import UIKit

class GalleryView: UIView {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControll: UIPageControl!

    var urls: [URL?] = []
    
    public func loadUrls(urls links: [File]) {
        urls = links.map { URL(string: "https://2ch.hk\($0.path!)") }
        reloadImages()
    }
    
    public func reloadImages() {
        var x = CGFloat(0)
        let width = scrollView.frame.size.width
        
        for url in urls {
            guard let url = url else {
                continue
            }
            
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: width, height: scrollView.frame.size.height))
            imageView.contentMode = .scaleAspectFit
            imageView.af_setImage(withURL: url)
            
            scrollView.addSubview(imageView)
            
            x += width
        }
        
        pageControll.numberOfPages = Int(x / width)
        scrollView.contentSize = CGSize(width: x, height: 0)
    }
    
}

extension GalleryView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / scrollView.frame.size.width
        let index = Int(floor(x - 0.5)) + 1
        
        pageControll.currentPage = index
    }
    
}
