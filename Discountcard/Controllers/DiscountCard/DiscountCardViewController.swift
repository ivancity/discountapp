//
//  DiscountCardViewController.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import SnapKit

private let defaultKeyboardVerticalOffset: CGFloat =  180.0


class DiscountCardViewController: UIViewController {

    fileprivate let viewModel: DiscountCardViewModel

    private var separatorBottom: SnapKit.ConstraintMakerEditable?

    init(viewModel: DiscountCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.backgroundColor = .gunmetal

        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
        }

        let separator = UIView()
        separator.backgroundColor = .sunflowerYellow
        container.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.centerX.equalTo(container)
            separatorBottom = make.bottom.greaterThanOrEqualTo(container)
                .offset(-defaultKeyboardVerticalOffset)
        }

        let textField = UITextField()
        textField.tintColor = .sunflowerYellow
        textField.textColor = .whiteThree
        textField.font = UIFont.systemFont(ofSize: 28)
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(
            string: localizedString("CARD_PLACEHOLDER"),
            attributes: [NSForegroundColorAttributeName: UIColor.whiteTwo]
        )
        textField.text = viewModel.userName
        textField.textAlignment = .center
        textField.delegate = self

        container.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(separator.snp.top).offset(-8)
            make.centerX.equalTo(container)
            make.left.equalTo(container).offset(20)
            make.right.equalTo(container).offset(-20)
            make.height.equalTo(44)
        }

        let kbc = KeyboardConstraint(firstItem: bottomLayoutGuide,
                                     firstAttribute: .bottom,
                                     secondItem: container,
                                     secondAttribute: .bottom)
        kbc.onChange = { [weak separatorBottom] show in
            let offset = show ? -30 : -defaultKeyboardVerticalOffset
            separatorBottom?.constraint.update(offset: offset)
        }
        view.addConstraint(kbc)

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapped))
        )
    }

    @objc private func tapped() {
        view.endEditing(true)
    }
}


extension DiscountCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.set(userName: textField.text)
    }
}
