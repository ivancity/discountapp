//
//  SettingsOptionListViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

protocol SettingsOptionListViewModel: class {
    weak var viewDelegate: SettingsViewModelViewDelegate? { get set }
    func controllerTitle() -> String
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func title(at indexPath: IndexPath) -> String
    func subtitle(at indexPath: IndexPath) -> String?
    func isSelected(at indexPath: IndexPath) -> Bool?
    func didSelectRow(at indexPath: IndexPath)
}

protocol SettingsViewModelViewDelegate: class {
    func reloadData()
    func showAlert(message: String, completion: (() -> Void)?)
}
