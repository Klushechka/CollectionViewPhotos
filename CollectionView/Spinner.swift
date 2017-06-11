//
//  Spinner.swift
//  CollectionView
//
//  Created by Admin on 10.06.17.
//  Copyright © 2017 klyushkina. All rights reserved.
//

import Foundation
import UIKit

class Spinner: UIViewController{
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    func start(){
        actInd.frame = CGRect(x: 0.0,y: 0.0,width: 40.0,height: 40.0)
        actInd.center = view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func stop(){
        actInd.stopAnimating()
        actInd.isHidden = true
    }
}
