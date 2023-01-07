//
//  LoadViewController.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 06/01/23.
//

import UIKit

class LoadViewController: UIViewController {
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var storeList: [Store] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocalData()
    }

    func getLocalData() {
        do {
            storeList = try context.fetch(Store.fetchRequest())
            if storeList.isEmpty {
                let displayVC: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginID") as! LoginViewController
                navigationController?.setViewControllers([displayVC], animated: false)
                dismiss(animated: true)
            } else {
                goToListView()
            }
        } catch {
        }
    }

    func goToListView() {
        let displayVC: StoreListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storeListID") as! StoreListViewController
        displayVC.storeList = storeList
        navigationController?.pushViewController(displayVC, animated: false)
        dismiss(animated: true)
    }
}
