//
//  StoreDetailViewController.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 05/01/23.
//

import UIKit

class StoreDetailViewController: UIViewController {
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeDateVisited: UILabel!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var storeData: Store?
    let viewModel = StoreViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Verifikasi Store"

        guard let storeData = storeData else { return }
        storeName.text = storeData.store_name
        storeAddress.text = storeData.address
        if let dateVisited = storeData.dateVisited {
            storeDateVisited.text = dateVisited.formatTodMMMyyyy()
        } else {
            storeDateVisited.text = "-"
        }
    }

    func visit(isTrue: Bool) {
        guard let storeData = storeData else { return }
        storeData.isVisited = isTrue
        storeData.dateVisited = isTrue ? Date() : nil

        do {
            try context.save()
            storeDateVisited.text = isTrue ? storeData.dateVisited?.formatTodMMMyyyy() : "-"
            viewModel.updateStore(store: storeData)
        } catch {
        }
    }

    @IBAction func noVisitPressed(_ sender: Any) {
        visit(isTrue: false)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func visitPressed(_ sender: Any) {
        visit(isTrue: true)
        navigationController?.popViewController(animated: true)
    }
}
