//
//  ImageUpload.swift
//  CollectionView
//
//  Created by Admin on 10.06.17.
//  Copyright © 2017 klyushkina. All rights reserved.
//

import Foundation
import UIKit

class ImageUpload {
    static let shared = ImageUpload()
    private init() {}
        var currentImageN = 0
    var myImageArray = [UIImage]()
    
    func parallelLoading(){
        let session = URLSession(configuration: .ephemeral)
        for _ in 0...2 {
            if self.currentImageN <= links.count {
                let url = URL(string: links[self.currentImageN])
                self.currentImageN += 1
                let task = session.dataTask(with: url!) {(data, responce, error) in
                    DispatchQueue.main.async {
                        guard let data = data else {print("Data is empty")
                            return }
                            self.myImageArray.append(self.resizeImage(UIImage(data: data)!, newHeight: 100))
                            NotificationCenter.default.post(name: .reload, object: self)
                    }
                }
                task.resume()
            }
        }
    }
    
    func sequentialLoading(){
        let session = URLSession(configuration: .ephemeral)
        if self.currentImageN <= links.count {
            var url = URL(string: links[self.currentImageN])
            self.currentImageN += 1
            let task1 = session.dataTask(with: url!) {(data, responce, error) in
                DispatchQueue.main.async {
                    guard let data = data else {print("Data is empty")
                        return }
                        self.myImageArray.append(UIImage(data: data)!)
                        NotificationCenter.default.post(name: .reload, object: self)
                        self.currentImageN += 1
                    }
                    if self.currentImageN + 1 <= links.count {
                        url = URL(string: links[self.currentImageN + 1])
                        let task2 = session.dataTask(with: url!) {(data, responce, error) in
                            DispatchQueue.main.async {
                                guard let data = data else {print("Data is empty")
                                    return }
                                    self.myImageArray.append(UIImage(data: data)!)
                                     NotificationCenter.default.post(name: .reload, object: self)
                                    self.currentImageN += 1
                            }
                            if self.currentImageN + 2 <= links.count {
                                url = URL(string: links[self.currentImageN + 2])
                                let task3 = session.dataTask(with: url!) {(data, responce, error) in
                                    DispatchQueue.main.async {
                                        guard let data = data else {print("Data is empty")
                                            return }
                                            self.myImageArray.append(UIImage(data: data)!)
                                            NotificationCenter.default.post(name: .reload, object: self)
                                            self.currentImageN += 1
                                        }
                                    }
                                task3.resume()
                            }
                        }
                        task2.resume()
                    }
                }
            task1.resume()
        }
    }
    
    func resizeImage(_ image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(newImage!, 0.1)! as Data
        UIGraphicsEndImageContext()
        return UIImage(data:imageData)!
    }
}

