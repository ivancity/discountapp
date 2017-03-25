//
//  SegmentedSearchView.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

protocol SegmentedSearchViewDelegate: class {
    func updateSearch(searchText: String, forSegment: Int)
}

class SegmentedSearchView: UIView {

    weak var delegate: SegmentedSearchViewDelegate?

    var searchText: String? { return searchBar.text }

    fileprivate var searchTextOnCancel = ""

    fileprivate let searchBar: UISearchBar = DiscountSearchBar()
    fileprivate let segmentedControl: UISegmentedControl

    private let localizedSegments = [
        localizedString("SEGMENT_ALL"),
        localizedString("SEGMENT_FOOD"),
        localizedString("SEGMENT_HEALTH"),
        localizedString("SEGMENT_OTHER")
    ]
    
    private let smallMargin = AppDimensions.Margins.small.value
    private let regularMargin = AppDimensions.Margins.regular.value
    
    override init(frame: CGRect) {
        segmentedControl = UISegmentedControl(items: localizedSegments)
        super.init(frame: frame)
        searchBar.delegate = self
        segmentedControl.addTarget(self, action: #selector(filterPlaces), for: .valueChanged)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(searchBar)
        addSubview(segmentedControl)
        searchBar.snp.makeConstraints{ make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        segmentedControl.snp.makeConstraints{ make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.bottom.equalTo(self).offset(-regularMargin)
        }
        
        backgroundColor = .sunflowerYellow
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .gunmetal
    }
    
    func filterPlaces(sender: UISegmentedControl) {
        var currentText = ""
        if let text = searchBar.text {
            currentText = text
        }
        delegate?.updateSearch(searchText: currentText, forSegment: sender.selectedSegmentIndex)
    }
    
    func updateUIOn(text: String, segment: Int) {
        searchBar.text = text
        segmentedControl.selectedSegmentIndex = segment
        searchTextOnCancel = text
    }
}

extension SegmentedSearchView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let sbt = searchBar.text {
            searchTextOnCancel = sbt
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchTextOnCancel
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.updateSearch(searchText: searchText, forSegment: segmentedControl.selectedSegmentIndex)
    }
}
