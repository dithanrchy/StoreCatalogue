//
//  UIViewController+Ext.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 06/01/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, action: String, handler: ((UIAlertAction) -> Void)? = nil) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: handler))

        present(alert, animated: true)
    }
}

extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
