//
//  EnglishNewsViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let ReuseIdentifier: String = "CellReuseIdentifier"

class EnglishNewsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    var pageIndex: Int!
    

    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier)

    }
    
    //MARK: - Helpers
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
}

//MARK: - UITableViewDelegate/DataSource

extension EnglishNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EnglishNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        
//        let articleVM = self.articleListVM.articleAt(indexPath.row)
//
//        articleVM.title.asDriver(onErrorJustReturn: "")
//            .drive(cell.titleLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        articleVM.description.asDriver(onErrorJustReturn: "")
//            .drive(cell.descriptionLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        cell.descriptionLabel.numberOfLines = 0
//        cell.descriptionLabel.lineBreakMode = .byWordWrapping
//        cell.titleLabel.numberOfLines = 0
//        cell.titleLabel.lineBreakMode = .byWordWrapping
        return cell
    }
}

