//
//  DonateViewController.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import SafariServices
import StoreKit
import MessageUI
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
        configureNavigationBarUI()
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
    
    @objc private func emailButonTapped() {
        let userSystemVersion = UIDevice.current.systemVersion
        let userAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([SystemConstants.Email.emailAddress])
        mailComposeViewController.setSubject(SystemConstants.Email.subject)
        mailComposeViewController.setMessageBody(String(format: SystemConstants.Email.body, userSystemVersion, userAppVersion as! CVarArg), isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func gitHubButtonTapped() {
        guard let directUrl: URL = URL(string: SystemConstants.SNS.github) else { return }
        UIApplication.shared.open(directUrl, options: [:], completionHandler: { result in
            if !result {
                self.openSafariView(for: SystemConstants.SNS.github)
            }
        })
    }
    
    @objc private func linkedinButonTapped() {
        guard let directUrl: URL = URL(string: SystemConstants.SNS.linkedinDirect) else { return }
        UIApplication.shared.open(directUrl, options: [:], completionHandler: { result in
            if !result {
                self.openSafariView(for: SystemConstants.SNS.linkedin)
            }
        })
    }
    
    // MARK: - Helpers
    
    private func openSafariView(for url: String) {
        guard let realUrl: URL = URL(string:url) else { return }
        let safariViewController: SFSafariViewController = SFSafariViewController(url: realUrl)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
    }
    
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
    
    // MARK: - ConfigureUI
    
    private func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // Hide UINavigationBar 1px bottom line
        navigationController?.navigationBar.standardAppearance = appearance
        
        let leftItem = UIBarButtonItem(customView: UILabel.mainTitleFont(with: "Donate"))
        navigationItem.leftBarButtonItem = leftItem
    }
    
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
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func configureGesture() {
        let emailGesture = UITapGestureRecognizer(target: self, action: #selector(emailButonTapped))
        headerView.emailIconButton.addGestureRecognizer(emailGesture)
        let githubGesture = UITapGestureRecognizer(target: self, action: #selector(gitHubButtonTapped))
        headerView.githubIconButton.addGestureRecognizer(githubGesture)
        let linkedinGesture = UITapGestureRecognizer(target: self, action: #selector(linkedinButonTapped))
        headerView.linkedinIconButton.addGestureRecognizer(linkedinGesture)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension DonateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DonateTableView.self)
        cell.titleLabel.text = self.rowTitles[indexPath.row]
        cell.priceLabel.text = self.rowSubtitles[indexPath.row]
        cell.iconImageView.image = UIImage(named: "donation\(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        IAPHandler.shared.purchaseMyProduct(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

extension DonateViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension DonateViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
