//
//  DiscountCardViewController.swift
//  Discountcard
//
//  Created by test on 07/11/16.
//  Copyright © 2016 Mooncascade Ou. All rights reserved.
//

import UIKit
import SnapKit

class DiscountCardViewController: UIViewController, UITextFieldDelegate {
    
    private let textInput = UITextField()
    let defaultKeyboardVerticalOffset: CGFloat =  200.0
    private var userName: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "userName") {
                return value
            }
            else{
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userName")
            UserDefaults.standard.synchronize()
        }
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        view.backgroundColor = .gunmetal
        let backgroundView = UIView()
        backgroundView.backgroundColor = .gunmetal
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "card_logo"))
        
        let separator = UIView()
        separator.backgroundColor = .sunflowerYellow
        textInput.tintColor = .sunflowerYellow
        textInput.textColor = .whiteThree
        textInput.font = UIFont.systemFont(ofSize: 28)
        textInput.attributedPlaceholder = NSAttributedString(string: localizedString("CARD_PLACEHOLDER"), attributes: [NSForegroundColorAttributeName: UIColor.whiteTwo])
        textInput.text = userName
        textInput.textAlignment = .center
        textInput.delegate = self
        view.addSubview(backgroundView)
        view.addSubview(imageView)
        view.addSubview(separator)
        view.addSubview(textInput)
        
        backgroundView.snp.makeConstraints({ make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalTo(view)
        })
        imageView.snp.makeConstraints{ make in
            make.centerY.equalTo(view).dividedBy(2)
            make.centerX.equalTo(view)
        }
        separator.snp.makeConstraints{ make in
            make.height.equalTo(2)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.centerX.equalTo(view)
        }
        textInput.snp.makeConstraints{ make in
            make.bottom.equalTo(separator.snp.top).offset(-8)
            make.centerX.equalTo(view)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(44)
        }
        textInput.returnKeyType = .done
        
        let kbc = KeyboardConstraint(item: bottomLayoutGuide,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: separator,
                                     attribute: .bottom,
                                     multiplier: 1,
                                     constant: defaultKeyboardVerticalOffset)
        kbc.defaultOffset = defaultKeyboardVerticalOffset
        view.addConstraint(kbc)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textInput.text {
            userName = text
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
