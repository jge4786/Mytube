//
//  SearchViewController.swift
//  Mytube
//
//  Created by 여보야 on 2023/03/21.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var goBackButton: UIButton!
    
    //test
    func abc2() {print("A"); print("B")}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        addKeyboardObserver()
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            
            self,
            selector: #selector(keyBoardWillShowAndHide),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShowAndHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
        
    @objc func keyBoardWillShowAndHide(notification: NSNotification) {
        let userInfo = notification.userInfo
        guard let endValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] else { return }
        guard let durationValue = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] else { return }
        
        guard let keyboardHeight = (endValue as? CGRect)?.size.height else { return }
        
        let duration = (durationValue as AnyObject).doubleValue
        
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            contentScrollView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            contentScrollView.contentInset.top = keyboardHeight
            
        case UIResponder.keyboardWillHideNotification:
            contentScrollView.transform = .identity
            contentScrollView.contentInset.top = 0
        default:
            break
        }
    }
    
    @IBAction func onPressGoBackButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
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

