//
//  SettingOptionViewController.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

class SettingOptionViewController: UIViewController {
    
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let viewModel: SettingsOptionListViewModel
    
    init(viewModel: SettingsOptionListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.viewDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        title = viewModel.controllerTitle()
        navigationController?.navigationBar.barTintColor = .gunmetal
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .gunmetal
        tableView.backgroundColor = .gunmetal
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
}

extension SettingOptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension SettingOptionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.tintColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel.title(at: indexPath)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .gunmetal
        if let isSelected = viewModel.isSelected(at: indexPath) {
            cell.accessoryType = isSelected ? .checkmark : .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        if let subTitle = viewModel.subtitle(at: indexPath) {
            cell.detailTextLabel?.text = subTitle
        }
        return cell
    }
}

extension SettingOptionViewController: SettingsViewModelViewDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showAlert(message: String, completion: (() -> Void)?) {
        present(
            UIAlertController(message: message,
                              okTappedHandler: completion),
            animated: true)
    }
}

