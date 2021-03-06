//
//  MainViewController.swift
//  Multilingual News
//
//  Created by Ted on 2021/03/21.
//

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import SafariServices
import UIKit

protocol MainViewControllerDelegate: class {
    func SafariServicesOpen(url: URL)
}

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let realmManager = RealmManager.shared
    private let apiManager = APIManager.shared
    private let disposeBag = DisposeBag()
    private let apiKey: [String] = [API_KEY.FIRST, API_KEY.SECOND]
    private var selectedRealmLanguages: [RealmLanguage] = [RealmLanguage]()
    private var allRealmLanguages: [RealmLanguage] = [RealmLanguage]()
    private var currentIndex: Int = 0
    private var pageController: UIPageViewController!
    private var scrollView = UIScrollView()
    private var headerView = MainHeaderView()
    private var tabsView = TabsView()
    private var articleUrl: String?
    private var articleVM: ArticleViewModel!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealmData()
        isFirstRun(allRealmLanguages) ? addDefaultLanguagesToRealm(with: Setting.languages) : print("DEBUG(isFirstRun): Not First Run")
        configureNavigationBarUI()
        configureUI()
        configureGesture()
        setupTabs(with: selectedRealmLanguages)
        setupPageViewController()
        loadTopNews()
    }
    
    
    // MARK: - Selectors
    
    @objc func topHeaderViewTapped() {
        guard let articleUrl = articleUrl, let url = URL(string: articleUrl) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @objc func rightBarButtonTapped() {
        let languages: [Language] = allRealmLanguages.changeToLanguageType()
        let settingViewController = SettingViewController(languages: languages)

        let nav = UINavigationController(rootViewController: settingViewController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func isFirstRun(_ languages: [RealmLanguage]) -> Bool {
        return languages.count == 12 ? false : true
    }
    
    // MARK: - Realm Helpers

    private func fetchRealmData() {
        let predicate = NSPredicate(format: "isChecked == true")
        let fetchRealmData = realmManager.retrieveAllDataForObject(RealmLanguage.self)
            .map { $0 as! RealmLanguage }
        let fetchSelectedRealmData = realmManager.retrievePredicatedDataForObject(RealmLanguage.self, with: predicate)
            .map { $0 as! RealmLanguage }

        selectedRealmLanguages = fetchSelectedRealmData
        allRealmLanguages = fetchRealmData
    }

    private func deleteRealmData() {
        realmManager.deleteAllDataForObject(RealmLanguage.self)
    }

    private func saveRealmData(with languages: [Language]) {
        languages.forEach {
            let realmLanguage = RealmLanguage()
            realmLanguage.update(with: $0)
            realmManager.add(realmLanguage)
        }
    }

    private func addDefaultLanguagesToRealm(with languages: [Language]) {
        saveRealmData(with: languages)
        fetchRealmData()
    }
    
    // MARK: - Fetch API
    
    private func loadTopNews() {
        apiManager.produceApiKey(apiKeys: apiKey)
            .map(apiManager.makeResource(selectedLanguagesCode: selectedRealmLanguages[0].code))
            .flatMap(URLRequest.load(resource:))
            .retry(apiKey.count + 1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { articleResponse in
                let topArticle = articleResponse.articles.first
                self.articleVM = ArticleViewModel(topArticle!)
                self.populateHeaderViewNews()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - ConfigureUI & ConfigureGesture
    
    private func populateHeaderViewNews() {
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(headerView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.publishedAt.asDriver(onErrorJustReturn: "")
            .map { $0.toLocalTimeWithDate() }
            .drive(headerView.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.urlToImage.bind {
            self.populateHeaderViewImage(with: $0)
        }.disposed(by: disposeBag)
        
        articleVM.url.bind {
            self.articleUrl = $0
        }.disposed(by: disposeBag)
    }
    
    private func populateHeaderViewImage(with url: String) {
        if url == "NoImage" {
            populateNoImage(in: headerView)
        } else {
            guard let url = URL(string: url) else { return }
            populateImage(with: url, in: headerView)
        }
    }
    
    private func populateNoImage(in headerView: MainHeaderView) {
        let image = UIImage(named: "NoImage_100px")?.withRenderingMode(.alwaysOriginal)
        headerView.imageView.image = image
        headerView.imageView.contentMode = .center
    }
    
    private func populateImage(with url: URL, in headerView: MainHeaderView) {
        headerView.imageView.kf.indicatorType = .activity
        headerView.imageView.kf.setImage(with: url) { result in
            switch result {
            case .success:
                print("DEBUG(populateImage): Task done")
            case .failure(let error):
                self.populateNoImage(in: headerView)
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // Hide UINavigationBar 1px bottom line
        navigationController?.navigationBar.standardAppearance = appearance

        let leftItem = UIBarButtonItem(customView: UILabel.mainTitleFont(with: "Maru News."))
        navigationItem.leftBarButtonItem = leftItem

        var rightBarImage = UIImage(systemName: "globe")?.withTintColor(UIColor.warmBlack)
        rightBarImage = rightBarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            headerView,
            tabsView
        ].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.33)
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        }
        
        tabsView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        }
    }
    
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(topHeaderViewTapped))
        headerView.addGestureRecognizer(gesture)
    }
    
    // MARK: - ConfigureTabs
    
    private func setupTabs(with languages: [RealmLanguage]) {
        tabsView.tabs = [
            Tab(icon: nil, title: languages[0].title),
            Tab(icon: nil, title: languages[1].title),
            Tab(icon: nil, title: languages[2].title),
            Tab(icon: nil, title: languages[3].title)
        ]
        
        tabsView.collectionView.reloadData()
        tabsView.collectionView.backgroundColor = .white
        tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        tabsView.delegate = self
    }
    
    private func showViewController(_ index: Int) -> UIViewController? {
        if (self.tabsView.tabs.count == 0) || (index >= self.tabsView.tabs.count) {
            return nil
        }
        
        currentIndex = index
        
        if index == 0 {
            let contentVC = FirstNewsViewController(language: selectedRealmLanguages[0].code, pageIndex: index)
            contentVC.delegate = self
            return contentVC
        } else if index == 1 {
            let contentVC = SecondNewsViewController(language: selectedRealmLanguages[1].code, pageIndex: index)
            contentVC.delegate = self
            return contentVC
        } else if index == 2 {
            let contentVC = ThirdNewsViewController(language: selectedRealmLanguages[2].code, pageIndex: index)
            contentVC.delegate = self
            return contentVC
        } else {
            let contentVC = FourthNewsViewController(language: selectedRealmLanguages[3].code, pageIndex: index)
            contentVC.delegate = self
            return contentVC
        }
    }
    
    private func setupPageViewController() {
        // PageViewController
        self.pageController = TabsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        
        // Set PageViewController Delegate & DataSource
        pageController.delegate = self
        pageController.dataSource = self
        
        // Set the selected ViewController in the PageViewController when the app starts
        pageController.setViewControllers([showViewController(0)!], direction: .forward, animated: true, completion: nil)
        
        // PageViewController Constraints
        pageController.view.snp.makeConstraints { (make) -> Void in
            make.centerX.width.equalToSuperview()
            
            make.top.equalTo(tabsView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
        self.pageController.didMove(toParent: self)
    }
}

// MARK: - TabsDelegate

extension MainViewController: TabsDelegate {
    func tabsViewDidSelectItemAt(position: Int) {
        // Check if the selected tab cell position is the same with the current position in pageController, if not, then go forward or backward
        if position != currentIndex {
            if position > currentIndex {
                self.pageController.setViewControllers([showViewController(position)!], direction: .forward, animated: true, completion: nil)
                
            } else {
                self.pageController.setViewControllers([showViewController(position)!], direction: .reverse, animated: true, completion: nil)
            }
            tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // return ViewController when go forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        // Don't do anything when viewpager reach the number of tabs
        if index == tabsView.tabs.count {
            return nil
        } else {
            index += 1
            return self.showViewController(index)
        }
    }
    
    // return ViewController when go backward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        
        if index == 0 {
            return nil
        } else {
            index -= 1
            return self.showViewController(index)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                
                index = getVCPageIndex(vc)
                
                tabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the TabsView to be centered when you are scrolling using .scrollable
                tabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        switch viewController {
        case is FirstNewsViewController:
            let vc = viewController as! FirstNewsViewController
            return vc.pageIndex
        case is SecondNewsViewController:
            let vc = viewController as! SecondNewsViewController
            return vc.pageIndex
        case is ThirdNewsViewController:
            let vc = viewController as! ThirdNewsViewController
            return vc.pageIndex
        default:
            let vc = viewController as! FourthNewsViewController
            return vc.pageIndex
        }
    }
}

// MARK: - MainViewControllerDelegate

extension MainViewController: MainViewControllerDelegate {
    func SafariServicesOpen(url: URL) {
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}
