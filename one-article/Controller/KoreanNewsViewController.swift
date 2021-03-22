//
//  KoreanNewsViewController.swift
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

class KoreanNewsViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: ViewControllerDelegate?
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    var pageIndex: Int!
    private var articleUrl = [String]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier)

        self.populateNews()
    }
    
    //MARK: - Helpers
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func populateNews() {
        
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=daed73a210b94589a977658bcb2f5747")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func dateFormat(date: String) -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date2 = formatter1.date(from: date) {
            let formatter2 = DateFormatter()
            formatter2.timeStyle = .short
            formatter2.locale = Locale(identifier: "kr_KR")

            let dateString = formatter2.string(from: date2)
            return dateString
        }
        
        return ""
    }
    
}

//MARK: - UITableViewDelegate/DataSource

extension KoreanNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let url = URL(string: self.articleUrl[indexPath.row]) {
//            UIApplication.shared.open(url)
//        }

        guard let url = URL(string: self.articleUrl[indexPath.row]) else { return }
        delegate?.SafariServicesOpen(url: url)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension KoreanNewsViewController: UITableViewDataSource {
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
        
//        articleVM.publishedAt.asDriver(onErrorJustReturn: "")
//            .drive(cell.dateLabel.rx.text)
//            .disposed(by: disposeBag)
        
        articleVM.publishedAt.bind { (date) in
            let date = self.dateFormat(date: date)
            cell.dateLabel.text = date
//            cell.dateLabel.hideSkeleton()
        }.disposed(by: disposeBag)
        
        articleVM.urlToImage.bind { (url) in
            let url = URL(string: url)
            cell.articleImageView.kf.setImage(with: url)
        }.disposed(by: disposeBag)
        
        articleVM.url.bind { (url) in
            self.articleUrl.append(url)
        }.disposed(by: disposeBag)
        
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.lineBreakMode = .byWordWrapping
        
        return cell
    }
}
