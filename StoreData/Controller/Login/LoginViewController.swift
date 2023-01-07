//
//  LoginViewController.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 05/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let alertWaiting: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Mohon tunggu...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        return alert
    }()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var storeData: Store?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login Page"
    }

    func saveStoreData(name: String, address: String, longitude: String, latitude: String) {
        let newStoreData = Store(context: context)
        newStoreData.store_name = name
        newStoreData.address = address
        newStoreData.longitude = Double(longitude) ?? 0.0
        newStoreData.latitude = Double(latitude) ?? 0.0

        do {
            try context.save()
        } catch {
        }
    }

    func goToListView() {
        let displayVC: StoreListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storeListID") as! StoreListViewController
        navigationController?.pushViewController(displayVC, animated: false)
        dismiss(animated: true)
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text else { return }
        if email.isEmpty || password.isEmpty {
            showAlert(title: "Login Gagal", message: "Lengkapi semua kolom!", action: "Oke")
        }
        present(alertWaiting, animated: true)

        APIHelper.shared.login(username: email, password: password) { results in
            switch results {
            case let .success(data):
                for i in data {
                    self.saveStoreData(name: i.storeName, address: i.address, longitude: i.longitude, latitude: i.latitude)
                }
                self.alertWaiting.dismiss(animated: true) {
                    self.goToListView()
                }
            case .failure:
                self.alertWaiting.dismiss(animated: true) {
                    self.showAlert(title: "Login Gagal", message: "Periksa kembali username/password Anda", action: "Oke")
                }
            }
        }
    }
}
