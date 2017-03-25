//
//  DiscountListViewController.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

class DiscountListViewController: UIViewController {

    fileprivate let tableView = UITableView()
    fileprivate let viewModel: TableViewModel
    fileprivate let noDataLabel = UILabel()
    fileprivate let searchHeader = SegmentedSearchView()
    fileprivate let recommendButton = UIButton(type: .system)
    fileprivate var estimatedheight: CGFloat?
    fileprivate weak var keyboardConstraint: KeyboardConstraint?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    init(viewModel: TableViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .sunflowerYellow
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "expanded")
        viewModel.viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupTableView()
    }

    private func setupTableView() {
        searchHeader.delegate = viewModel
        view.addSubview(searchHeader)
        view.addSubview(tableView)
        
        searchHeader.snp.makeConstraints{ make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }

        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        let kbc = KeyboardConstraint(firstItem: bottomLayoutGuide,
                                     firstAttribute: .top,
                                     secondItem: tableView,
                                     secondAttribute: .bottom)
        view.addConstraint(kbc)
        keyboardConstraint = kbc

        noDataLabel.font = UIFont.boldSystemFont(ofSize: 18)
        noDataLabel.textColor = .gunmetal
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        view.addSubview(noDataLabel)
        
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(searchHeader.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        recommendButton.setTitle(
            localizedString("RECOMMEND_PLACE"),
            for: .normal)
        recommendButton.backgroundColor = .sunflowerYellow
        recommendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        recommendButton.setTitleColor(UIColor.white, for: .normal)
        recommendButton.layer.cornerRadius = 5
        recommendButton.isHidden = true
        recommendButton.contentEdgeInsets = UIEdgeInsets(top: 8,
                                                         left: 8,
                                                         bottom: 8,
                                                         right: 8)
        recommendButton.addTarget(self,
                                  action:#selector(recommendPlace),
                                  for: .touchUpInside)
        view.addSubview(recommendButton)
        recommendButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(noDataLabel.snp.bottom).offset(20)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboardConstraint?.offset = bottomLayoutGuide.length
    }

    @objc private func recommendPlace() {
        guard let searchText = searchHeader.searchText else {
            return
        }
        viewModel.recommendPlace(name: searchText)
    }
}

extension DiscountListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let estimatedheight = estimatedheight else {
            return 85.5
        }
        return estimatedheight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableView.cellForRow(at: indexPath) is PlaceTableViewCell ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedheight = cell.frame.height
    }
}

extension DiscountListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.row(at: indexPath) {
        case .place(let place):
            let placeCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceTableViewCell
            placeCell.configure(for: place)
            return placeCell
        case .description(let place):
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "expanded", for: indexPath) as! DescriptionTableViewCell
            descriptionCell.configure(for: place)
            descriptionCell.viewDelegate = self
            return descriptionCell
        }
    }
}

extension DiscountListViewController: TableViewModelViewDelegate {
    func reloadContents() {
        tableView.reloadData()
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: false)
        }
        noDataLabel.isHidden = viewModel.hasResults
        recommendButton.isHidden = viewModel.hasResults
        if recommendButton.isHidden,
            !recommendButton.isUserInteractionEnabled {
            setButton(enabled: true)
        }
        noDataLabel.text = viewModel.noResultText?.uppercased()
    }
    
    func updateSegmentUI(searchText: String, segment: Int) {
        searchHeader.updateUIOn(text: searchText, segment: segment)
    }
    
    func closeItem(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func openItem(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .fade)
        let cellRect = tableView.rectForRow(at: indexPath)
        if !tableView.bounds.contains(cellRect) {
            tableView.scrollRectToVisible(cellRect, animated: true)
        }
    }
    
    func selectRow(at indexPath: IndexPath) {
        view.endEditing(false)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        if !rowIsVisible(at: indexPath) {
            tableView.scrollToNearestSelectedRow(at: .middle, animated: false)
        }
    }
    
    func deSelectRow(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func rowIsVisible(at indexPath: IndexPath) -> Bool {
        guard let indexPaths = tableView.indexPathsForVisibleRows else {
            return false
        }
        return indexPaths.contains(indexPath)
    }
    
    func setButton(enabled: Bool) {
        recommendButton.isUserInteractionEnabled = enabled
        recommendButton.backgroundColor = enabled ?  .sunflowerYellow : .gray
        let title = enabled ? localizedString("RECOMMEND_PLACE") : localizedString("SENDING")
        recommendButton.setTitle(title, for: .normal)
    }
    
    func showRecommendedConfirmAction(title: String?, message: String, completion: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      okTappedHandler: {
                                        completion?(true)
        })
        
        alert.addAction(UIAlertAction(title: localizedString("CANCEL"),
                                      style: .cancel) {_ in
                completion?(false)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func showPlaceRecommendedAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message)
        present(alert, animated: true, completion: nil)
    }
}

extension DiscountListViewController: DescriptionTableViewCellDelegate{
    func openMapTab() {
        viewModel.openMapViewTab()
    }
}
