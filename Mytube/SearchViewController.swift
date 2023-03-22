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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShowAndHide(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShowAndHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    // 키보드의 높이, 키보드가 열린 뒤 스크롤뷰의 offset
    var prevOffset: CGFloat = 0.0, prevPosition: CGFloat = 0.0
    
    
    @objc func keyBoardWillShowAndHide(notification: NSNotification) {
        let userInfo = notification.userInfo
        guard let endValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] else { return }
        guard let durationValue = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] else { return }
        
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        
        let duration = (durationValue as AnyObject).doubleValue
        
        let keyboardOverlap = contentScrollView.frame.maxY - endRect.origin.y
        
//        print(keyboardOverlap, contentScrollView.contentOffset.y)
        
        UIView.animate(withDuration: duration ?? 0.25, delay: 0.0) {
            self.contentScrollView.contentInset.bottom = keyboardOverlap
            self.contentScrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            if keyboardOverlap > 0 {
                self.contentScrollView.contentOffset.y = keyboardOverlap + self.contentScrollView.contentOffset.y
                self.prevOffset = keyboardOverlap
                self.prevPosition = self.contentScrollView.contentOffset.y
            }else {
//                print("확인", self.prevPosition, self.prevOffset, self.contentScrollView.contentOffset.y, self.contentScrollView.frame.height, self.contentScrollView.frame.maxY, endRect.origin.y, keyboardOverlap)
                
                //스크롤의 끝에서 키보드를 열었을 경우 오작동 방지
                self.prevOffset -= (self.prevPosition - self.contentScrollView.contentOffset.y)
                
                self.contentScrollView.contentOffset.y = self.contentScrollView.contentOffset.y - self.prevOffset
            }
            
            self.view.layoutIfNeeded()
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
