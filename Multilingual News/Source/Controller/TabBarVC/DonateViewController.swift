//
//  DonateViewController.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import SafariServices
import StoreKit
import UIKit


class DonateViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rowTitles: [String] = ["Energy bar", "A Cup of Coffee", "Burger and Fries"]
    private let rowSubtitles: [String] = ["$0.99", "$4.99", "$9.99"]
    private let headerView = DonateHeaderView()
    private let tableView = UITableView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureGesture()
        fetchAvailableProducts()
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Selectors
    
    @objc private func gitHubButtonTapped() {
        openSafariViewOf(url: "https://github.com/iosdevted")
    }
    
    @objc private func linkedinButonTapped() {
        openSafariViewOf(url: "https://www.linkedin.com/in/sunggweon-hyeong")
    }
    
    
    // MARK: - Helpers
    
    private func fetchAvailableProducts() {
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = { [weak self] type in
            guard let self = self else { return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    private func openSafariViewOf(url: String) {
        guard let url: URL = URL(string: url) else { return }
        let safariViewController: SFSafariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            headerView,
            tableView
        ].forEach {
            view.addSubview($0)
        }
        
        headerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(260)
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        self.tableView.register(cellType: DonateTableView.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    // MARK: ConfigureGesture
    
    private func configureGesture() {
        let githubGesture = UITapGestureRecognizer(target: self, action: #selector(gitHubButtonTapped))
        headerView.githubIconImageView.addGestureRecognizer(githubGesture)
        let linkedinGesture = UITapGestureRecognizer(target: self, action: #selector(linkedinButonTapped))
        headerView.linkedinIconImageView.addGestureRecognizer(linkedinGesture)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension DonateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 150.0
    //    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return """
        CHOOSE DONATION PLAN
        Don't worry. All services of GITGET is free. You don't have to pay to use the app.
        """
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DonateTableView.self)
        cell.donationTitleLabel.text = self.rowTitles[indexPath.row]
        cell.donationPriceLabel.text = self.rowSubtitles[indexPath.row]
        cell.donationImageView.image = UIImage(named: "donation\(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         IAPHandler.shared.purchaseMyProduct(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
