//
//  SearchViewController.swift
//  Mytube
//
//  Created by 여보야 on 2023/03/21.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var goBackButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    
    @objc func keyBoardWillShow(notification: NSNotification) {
            //handle appearing of keyboard here
        let userInfo = notification.userInfo
        let endValue = userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        let durationValue = userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
        let curveValue = userInfo![UIResponder.keyboardAnimationCurveUserInfoKey]
        
        print("보인다", type(of: endValue), type(of: durationValue), type(of: curveValue))
        
//        let endRect = (endValue as AnyObject).cgRectValue
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
                    
        let duration = (durationValue as AnyObject).doubleValue
        
//        contentView.frame.maxY = endRect.origin.y
        
        print("show", contentScrollView.frame.maxY - endRect.origin.y, contentScrollView.frame.maxY, endRect.origin.y, duration)
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
              //handle dismiss of keyboard here
        print("안보인다", type(of:notification.object))
        
        let userInfo = notification.userInfo
        let endValue = userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        let durationValue = userInfo![UIResponder.keyboardAnimationDurationUserInfoKey]
        let curveValue = userInfo![UIResponder.keyboardAnimationCurveUserInfoKey]
        
        
//        let endRect = (endValue as AnyObject).cgRectValue
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        
        let duration = (durationValue as AnyObject).doubleValue
        
//        contentView.frame.origin.y = endRect.origin.y
        
        
        print("hide", contentScrollView.frame.maxY - endRect.origin.y, contentScrollView.frame.maxY, endRect.origin.y, duration)
     }
    
    @IBAction func onPressGoBackButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
}

extension SearchViewController: UITextInteractionDelegate{
    func interactionWillBegin(_ interaction: UITextInteraction) {
        print("야호")
    }
}

extension UIViewController {
        
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer (
            target: self, action: #selector(UIViewController.dissmissKeyboard)
            )
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
}
