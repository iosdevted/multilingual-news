//
//  MainViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import SafariServices

protocol MainViewControllerDelegate: class {
    func SafariServicesOpen(url: URL)
}

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let realmManager = RealmManager.shared
    private let apiManager = APIManager.shared
    private let disposeBag = DisposeBag()
    private var currentIndex: Int = 0
    private var pageController: UIPageViewController!
    private let apiKey: [String] = [Constants.FIRST_API_KEY, Constants.SECOND_API_KEY]
    private var articleUrl: String = ""
    private var selectedLanguages: [RealmLanguage] = [RealmLanguage]()
    private var allLanguages: [RealmLanguage ] = [RealmLanguage]() {
        didSet {
            checkIfFirstRun(by: allLanguages) ? addDefaultSetting() : print("DEBUG(checkIfFirstRun): Not First Run")
        }
    }
    
    private var articleVM: ArticleViewModel! {
        didSet {
            populateTopNews()
        }
    }
    
    private var tabsView = TabsView()
    private var topHeaderContainerView: TopHeaderView = {
        let view = TopHeaderView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.systemGray4.withAlphaComponent(0.7).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 7
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealmData()
        configureNavigationBarUI()
        configureUI()
        configureGesture()
        setupTabs(with: selectedLanguages)
        setupPageViewController()
        loadTopNews()
    }
    
    
    // MARK: - Selectors
    
    @objc func topHeaderContainerViewTapped() {
        guard let url = URL(string: articleUrl) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @objc func rightBarButtonTapped() {
        let languages: [Language] = changeToLanguageType(from: allLanguages)
        let settingViewController = SettingViewController(languages: languages)

        let nav = UINavigationController(rootViewController: settingViewController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func checkIfFirstRun(by languages: [RealmLanguage]) -> Bool {
        return languages.count == 12 ? false : true
    }
    
    private func changeToLanguageType(from realmLanguages: [RealmLanguage]) -> [Language] {
        var languages: [Language] = [Language]()
        realmLanguages.forEach {
            languages.append(Language(with: $0))
        }
        return languages
    }
    
    // MARK: - Realm
    
    private func fetchRealmData() {
        let predicate = NSPredicate(format: "isChecked == true")
        let fetchRealmData = realmManager.retrieveAllDataForObject(RealmLanguage.self)
            .map { $0 as! RealmLanguage }
        let fetchSelectedData = realmManager.retrieveDataForCertainObject(RealmLanguage.self, with: predicate)
            .map { $0 as! RealmLanguage }
        selectedLanguages = fetchSelectedData
        allLanguages = fetchRealmData
    }
    
    private func addDefaultSetting() {
        realmManager.add(with: DefaultValues.languages)
        fetchRealmData()
    }
    
    private func deleteRealmData() {
        realmManager.deleteAllDataForObject(RealmLanguage.self)
    }
    
    // MARK: - Fetch API & Populate Data
    
    private func loadTopNews() {
        apiManager.produceApiKey(apiKeys: apiKey)
            .map(apiManager.makeResource(selectedLanguagesCode: selectedLanguages[0].code))
            .flatMap(URLRequest.load(resource:))
            .retry(apiKey.count + 1)
            .subscribe(onNext: { articleResponse in
                let topArticle = articleResponse.articles.first
                self.articleVM = ArticleViewModel(topArticle!)
            })
            .disposed(by: disposeBag)
    }
    
    private func populateTopNews() {
        DispatchQueue.main.async {
            self.articleVM.title.asDriver(onErrorJustReturn: "")
                .drive(self.topHeaderContainerView.titleLabel.rx.text)
                .disposed(by: self.disposeBag)
            
            self.articleVM.publishedAt.bind { (date) in
                self.topHeaderContainerView.dateLabel.text = date.utcToLocalWithDate()
            }.disposed(by: self.disposeBag)
            
            self.articleVM.urlToImage.bind { (url) in
                if url == "NoImage" {
                    let image = UIImage(named: "NoImage")?.withRenderingMode(.alwaysOriginal)
                    self.topHeaderContainerView.topHeaderImageView.image = image
                    self.topHeaderContainerView.topHeaderImageView.contentMode = .center
                } else {
                    let url = URL(string: url)
                    self.topHeaderContainerView.topHeaderImageView.kf.indicatorType = .activity
                    self.topHeaderContainerView.topHeaderImageView.kf.setImage(with: url)
                }
            }.disposed(by: self.disposeBag)
            
            self.articleVM.url.bind { (url) in
                self.articleUrl = url
            }.disposed(by: self.disposeBag)
        }
    }
    
    // MARK: - ConfigureUI
    
    private func configureNavigationBarUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // Hide UINavigationBar 1px bottom line
        appearance.largeTitleTextAttributes = [.foregroundColor: Constants.customUIColor.oceanBlue, .font: Constants.largeTitleFont ?? .systemFont(ofSize: 20)]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Main News"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        var rightBarImage = UIImage(systemName: "globe")?.withTintColor(Constants.customUIColor.oceanBlue)
        rightBarImage = rightBarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            topHeaderContainerView,
            tabsView
        ].forEach {
            view.addSubview($0)
        }
        
        topHeaderContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.35)
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        tabsView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            
            make.top.equalTo(topHeaderContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
    
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(topHeaderContainerViewTapped))
        topHeaderContainerView.addGestureRecognizer(gesture)
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
            let contentVC = FirstNewsViewController()
            contentVC.languageCode = selectedLanguages[0].code
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else if index == 1 {
            let contentVC = SecondNewsViewController()
            contentVC.languageCode = selectedLanguages[1].code
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else if index == 2 {
            let contentVC = ThirdNewsViewController()
            contentVC.languageCode = selectedLanguages[2].code
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else {
            let contentVC = FourthNewsViewController()
            contentVC.languageCode = selectedLanguages[3].code
            contentVC.pageIndex = index
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
