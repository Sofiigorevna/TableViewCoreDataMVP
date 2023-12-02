//
//  Alert.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 02.12.2023.
//

import UIKit
class ShowAlert: NSObject {
static let shared = ShowAlert()

    func alert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }

    private override init() {}
}
