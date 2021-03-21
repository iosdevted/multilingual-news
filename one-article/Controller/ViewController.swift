//
//  ViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var tabsView: TabsView = {
        let view = TabsView()
        return view
    }()
    
    private var currentIndex: Int = 0
    private var pageController: UIPageViewController!
    
    private var topHeaderContainerView: TopHeaderContainerView = {
        let view = TopHeaderContainerView()
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
        configureNavigationBarUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupTabs()
        setupPageViewController()
    }
    
    
    //MARK: - Selectors
    
    @objc func rightBarButtonTapped() {
        
    }
    
    //MARK: - Helpers
    
    private func configureNavigationBarUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // Hide UINavigationBar 1px bottom line
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)] // Should change another color
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Breaking News"
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        var image = UIImage(systemName: "globe")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action:  #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 70/255, green: 75/255, blue: 114/255, alpha: 1/1)
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
            let contentVC = EnglishNewsViewController()
            contentVC.pageIndex = index
            return contentVC
        } else if index == 1 {
            let contentVC = FrenchNewsViewController()
            contentVC.pageIndex = index
            return contentVC
        } else if index == 2 {
            let contentVC = JapaneseNewsViewController()
            contentVC.pageIndex = index
            return contentVC
        } else {
            let contentVC = KoreanNewsViewController()
            contentVC.pageIndex = index
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

extension ViewController: TabsDelegate {
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

extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
        case is EnglishNewsViewController:
            let vc = viewController as! EnglishNewsViewController
            return vc.pageIndex
        case is FrenchNewsViewController:
            let vc = viewController as! FrenchNewsViewController
            return vc.pageIndex
        case is JapaneseNewsViewController:
            let vc = viewController as! JapaneseNewsViewController
            return vc.pageIndex
        default:
            let vc = viewController as! KoreanNewsViewController
            return vc.pageIndex
        }
    }
}
