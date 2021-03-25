//
//  FirstNewsViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
//import SkeletonView

private let ReuseIdentifier: String = "CellReuseIdentifier"

class FirstNewsViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: MainViewControllerDelegate?
    private var apiKey: [String] = ["33e4f0e56b324ab7a51f2d8e9fef4204"]
    var languageCode: String = ""
    
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    var pageIndex: Int!
    private var articleUrl = [String]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier)

        populateNews()
    }
    
    //MARK: - Helpers
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func populateNews() {
        
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=\(languageCode)&apiKey=\(apiKey[0])")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate/DataSource

extension FirstNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.articleUrl[indexPath.row]) else { return }
        delegate?.SafariServicesOpen(url: url)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FirstNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.articlesVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        
        let articleVM = self.articleListVM.articleAt(indexPath.row)

        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)

//        cell.titleLabel.hideSkeleton()
        
        articleVM.publishedAt.bind { (date) in
            cell.dateLabel.text = date.utcToLocal()
//            cell.dateLabel.hideSkeleton()
        }.disposed(by: disposeBag)
        
        articleVM.urlToImage.bind { (url) in
            if url == "NoImage" {
                let image = UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal)
                cell.articleImageView.image = image
                cell.articleImageView.contentMode = .center
            } else {
                let url = URL(string: url)
                cell.articleImageView.contentMode = .scaleAspectFill
                cell.articleImageView.kf.indicatorType = .activity
                cell.articleImageView.kf.setImage(with: url)
            }
        }.disposed(by: disposeBag)
        
        articleVM.url.bind { (url) in
            self.articleUrl.append(url)
        }.disposed(by: disposeBag)
        
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        return cell
    }
}
