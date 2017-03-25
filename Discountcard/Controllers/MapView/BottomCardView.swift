//
//  BottomCardView.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import SnapKit

protocol BottomCardDelegate: class {
    func cardDidTapClose()
    func directionTap(place: Place)
}

/**
 Generates a BottomCardView based on the frames given by the ViewController
 holding its reference.
 */
class BottomCardView : UIView {
    //dimensions
    private let regularMargin = AppDimensions.Margins.regular.value
    private let smallMargin = AppDimensions.Margins.small.value
    private let mediumMargin = AppDimensions.Margins.medium.value
    
    //views
    private let titleLabel = UILabel()
    private let openingTimeLabel = UILabel()
    private var addressLabel = UILabel()
    private let titleBar = UIView()
    private let typeImage = UIImageView()
    private var headerView = UIStackView()
    private var addressView = UIStackView()
    private var separator = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let descriptionLabel = UILabel()
    private var homepageLabel = UILabel()
    public private(set) var currentPlace: Place? = nil
    private var scrollViewHeightConstraint: SnapKit.Constraint?
    
    var isOpen = false
    weak var delegate: BottomCardDelegate?
    var cardHeight: CGFloat {
        get {
            return frame.size.height
        }
    }
    
    var showHideConstraint: ConstraintMakerEditable? = nil
    
    /**
     Initialize using ViewController's frame. This init will generate the correct size. No need to calculate anything before passing ViewController's frame
     - Parameter frame: The full frame size containing this BottomCardView
     */
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        
        addHeader()
        addDetailView()
        addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHeader() {
        
        titleBar.backgroundColor = .whiteTwo
        
        let toggleImage = UIImageView(image: #imageLiteral(resourceName: "expand_icon"))
        toggleImage.transform = CGAffineTransform(rotationAngle: CGFloat(45 / 180 * M_PI))

        titleLabel.numberOfLines = 0
        titleLabel.font =  UIFont.boldSystemFont(ofSize: 16)
        openingTimeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        let labelStackView = headerLabels(with: titleLabel, openingTimeLabel)
        let iconStackView = headerIcons(with: typeImage, toggleImage)
        
        headerView = UIStackView(arrangedSubviews: [labelStackView, iconStackView])
        headerView.axis = .horizontal
        headerView.spacing = 5
        headerView.distribution = .equalSpacing
        
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClose(gestureRecognizer:))))
        
        addSubview(titleBar)
        titleBar.addSubview(headerView)
    }
    
    private func headerLabels(with labels: UILabel...) -> UIStackView {
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }
    
    private func headerIcons(with icons: UIImageView...) -> UIStackView {
        
        let icons = icons.map({ icon -> (UIImageView) in
            icon.contentMode = .scaleAspectFit
            return icon
        })
        
        let stackView = UIStackView(arrangedSubviews: icons)
        stackView.axis = .horizontal
        stackView.spacing = mediumMargin
        stackView.distribution = .equalSpacing

        return stackView
    }
    
    private func addDetailView() {
        
        addressView = addressStackView()
        addSubview(addressView)
        
        //separator
        addSubview(separator)
        separator.backgroundColor = .whiteTwo
        
        //scroll view
        addSubview(scrollView)
        
        //description label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(descriptionLabel)
        
        //website link
        homepageLabel.isUserInteractionEnabled = true
        homepageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedHomepage(gestureRecognizer:))))
        homepageLabel.textColor = .ceruleanBlue
        
        contentView.addSubview(homepageLabel)
        scrollView.addSubview(contentView)
    }
    
    private func addressStackView() -> UIStackView {
        addressLabel.font = UIFont.boldSystemFont(ofSize: 12)
        addressLabel.textColor = .textBlack
        
        let directionsStackView = directionsView()
        
        let stackView = UIStackView(arrangedSubviews: [addressLabel, directionsStackView])
        stackView.axis = .horizontal
        stackView.spacing = mediumMargin
        stackView.distribution = .equalSpacing

        return stackView
    }
    
    private func directionsView() -> UIStackView {
        
        let locationImageView = UIImageView(image: #imageLiteral(resourceName: "location_pin_icon"))
        locationImageView.contentMode = .scaleAspectFit
        
        let locationImageLabel = UILabel()
        locationImageLabel.text = localizedString("DIRECTIONS")
        locationImageLabel.font = UIFont.boldSystemFont(ofSize: 10)
        locationImageLabel.textColor = .textBlack
        
        let stackView = UIStackView(arrangedSubviews: [locationImageView, locationImageLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDirection(gestureRecognizer:))))
    
        return stackView
    }
    
    private func addViewConstraints() {
        
        //Constraints for header
        titleBar.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
        }
        
        headerView.snp.makeConstraints { make in
            make.edges.equalTo(titleBar).inset(UIEdgeInsets(top: regularMargin,
                                                            left: regularMargin,
                                                            bottom: regularMargin,
                                                            right: regularMargin))
        }
        
        addressView.snp.makeConstraints{ make in
            make.top.equalTo(titleBar.snp.bottom).offset(smallMargin)
            make.left.equalTo(self).offset(regularMargin)
            make.right.equalTo(self).offset(-regularMargin)
        }
        
        //Constraints for detailed view
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(smallMargin)
            make.height.equalTo(1.0)
            make.left.right.equalTo(self)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            scrollViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(regularMargin)
            make.left.equalTo(contentView).offset(regularMargin)
            make.right.equalTo(contentView).offset(-regularMargin)
        }
        
        homepageLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(regularMargin)
            make.left.equalTo(contentView).offset(regularMargin)
            make.right.equalTo(contentView).offset(-regularMargin)
            make.bottom.equalTo(contentView).offset(-regularMargin)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self)
        }
    }
    
    func updateCard(with place: Place) {
        isOpen = true
        currentPlace = place
        titleLabel.text = place.name
        openingTimeLabel.text = place.openingTimes.getOpenToday()
        homepageLabel.text = place.homepage
        typeImage.image = place.typeIcon
        
        if let desc = place.localizedDescription {
            descriptionLabel.attributedText = NSAttributedString.attributedString(text: desc, lineSpacing: 15)
        }
        
        addressLabel.text = place.formattedAddress
        updateScrollViewHeight()
        toggleCard(offset: -cardHeight, animated: true)
    }
    
    func hideCard() {
        isOpen = false
        toggleCard(offset: 0, animated: true)
    }
    
    private func updateScrollViewHeight() {
        layoutIfNeeded()
        scrollViewHeightConstraint?.update(offset: min(contentView.frame.height, 200))
        layoutIfNeeded()
    }
    
    func toggleCard(offset: CGFloat, animated: Bool) {
        showHideConstraint?.constraint.update(offset: offset)
        superview?.setNeedsLayout()
        if animated {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.superview?.layoutIfNeeded()
            }
        } else {
            superview?.layoutIfNeeded()
        }
    }
    
    func clickedHomepage(gestureRecognizer: UIGestureRecognizer) {
        guard let label = gestureRecognizer.view as? UILabel, let labelText = label.text, let url = URL(string: labelText) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func tapClose(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.cardDidTapClose()
    }
    
    func tapDirection(gestureRecognizer: UITapGestureRecognizer) {
        guard let currentPlace = currentPlace else {
            return
        }
        delegate?.directionTap(place: currentPlace)
    }
}
