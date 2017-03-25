//
//  DescriptionTableViewCell
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import SnapKit

protocol DescriptionTableViewCellDelegate: class {
    func openMapTab()
}

private let regularMargin = AppDimensions.Margins.regular.value
private let smallMargin = AppDimensions.Margins.small.value

class DescriptionTableViewCell: UITableViewCell {
    

    // MARK: Properties
    weak var viewDelegate: DescriptionTableViewCellDelegate?
    private let homepageLabel = UILabel()
    private let addressLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let locationImageView = UIImageView()
    private var locationImage = UIImage()
    private let locationImageLabel = UILabel()
    private let locationImageContainer = UIView()
    private let separator = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        selectionStyle = .none
        setupSubviews()
        addViewConstraints()
        addViewStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        locationImage = #imageLiteral(resourceName: "location_pin_icon")
        locationImageView.image = locationImage
        locationImageLabel.text = localizedString("SHOW_ON_MAP")
        locationImageContainer.addSubview(locationImageView)
        locationImageContainer.addSubview(locationImageLabel)
        locationImageContainer.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(goToMapViewTab))
        )
        
        homepageLabel.isUserInteractionEnabled = true
        homepageLabel.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(goToHomepage(gestureRecognizer:))))
        
        contentView.addSubview(locationImageContainer)
        contentView.addSubview(addressLabel)
        contentView.addSubview(homepageLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(separator)
    }
    
    func addViewStyles() {
        contentView.backgroundColor = .whiteThree
        separator.backgroundColor = .whiteTwo
        addressLabel.font = UIFont.boldSystemFont(ofSize: 12)
        locationImageLabel.font = UIFont.boldSystemFont(ofSize: 10)
        addressLabel.textColor = .textBlack
        locationImageLabel.textColor = .textBlack
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        homepageLabel.textColor = .ceruleanBlue
    }
    
    func addViewConstraints() {
        
        locationImageContainer.snp.makeConstraints{ make in
            make.top.equalTo(contentView).priority(999)
            make.right.equalTo(contentView)
        }
        locationImageView.snp.makeConstraints{ make in
            make.top.equalTo(locationImageContainer).offset(smallMargin)
            make.centerX.equalTo(locationImageContainer)
        }
        locationImageLabel.snp.makeConstraints{ make in
            make.top.equalTo(locationImageView.snp.bottom).offset(3)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(locationImageContainer).offset(-smallMargin)
        }
        addressLabel.snp.makeConstraints{ make in
            make.left.equalTo(contentView).offset(regularMargin)
            make.centerY.equalTo(locationImageContainer)
            make.right.equalTo(locationImageContainer)
        }
        separator.snp.makeConstraints{ make in
            make.top.equalTo(locationImageContainer.snp.bottom)
            make.height.equalTo(1.0)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        descriptionLabel.snp.makeConstraints{ make in
            make.top.equalTo(separator.snp.bottom).offset(regularMargin)
            make.left.equalTo(contentView).offset(regularMargin)
            make.right.equalTo(contentView).offset(-regularMargin)
        }
        homepageLabel.snp.makeConstraints{ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(regularMargin)
            make.left.equalTo(contentView).offset(regularMargin)
            make.right.equalTo(contentView).offset(-regularMargin)
            make.bottom.equalTo(contentView).offset(-regularMargin)
        }
    }
    
    
    func configure(for place: Place) {
        homepageLabel.text = place.homepage
        addressLabel.text = place.formattedAddress
        
        if let desc = place.localizedDescription {
            descriptionLabel.attributedText = NSAttributedString.attributedString(text: desc, lineSpacing: 15)
        }
        
        selectionStyle = .none
    }
    
    func goToHomepage(gestureRecognizer: UIGestureRecognizer) {
        guard let label = gestureRecognizer.view as? UILabel, let labelText = label.text, let url = URL(string: labelText) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func goToMapViewTab(gestureRecognizer: UIGestureRecognizer) {
        viewDelegate?.openMapTab()
    }
}
