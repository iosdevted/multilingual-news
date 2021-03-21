//
//  EnglishNewsViewController.swift
//  one-article
//
//  Created by Ted on 2021/03/21.
//

import UIKit

class EnglishNewsViewController: UIViewController {
    
    //MARK: - Properties
    
    var pageIndex: Int!
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.tintColor = .black
        label.text = "English View Controller"
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
