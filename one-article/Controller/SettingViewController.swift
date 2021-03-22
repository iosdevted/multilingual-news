//
//  SettingViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/22.
//

import UIKit
import SnapKit

private let ReuseIdentifier: String = "CellReuseIdentifier"

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    
    private var languages =
        [Setting(icon: UIImage(named: "united-states-of-america") ?? UIImage(), title: "English"),
        Setting(icon: UIImage(named: "france") ?? UIImage(), title: "French"),
        Setting(icon: UIImage(named: "japan") ?? UIImage(), title: "Japanese"),
        Setting(icon: UIImage(named: "south-korea") ?? UIImage(), title: "Korean")]
                        
    
    // MARK: - Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureNavigationBarUI()
    }
    
    //MARK: - Helpers
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isEditing = true
        //Allow Selection During Editing, unless click doesn't work
        tableView.allowsSelectionDuringEditing = true
        
        self.tableView.register(SettingsViewTableCell.self, forCellReuseIdentifier: ReuseIdentifier)
    }
    
    private func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Manage Languages"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDelegate/DataSource

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
  
        let cell = tableView.cellForRow(at: indexPath) as! SettingsViewTableCell
        cell.checkBox.toggleCheckState()
//        switch cell.checkBox.checkState {
//        case .unchecked:
//            cell.checkBox.checkState = .checked
//        case .checked:
//            cell.checkBox.checkState = .unchecked
//        default:
//            print("Dont' use this type .mixed")
//        }
    }
}

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return settingOptions.allCases.count
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! SettingsViewTableCell
//        guard let option = settingOptions(rawValue: indexPath.row) else { return SettingsViewTableCell() }
//        cell.languageImageView.image = option.image
//        cell.titleLabel.text = option.description
        
        cell.languageImageView.image = languages[indexPath.row].icon
        cell.titleLabel.text = languages[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.languages[sourceIndexPath.row]
        languages.remove(at: sourceIndexPath.row)
        languages.insert(movedObject, at: destinationIndexPath.row)
    }
}
