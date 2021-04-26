//
//  ThirdNewsViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

private let ReuseIdentifier: String = "CellReuseIdentifier"

class ThirdNewsViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: MainViewControllerDelegate?
    var languageCode: String = ""
    var pageIndex: Int!
    
    private let apiManager = APIManager.shared
    private let apiKey: [String] = [Constants.SIXTH_API_KEY]
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    private var articleUrl = [String]()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewUI()
        setupTableView()
        populateNews()
    }
    
    // MARK: - Fetch & Populate Data

    private func populateNews() {
        apiManager.produceApiKey(apiKeys: apiKey)
            .map(apiManager.makeResource(selectedLanguagesCode: languageCode))
            .flatMap(URLRequest.load(resource:))
            .retry(apiKey.count + 1)
            .subscribe(onNext: { articleResponse in
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }

    private func populateImage(url: String, cell: ArticleTableViewCell) {
        let image = UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal)
        if url == "NoImage" {
            cell.articleImageView.image = image
            cell.articleImageView.contentMode = .center
        } else {
            let url = URL(string: url)
            cell.articleImageView.contentMode = .scaleAspectFill
            cell.articleImageView.kf.indicatorType = .activity
            cell.articleImageView.kf.setImage(with: url) { result in
                switch result {
                case .success:
                    print("DEBUG(populateImage): Task done")
                case .failure(let error):
                    cell.articleImageView.image = image
                    cell.articleImageView.contentMode = .center
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - ConfigureUI
    
    private func setupTableViewUI() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier)
    }
}

// MARK: - UITableViewDelegate/DataSource

extension ThirdNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let url = URL(string: self.articleUrl[indexPath.row]) else { return }
        delegate?.SafariServicesOpen(url: url)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ThirdNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.articlesVM.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier, for: indexPath) as! ArticleTableViewCell

        let articleVM = self.articleListVM.articleAt(indexPath.row)

        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)

        articleVM.publishedAt.bind { (date) in
            cell.dateLabel.text = date.utcToLocal()
        }.disposed(by: disposeBag)

        articleVM.urlToImage.bind { (url) in
            self.populateImage(url: url, cell: cell)
        }.disposed(by: disposeBag)

        articleVM.url.bind { (url) in
            self.articleUrl.append(url)
        }.disposed(by: disposeBag)

        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.lineBreakMode = .byWordWrapping

        return cell
    }
}
