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
//import WebKit


protocol MainViewControllerDelegate: class {
    func SafariServicesOpen(url: URL)
}

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    private var articleVM: ArticleViewModel! {
        didSet {
            populateTopNews()
        }
    }
    
    private let disposeBag = DisposeBag()
    private var currentIndex: Int = 0
    private var pageController: UIPageViewController!
    private var articleUrl: String = ""
    //private let webView = WKWebView(frame: UIScreen.main.bounds)
    
    private lazy var tabsView: TabsView = {
        let view = TabsView()
        return view
    }()
    
    private var topHeaderContainerView: TopHeaderView = {
        let view = TopHeaderView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10.0
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //webView.navigationDelegate = self
        configureNavigationBarUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        present(settingViewController, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func loadTopNews() {
        
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=daed73a210b94589a977658bcb2f5747")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                
                let topArticle = articleResponse.articles.first
                self.articleVM = ArticleViewModel(topArticle!)
                    
            }).disposed(by: disposeBag)
    }
    
    private func populateTopNews() {
        DispatchQueue.main.async {
            self.articleVM.title.asDriver(onErrorJustReturn: "")
                .drive(self.topHeaderContainerView.titleLabel.rx.text)
                .disposed(by: self.disposeBag)
            
            self.articleVM.publishedAt.bind { (date) in
                self.topHeaderContainerView.dateLabel.text = date.toDateFormat()
            }.disposed(by: self.disposeBag)
            
            self.articleVM.urlToImage.bind { (url) in
                let url = URL(string: url)
                self.topHeaderContainerView.topHeaderImageView.kf.indicatorType = .activity
                self.topHeaderContainerView.topHeaderImageView.kf.setImage(with: url)
            }.disposed(by: self.disposeBag)
            
            self.articleVM.url.bind { (url) in
                self.articleUrl = url
            }.disposed(by: self.disposeBag)
            
           //self.hideTopNewsAnimation()
        }
    }
    
//    private func hideTopNewsAnimation() {
//        topHeaderContainerView.dateLabel.hideSkeleton()
//        topHeaderContainerView.titleLabel.hideSkeleton()
//    }
    
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(topHeaderContainerViewTapped))
        topHeaderContainerView.addGestureRecognizer(gesture)
    }
    
    private func configureNavigationBarUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // Hide UINavigationBar 1px bottom line
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Main News"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        var leftBarImage = UIImage(systemName: "arrowshape.turn.up.backward")?.withTintColor(UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1))
        var rightBarImage = UIImage(systemName: "globe")?.withTintColor(UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1))

        leftBarImage = leftBarImage?.withRenderingMode(.alwaysOriginal)
        rightBarImage = rightBarImage?.withRenderingMode(.alwaysOriginal)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarImage, style:.plain, target: self, action:  #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, style:.plain, target: self, action:  #selector(rightBarButtonTapped))

    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(topHeaderContainerView)
        
        topHeaderContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview().multipliedBy(0.35)
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        view.addSubview(tabsView)
        
        tabsView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            
            make.top.equalTo(topHeaderContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
    
    private func setupTabs() {
        tabsView.tabs = [
            Tab(icon: nil, title: "English"),
            Tab(icon: nil, title: "French"),
            Tab(icon: nil, title: "Japanese"),
            Tab(icon: nil, title: "Korean")
        ]
        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        tabsView.tabMode = .fixed
        
        tabsView.titleColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
        tabsView.iconColor = .black
        tabsView.indicatorColor = .black
        tabsView.titleFont = UIFont.systemFont(ofSize: 15, weight: .light)
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
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else if index == 1 {
            let contentVC = SecondNewsViewController()
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else if index == 2 {
            let contentVC = ThirdNewsViewController()
            contentVC.pageIndex = index
            contentVC.delegate = self
            return contentVC
        } else {
            let contentVC = FourthNewsViewController()
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
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: self.tabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
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
            
//        let urlRequest = URLRequest(url: url)
//        webView.load(urlRequest)
//        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        view.addSubview(webView)
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

//MARK: - WKNavigationDelegate

//extension ViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if navigationAction.navigationType == .linkActivated  {
//            if let url = navigationAction.request.url,
//                let host = url.host, !host.hasPrefix("www.google.com"),
//                UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//                print(url)
//                print("Redirected to browser. No need to open it locally")
//                decisionHandler(.cancel)
//            } else {
//                print("Open it locally")
//                decisionHandler(.allow)
//            }
//        } else {
//            print("not a user click")
//            decisionHandler(.allow)
//        }
//    }
//
//}
