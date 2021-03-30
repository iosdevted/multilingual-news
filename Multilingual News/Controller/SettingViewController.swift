//
//  SettingViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/22.
//

import UIKit
import CoreData
import SnapKit
import KRProgressHUD

private let ReuseIdentifier: String = "CellReuseIdentifier"

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainViewController = MainViewController()
    private let tableView = UITableView()
    private var persistenceManager = PersistenceManager.shared
    private let request: NSFetchRequest<Languages> = Languages.fetchRequest()
    private var contextLanguages = [Languages(context: PersistenceManager.shared.context)]
    private var coreDataLanguages: [Languages]
    
    // MARK: - Life Cycle
    
    init(languages: [Languages]) {
        self.coreDataLanguages = languages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        configureNavigationBarUI()
    }
    
    //MARK: - Selectors
    
    @objc func backButtonTapped() {
        
        if isfourlanguages() {
            contextLanguages = coreDataLanguages
            persistenceManager.saveContext()
            
            dismiss(animated: true) {
                self.mainViewController.coreDataLanguages = self.coreDataLanguages
                DispatchQueue.main.async {
                    self.mainViewController.reloadData()
                }
            }
        } else {
            showErrorMessage()
        }
    }
    
    //MARK: - Helpers
    
    private func isfourlanguages() -> Bool {
        var count = 0
        coreDataLanguages.forEach { (language) in
            if language.isChecked == true {
                count += 1
            }
        }

        return (count == 4) ? true : false
    }
    
    private func showErrorMessage() {
        KRProgressHUD.appearance().style = .custom(background: .white, text: .black, icon: .black)
        KRProgressHUD.showInfo(withMessage: "You should select 4 languages")
        
    }
    
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
        //tableView.isEditing = true
        //Allow Selection During Editing, unless click doesn't work
        tableView.allowsSelectionDuringEditing = true
        
        self.tableView.register(SettingsViewTableCell.self, forCellReuseIdentifier: ReuseIdentifier)
    }
    
    private func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1), .font: UIFont(name: "RedHatDisplay-Bold", size: 30) ?? .systemFont(ofSize: 20)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1), .font: UIFont(name: "RedHatDisplay-Bold", size: 20) ?? .systemFont(ofSize: 20)]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Manage Languages"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        var leftBarImage = UIImage(systemName: "arrowshape.turn.up.backward")?.withTintColor(UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1))
        leftBarImage = leftBarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarImage, style:.plain, target: self, action:  #selector(backButtonTapped))
    }
    
    
}

//MARK: - UITableViewDelegate/DataSource

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! SettingsViewTableCell

        switch cell.checkBox.checkState {
        case .unchecked:
            cell.checkBox.setCheckState(.checked, animated: true)
            coreDataLanguages[indexPath.row].isChecked = true
        case .checked:
            cell.checkBox.setCheckState(.unchecked, animated: true)
            coreDataLanguages[indexPath.row].isChecked = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! SettingsViewTableCell
        let language = coreDataLanguages[indexPath.row]
        
        if language.title != nil {
            cell.languageImageView.image = UIImage(named: language.icon!)
            cell.titleLabel.text = language.title!
            
            (language.value(forKeyPath: "isChecked") as! Bool) ? (cell.checkBox.checkState = .checked) : (cell.checkBox.checkState = .unchecked)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedObject = self.coreDataLanguages[sourceIndexPath.row]
//        coreDataLanguages.remove(at: sourceIndexPath.row)
//        coreDataLanguages.insert(movedObject, at: destinationIndexPath.row)
//
//    }
}
