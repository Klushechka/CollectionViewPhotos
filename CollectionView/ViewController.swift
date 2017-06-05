//
//  ViewController.swift
//  CollectionView
//
//  Created by Ольга Клюшкина on 29.05.17.
//  Copyright © 2017 klyushkina. All rights reserved.
//

import UIKit
import Foundation

let links = ["http://i.imgur.com/Z0LTWRC.jpg", "http://i.imgur.com/ZmTLOzs.jpg", "http://i.imgur.com/uFrH34P.jpg", "http://i.imgur.com/Kh9Y8Ev.png", "http://i.imgur.com/YNPqRDw.jpg", "http://i.imgur.com/X7ceAsb.jpg", "http://i.imgur.com/Cv3L8cl.jpg", "http://i.imgur.com/ej7UIFZ.png", "http://i.imgur.com/zPBpAmr.jpg", "http://i.imgur.com/QlcWhJO.jpg", "http://i.imgur.com/xM1ZAEa.jpg", "http://i.imgur.com/a6Rl9IO.jpg", "http://i.imgur.com/nrxMPCk.jpg", "http://i.imgur.com/oYjFb88.jpg", "http://i.imgur.com/5FRo09n.jpg", "http://i.imgur.com/ib0dKbb.png", "http://i.imgur.com/FcIHlnk.png", "http://i.imgur.com/t20UDXb.png", "http://i.imgur.com/ppOS84P.png", "http://i.imgur.com/4s42ADA.jpg"]

class ViewController: UICollectionViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    var url = URL(string: links[0])!
    var currentImageN = 0
    var myImageArray = [UIImage]()
    var myIndex = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationItem.prompt = "Please, add new images by button \"+\""
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return myImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.image.image = myImageArray[indexPath.row]
        myIndex = indexPath
        return cell
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        self.navigationItem.prompt = ""
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "load 3 in parallels", style: .default, handler: { action in
            // load images in parallers
            // code
            let session = URLSession(configuration: .ephemeral)
            for i in 0...2 {
                let url = URL(string: links[self.currentImageN])
                self.currentImageN += 1
                let task = session.dataTask(with: url!) {(data, responce, error) in
                    DispatchQueue.main.async {
                        if data != nil {
                            self.myImageArray.append(UIImage(data: data!)!)
                            self.collectionView?.reloadData()
                        }
                    }
                }
                task.resume()
            }
        }))
        alertController.addAction(UIAlertAction(title: "load 3 image by image", style: .default, handler: { (action) in
            // load 3 image by image
            // code
            let session = URLSession(configuration: .ephemeral)
            var url = URL(string: links[self.currentImageN])
            self.currentImageN += 1
            let task1 = session.dataTask(with: url!) {(data, responce, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        self.myImageArray.append(UIImage(data: data!)!)
                        self.collectionView?.reloadData()
                        self.currentImageN += 1
                            }
                        }
                    }
            task1.resume()
            url = URL(string: links[self.currentImageN + 1])
            let task2 = session.dataTask(with: url!) {(data, responce, error) in
                    DispatchQueue.main.async {
                        if data != nil {
                            self.myImageArray.append(UIImage(data: data!)!)
                            self.collectionView?.reloadData()
                            self.currentImageN += 1
                        }
                    }
                }
            task2.resume()
            url = URL(string: links[self.currentImageN + 2])
            let task3 = session.dataTask(with: url!) {(data, responce, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        self.myImageArray.append(UIImage(data: data!)!)
                        self.collectionView?.reloadData()
                        self.currentImageN += 1
                    }
                }
            }
            task3.resume()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ImageVC = segue.destination as? ImageVC {
            ImageVC.bigPhoto = self.myImageArray[myIndex.row]
        }
    }
    
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
}
