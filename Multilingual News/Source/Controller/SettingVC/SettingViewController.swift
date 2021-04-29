//
//  SettingViewController.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/22.
//

import KRProgressHUD
import SnapKit
import UIKit

class SettingViewController: UIViewController {

    // MARK: - Properties
    
    private let realmManager = RealmManager.shared
    private var languages = [Language]()
    private let tableView = UITableView()

    // MARK: - Life Cycle

    init(languages: [Language]) {
        self.languages = languages
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavigationBarUI()
    }

    // MARK: - Selectors

    @objc func backButtonTapped() {
        isfourlanguages(with: languages) ? goBackToMainView() : showErrorMessage()
    }

    // MARK: - Helpers

    private func isfourlanguages(with languages: [Language]) -> Bool {
        var count = 0
        languages.forEach {
            $0.isChecked == true ? count += 1 : print("")
        }
        return (count == 4) ? true : false
    }
    
    private func goBackToMainView() {
        self.saveRealmData(with: languages)
        dismiss(animated: true)
    }

    private func showErrorMessage() {
        KRProgressHUD.appearance().style = .custom(background: .white, text: .black, icon: .black)
        KRProgressHUD.showInfo(withMessage: "You should select 4 languages")
    }
    
    // MARK: - Realm
    
    private func deleteRealmData() {
        realmManager.deleteAllDataForObject(RealmLanguage.self)
    }
    
    private func saveRealmData(with languages: [Language]) {
        deleteRealmData()

        languages.forEach {
            let realmLanguage = RealmLanguage()
            realmLanguage.update(with: $0)
            realmManager.add(realmLanguage)
        }
    }
    
    // MARK: - ConfigureUI

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isEditing = true
        // Allow Selection During Editing, unless click doesn't work
        tableView.allowsSelectionDuringEditing = true
        self.tableView.register(cellType: SettingsViewTableCell.self)
    }

    private func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        
        let leftBarItem = UIBarButtonItem(customView: UILabel.mainTitleFont(with: "Manage Languages"))
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .oceanBlue
    }

}

// MARK: - UITableViewDelegate/DataSource

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! SettingsViewTableCell

        switch cell.checkBox.checkState {
        case .unchecked:
            cell.checkBox.setCheckState(.checked, animated: true)
            languages[indexPath.row].isChecked = true
        case .checked:
            cell.checkBox.setCheckState(.unchecked, animated: true)
            languages[indexPath.row].isChecked = false
        default:
            print("Dont' use this type .mixed")
        }
    }
}

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingsViewTableCell.self)
        let language = languages[indexPath.row]

        cell.languageImageView.image = UIImage(named: language.icon)
        cell.titleLabel.text = language.title

        cell.checkBox.checkState = language.isChecked ? .checked : .unchecked
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
