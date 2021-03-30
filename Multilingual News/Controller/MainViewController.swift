//
//  MainViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import SafariServices

protocol MainViewControllerDelegate: class {
    func SafariServicesOpen(url: URL)
}

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    private let persistenceManager = PersistenceManager.shared
    private let apiManager = APIManager.shared
    private let refreshManager = RefreshManager.shared
    private let request: NSFetchRequest<Languages> = Languages.fetchRequest()
    private let disposeBag = DisposeBag()
    private var currentIndex: Int = 0
    private var pageController: UIPageViewController!
    private let apiKey: [String] = ["daed73a210b94589a977658bcb2f5747", "7eed556281e548be8f5f82946b3ed5d3"]
    private var articleUrl: String = ""
    private var selectedLanguagesName: [String] = []
    private var selectedLanguagesCode: [String] = []
    
    var coreDataLanguages: [Languages] = [] {
        didSet {
            selectedLanguagesName = []
            selectedLanguagesCode = []
            coreDataLanguages.forEach { (language) in
                if language.isChecked {
                    selectedLanguagesName.append(language.title!)
                    selectedLanguagesCode.append(language.code!)
                }
            }
            print(selectedLanguagesCode)
        }
    }
    
    private var articleVM: ArticleViewModel! {
        didSet {
            populateTopNews()
        }
    }
    
    private lazy var tabsView: TabsView = {
        let view = TabsView()
        return view
    }()
    
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
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreData()
        configureNavigationBarUI()
        configureUI()
        configureGesture()
        setupTabs()
        setupPageViewController()
        loadTopNews()
    }
    
    //MARK: - Selectors
    
    @objc func topHeaderContainerViewTapped() {
        guard let url = URL(string: articleUrl) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @objc func rightBarButtonTapped() {
        let settingViewController = SettingViewController(languages: coreDataLanguages)
        
        let nav = UINavigationController(rootViewController: settingViewController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func reloadData() {
        topHeaderContainerView.setNeedsDisplay()
        loadTopNews()
        setupTabs()
    }
    
    private func fetchCoreData() {
        coreDataLanguages = persistenceManager.fetch(request: request)
        
        if coreDataLanguages.isEmpty {
            saveInitialData()
            coreDataLanguages = persistenceManager.fetch(request: request)
        } else {
            print("Not First Run")
        }
    }
    
    private func loadTopNews() {
        apiManager.produceApiKey(apiKeys: apiKey)
            .map(apiManager.makeResource(selectedLanguagesCode: selectedLanguagesCode[0]))
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
    
    private func saveInitialData() {
        let language1 = Setting(isChecked: true, title: "English", code: "us", icon: "united-states-of-america")
        let language2 = Setting(isChecked: true, title: "French", code: "fr", icon: "france")
        let language3 = Setting(isChecked: true, title: "Japanese", code: "jp", icon: "japan")
        let language4 = Setting(isChecked: true, title: "Korean", code: "kr", icon: "south-korea")
        let language5 = Setting(isChecked: false, title: "Chinese", code: "cn", icon: "china")
        let language6 = Setting(isChecked: false, title: "Russian", code: "ru", icon: "russia")
        let language7 = Setting(isChecked: false, title: "German", code: "de", icon: "germany")
        let language8 = Setting(isChecked: false, title: "Italian", code: "it", icon: "italy")
        let language9 = Setting(isChecked: false, title: "Portuguese", code: "pt", icon: "portugal")
        let language10 = Setting(isChecked: false, title: "Dutch", code: "nl", icon: "netherlands")
        let language11 = Setting(isChecked: false, title: "Swedish", code: "se", icon: "sweden")
        let language12 = Setting(isChecked: false, title: "Norwegian", code: "no", icon: "norway")

        persistenceManager.insertLanguage(language: language1)
        persistenceManager.insertLanguage(language: language2)
        persistenceManager.insertLanguage(language: language3)
        persistenceManager.insertLanguage(language: language4)
        persistenceManager.insertLanguage(language: language5)
        persistenceManager.insertLanguage(language: language6)
        persistenceManager.insertLanguage(language: language7)
        persistenceManager.insertLanguage(language: language8)
        persistenceManager.insertLanguage(language: language9)
        persistenceManager.insertLanguage(language: language10)
        persistenceManager.insertLanguage(language: language11)
        persistenceManager.insertLanguage(language: language12)
    }
    
    //MARK: - ConfigureUI
    
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(topHeaderContainerViewTapped))
        topHeaderContainerView.addGestureRecognizer(gesture)
    }
    
    private func configureNavigationBarUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // Hide UINavigationBar 1px bottom line
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1), .font: UIFont(name: "RedHatDisplay-Bold", size: 35) ?? .systemFont(ofSize: 20)]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Main News"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        var rightBarImage = UIImage(systemName: "globe")?.withTintColor(UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1))
        rightBarImage = rightBarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, style:.plain, target: self, action:  #selector(rightBarButtonTapped))
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(topHeaderContainerView)
        
        topHeaderContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.35)
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }

        view.addSubview(tabsView)
        
        tabsView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            
            make.top.equalTo(topHeaderContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
    
    //MARK: - ConfigureTabs
    
    private func setupTabs() {
        tabsView.tabs = [
            Tab(icon: nil, title: selectedLanguagesName[0]),
            Tab(icon: nil, title: selectedLanguagesName[1]),
            Tab(icon: nil, title: selectedLanguagesName[2]),
            Tab(icon: nil, title: selectedLanguagesName[3])
        ]
        
        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        tabsView.tabMode = .fixed
        
        tabsView.titleColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
        tabsView.iconColor = .black
        tabsView.indicatorColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
        
        tabsView.titleFont = UIFont(name: "RedHatDisplay-Regular", size: 14)!
        //tabsView.titleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        tabsView.collectionView.backgroundColor = .white
        
        tabsView.delegate = self
        
        tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        
    }
    
    private func showViewController(_ index: Int) -> UIViewController? {
        if (self.tabsView.tabs.count == 0) || (index >= self.tabsView.tabs.count) {
            return nil
        }
        
        currentIndex = index
        
        if index == 0 {
            let contentVC = FirstNewsViewController()
            contentVC.languageCode = selectedLanguagesCode[0]
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else if index == 1 {
            let contentVC = SecondNewsViewController()
            contentVC.languageCode = selectedLanguagesCode[1]
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else if index == 2 {
            let contentVC = ThirdNewsViewController()
            contentVC.languageCode = selectedLanguagesCode[2]
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else {
            let contentVC = FourthNewsViewController()
            contentVC.languageCode = selectedLanguagesCode[3]
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

//MARK: - TabsDelegate

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

//MARK: - UIPageViewControllerDataSource

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

//MARK: - MainViewControllerDelegate

extension MainViewController: MainViewControllerDelegate {
    func SafariServicesOpen(url: URL) {
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

