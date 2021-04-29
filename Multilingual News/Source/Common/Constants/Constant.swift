//
//  Constant.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import Foundation

struct SystemConstants {
    struct Email {
        static let emailAddress = "devted@protonmail.com"
        static let subject = "[Multilingual News] Feedback for Multilingual News"
        static let body = """

        Thanks for your feedback!
        Kindly write your advise here. :)


        =====
        iOS Version: %@
        App Version: %@
        =====
        """
    }
    
    struct SNS {
        static let github = "https://github.com/iosdevted"
        static let linkedin = "https://www.linkedin.com/in/sunggweon-hyeong/"
        static let linkedinDirect = "linkedin://profile/sunggweon-hyeong"
    }
}
