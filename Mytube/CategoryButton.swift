//
//  CategoryButton.swift
//  Mytube
//
//  Created by 여보야 on 2023/03/21.
//

import UIKit

class CategoryButton: UIButton {
    var titleString: String = ""
    var isChosen: Bool = false
    let colorCollection = [(1.0, 0.0), (0.0, 0.94)]
    
    override func draw(_ rect: CGRect) {
        let pallete = isChosen ? colorCollection[0] : colorCollection[1]
        self.setTitle(titleString, for: .normal)
        
        self.layer.backgroundColor = CGColor(red: pallete.1, green: pallete.1, blue: pallete.1, alpha: 1)
        
        self.setTitleColor(UIColor(red: pallete.0, green: pallete.0, blue: pallete.0, alpha: 1), for: .normal)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
       
   override init(frame: CGRect){
       super.init(frame: frame)
   }
   
    init(_ titleString: String, _ isChosen: Bool = false) {
        super.init(frame: CGRect.zero)
        
        self.titleString = titleString
        self.isChosen = isChosen
    }
    
    convenience init() {
        self.init("")
    }
}
