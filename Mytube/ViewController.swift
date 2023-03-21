//
//  ViewController.swift
//  Mytube
//
//  Created by 여보야 on 2023/03/15.
//

import UIKit


final class ViewController: UIViewController {
    
    @IBOutlet weak var verticalStackView: UIStackView!
    
    @IBOutlet weak var contentsScrollView: UIScrollView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var footerTabBar: UITabBar!
    @IBOutlet weak var headerScrollView: UIScrollView!
    
    @IBOutlet weak var headerStackWrapper: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var shortsView: UIStackView!
    @IBOutlet weak var contentStackWrapper: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var contentBaseView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var allCategoryButton: UIButton!
    @IBOutlet weak var newsCategoryButton: UIButton!
    @IBOutlet weak var gameCategoryButton: UIButton!
    @IBOutlet weak var sendOpnionButton: UIButton!
    @IBOutlet weak var categoryButtonStackView: UIStackView!
    var startPosition: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        generateContent()
        
//        insertSubViews()
//        self.view.bringSubviewToFront(headerScrollView)

        contentsScrollView.delegate = self
        
        setLogoImage()
        makeCategoryButtons()
//        shortsView.frame.
    }

    @IBAction func goSearchScreem(_ sender: Any) {
        guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchViewID") as? SearchViewController else { return }
                // 화면 전환 애니메이션 설정
                secondViewController.modalTransitionStyle = .coverVertical
                // 전환된 화면이 보여지는 방법 설정 (fullScreen)
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: true, completion: nil)
    }
    
    func setLogoImage() {
        logoImageView.image = UIImage(named:"Logo")?.aspectFitImage(inRect: logoImageView.frame)
        
        logoImageView.contentMode = .left
    }
    
    func makeCategoryButtons() {
        var cnt = 0
        for dt in Constraints.categoryTitleString {
            if cnt == 0 { categoryButtonStackView.addArrangedSubview(CategoryButton(dt, true));
                cnt += 1 }
            else {
                categoryButtonStackView.addArrangedSubview(CategoryButton(dt))
            }
        }
    }
    
    func setCategoryButtons() {
        allCategoryButton.sizeToFit()
        newsCategoryButton.sizeToFit()
        sendOpnionButton.sizeToFit()
    }
    
    func insertSubViews() {
        for _ in 1...10 {
//            headerStackView.addArrangedSubview(generateHeaderButton())
        }
    }
    
    //광고 컨텐츠 쇼츠 이후 콘텐츠
    func generateContent() {
        let subView = UIView()
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: contentBaseView.topAnchor),
            subView.leadingAnchor.constraint(equalTo: contentBaseView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: contentBaseView.trailingAnchor),
            subView.heightAnchor.constraint(equalTo: contentBaseView.heightAnchor)
        ])
        
        contentStackView.addArrangedSubview(subView)
    }
    
    func generateAd() {
    }
    
    func generateShortsView() {
    }
    
    func generateShorts() {
    }
    
    func generateSubView() -> UIView {
        let view = UIView()
        
        view.backgroundColor = UIColor (
            cgColor: CGColor(
                red: 1.0,
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: .random(in: 0...1)
            )
        )
    
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: .random(in: 100...400)).isActive = true
        
        return view
    }
    
    func headerAnimationShowAndHide(shouldShow: Bool = true) {
        let duration: TimeInterval = shouldShow ? Constraints.showingConfigure.0 : Constraints.hidingConfigure.0,
            constant: CGFloat = shouldShow ? Constraints.showingConfigure.1 : Constraints.hidingConfigure.1
        
        UIView.animate(withDuration: duration, animations: {
            self.headerHeight.constant = constant
            self.view.layoutIfNeeded()
        })
    }
    
    func generateHeaderButton() -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: 0.2, alpha: 0.2)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: .random(in: 50...100)).isActive = true
        
        return button
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startPosition = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard headerHeight.constant > 0 else {
            return
        }
        
        var contentOffsetY =  contentsScrollView.contentOffset.y - startPosition
        
        if contentOffsetY < 0 {
            contentOffsetY = 0
        } else if contentOffsetY > Constraints.headerBarHeight {
            contentOffsetY = Constraints.headerBarHeight
        }
        
        headerHeight.constant = Constraints.headerBarHeight - contentOffsetY
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let velocity = contentsScrollView.panGestureRecognizer.velocity(in: contentsScrollView).y
        let isPanDown = velocity > 0
        
        switch isPanDown {
        case true where contentsScrollView.contentOffset.y < 1 || velocity > Constraints.showingThreshold:
            headerScrollView.isHidden = false
            headerAnimationShowAndHide(shouldShow: true)
        case false:
            headerAnimationShowAndHide(shouldShow: false)
        case _:
            return
        }
        
        if headerHeight.constant < Constraints.headerBarHeight {
            headerAnimationShowAndHide(shouldShow: false)
        }
    }
}

extension UIImage {
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
