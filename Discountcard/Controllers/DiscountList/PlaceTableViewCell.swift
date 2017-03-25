//
//  PlaceTableViewCell.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

private let regularMargin = AppDimensions.Margins.regular.value
private let smallMargin = 2

class PlaceTableViewCell: UITableViewCell {
    private let placeNameLabel = UILabel()
    private let placeCityLabel = UILabel()
    private let placeOpenedLabel = UILabel()
    private let toggleImage = UIImageView()
    private let toggleOpenIcon = #imageLiteral(resourceName: "expand_icon")
    private let typeImage = UIImageView()
    private let separator = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configureLabels()
        addViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(placeCityLabel)
        contentView.addSubview(placeOpenedLabel)
        contentView.addSubview(separator)
        contentView.addSubview(typeImage)
        
        toggleImage.image = toggleOpenIcon
        contentView.addSubview(toggleImage)
        
        contentView.backgroundColor = .white
        separator.backgroundColor = .whiteTwo
    }
    
    func configureLabels() {
        placeNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        placeCityLabel.font = UIFont.systemFont(ofSize: 12)
        placeOpenedLabel.font = UIFont.systemFont(ofSize: 12)
        
        placeNameLabel.textColor = .textBlack
        placeCityLabel.textColor = .textBlack
        placeOpenedLabel.textColor = .textBlack
    }
    
    func addViewConstraints() {
        placeNameLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView).offset(regularMargin).priority(999)
            make.left.equalTo(contentView).offset(regularMargin)
        }

        placeCityLabel.snp.makeConstraints{ make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(smallMargin)
            make.left.equalTo(contentView).offset(regularMargin)
        }
        
        placeOpenedLabel.snp.makeConstraints{ make in
            make.top.equalTo(placeCityLabel.snp.bottom).offset(smallMargin)
            make.left.equalTo(contentView).offset(regularMargin)
        }
        
        separator.snp.makeConstraints{ make in
            make.top.equalTo(placeOpenedLabel.snp.bottom).offset(regularMargin)
            make.height.equalTo(1)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        toggleImage.snp.makeConstraints{ make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-regularMargin)
        }
        
        typeImage.snp.makeConstraints{ make in
            make.right.equalTo(toggleImage.snp.left).offset(-regularMargin)
            make.centerY.equalTo(contentView)
        }
    }
    
    func configure(for place: Place) {
        let weekday = place.openingTimes.getOpenToday()
        
        placeNameLabel.text = place.name
        placeCityLabel.text = place.location.city?.localizedUppercase
        placeOpenedLabel.text = weekday
        typeImage.image = place.typeIcon
    }
    
    private func rotateIcon(by radians: Double, animated: Bool) {
        let affineTransform = CGAffineTransform(rotationAngle: CGFloat(radians))
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.toggleImage.transform = affineTransform
            })
        } else {
            toggleImage.transform = affineTransform
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rotateIcon(by: isSelected ? M_PI_4 : 0.0, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rotateIcon(by: isSelected ? M_PI_4 : 0.0, animated: true)
    }
}
