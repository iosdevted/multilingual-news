//
//  SettingViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/22.
//

import UIKit
import CoreData
import SnapKit

private let ReuseIdentifier: String = "CellReuseIdentifier"

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    
    private var languages =
        [Setting(icon: "united-states-of-america", title: "English", isChecked: true),
         Setting(icon: "france", title: "French", isChecked: true),
         Setting(icon: "japan", title: "Japanese", isChecked: true),
         Setting(icon: "south-korea", title: "Korean", isChecked: true)]
    
    
    
    private var coreDataLanguages: [NSManagedObject] = []
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureNavigationBarUI()
        fetchCoreData()
    }
    
    //MARK: - Helpers
    
    func save(isChecked: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Languages", in: managedContext)!
        let language = NSManagedObject(entity: entity, insertInto: managedContext)
        language.setValue(isChecked, forKeyPath: "isChecked")
        
        do {
            try managedContext.save()
            coreDataLanguages.append(language)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Languages")
        
        do {
            coreDataLanguages = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        tableView.isEditing = true
        //Allow Selection During Editing, unless click doesn't work
        tableView.allowsSelectionDuringEditing = true
        
        self.tableView.register(SettingsViewTableCell.self, forCellReuseIdentifier: ReuseIdentifier)
    }
    
    private func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1), .font: UIFont(name: "MajorMonoDisplay-Regular", size: 25) ?? .systemFont(ofSize: 20)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1), .font: UIFont(name: "MajorMonoDisplay-Regular", size: 25) ?? .systemFont(ofSize: 20)]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "manage languages"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
            languages[indexPath.row].isChecked = false
        case .checked:
            cell.checkBox.setCheckState(.unchecked, animated: true)
            languages[indexPath.row].isChecked = true
        default:
            print("Dont' use this type .mixed")
        }
        
        //cell.checkBox.toggleCheckState()
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
        
        //Model SettingOptions
        //        guard let option = settingOptions(rawValue: indexPath.row) else { return SettingsViewTableCell() }
        //        cell.languageImageView.image = option.image
        //        cell.titleLabel.text = option.description
        
        //Model Setting
        cell.languageImageView.image = UIImage(named: languages[indexPath.row].icon)
        cell.titleLabel.text = languages[indexPath.row].title

        (languages[indexPath.row].isChecked) ? (cell.checkBox.checkState = .checked) : (cell.checkBox.checkState = .unchecked)
        
        //Core Data
//        let language = coreDataLanguages[indexPath.row]
//        cell.languageImageView.image = UIImage(named: language.value(forKeyPath: "icon") as! String)
//        cell.titleLabel.text = language.value(forKeyPath: "title") as? String
//        (language.value(forKeyPath: "isChecked") as! Bool) ? (cell.checkBox.checkState = .checked) : (cell.checkBox.checkState = .unchecked)
        
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
