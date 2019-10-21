//
//  extensionUIView.swift
//  checkers
//
//  Created by Сергей on 03/10/2019.
//  Copyright © 2019 Sergei. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addBackground() {
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "woodenPlank.png")
        
        imageViewBackground.contentMode = .scaleToFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
        
    }
    
    
    
}
