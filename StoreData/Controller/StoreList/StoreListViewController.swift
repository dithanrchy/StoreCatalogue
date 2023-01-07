//
//  StoreListViewController.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 05/01/23.
//

import CoreData
import CoreLocation
import GoogleMaps
import RxSwift
import UIKit

class StoreListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var storeTable: UITableView!
    @IBOutlet weak var mapView: UIView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var storeList: [Store] {
        get {
            return viewModel.stores
        }
        set {
            viewModel.updateStores(stores: newValue)
            storeTable?.reloadData()
        }
    }

    let viewModel = StoreViewModel.shared
    let disposeBag = DisposeBag()

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let currentLocation = currentLocation else { return }
            fetchMapPoint(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            storeTable.reloadData()
        }
    }

//    var radius: Double = 0.0
    var circ, circlePoint: GMSCircle?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Store"

        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogoutButton))
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
        navigationItem.hidesBackButton = true

        DispatchQueue.global(qos: .utility).async {
            if self.storeList.count == 0 {
                self.fetchStore()
            }
        }

        dateTime.text = "List kunjungan \(Date().formatTodMMMyyyy())"

        storeTable.delegate = self
        storeTable.dataSource = self

        initAndStartUpdatingLocation()

        viewModel.storeSubject.subscribe(onNext: { [weak self] _ in

            self?.storeTable.reloadData()
        }).disposed(by: disposeBag)
    }

//    func setRadius(radius: Float){
//        self.radius = Double(radius)
//    }

    func fetchMapPoint(latitude: Double, longitude: Double) {
        let zoom: Float = 10.0
        let radius: Double = Double(100000 / zoom)

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        self.mapView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.mapView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor).isActive = true

        mapView.delegate = self

        let circleCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circ = GMSCircle(position: circleCenter, radius: radius)
        circ?.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
        circ?.strokeWidth = 0
        circ?.map = mapView

        circlePoint = GMSCircle(position: circleCenter, radius: radius / 10)
        circlePoint?.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        circlePoint?.strokeColor = UIColor.white
        circlePoint?.strokeWidth = 2
        circlePoint?.map = mapView

        for i in 0 ..< storeList.count {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: storeList[i].latitude, longitude: storeList[i].longitude)
            marker.title = storeList[i].store_name
            marker.snippet = storeList[i].address
            marker.map = mapView
        }
    }

    func fetchStore() {
        do {
            storeList = try context.fetch(Store.fetchRequest())
            storeTable.reloadData()
        } catch {
        }
    }

    func deleteAllData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error")
        }
    }

    @objc func didTapLogoutButton() {
        deleteAllData()
        let rootViewController: LoadViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadID") as! LoadViewController
        navigationController?.setViewControllers([rootViewController], animated: true)
    }
}

extension StoreListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeViewCell") as! StoreListTableViewCell

        let store = storeList[indexPath.row]

        let radius = currentLocation != nil ? haversineDistance(lat1: currentLocation!.latitude, lon1: currentLocation!.longitude, lat2: store.latitude, lon2: store.longitude) : nil
        cell.configure(storeName: store.store_name ?? "", storeRadius: radius, isVisited: store.isVisited)
        return cell
    }

    func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let lat1Rad = lat1.toRadians()
        let lon1Rad = lon1.toRadians()
        let lat2Rad = lat2.toRadians()
        let lon2Rad = lon2.toRadians()

        let dLat = lat2Rad - lat1Rad
        let dLon = lon2Rad - lon1Rad

        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        let R = 6371e3 // Earth's radius in meters
        return R * c
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayVC: StoreDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storeDetailID") as! StoreDetailViewController
        displayVC.storeData = storeList[indexPath.row]
        navigationController?.pushViewController(displayVC, animated: true)
        dismiss(animated: true)
    }
}

extension StoreListViewController: CLLocationManagerDelegate {
    func initAndStartUpdatingLocation() {
        DispatchQueue.global(qos: .utility).async {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        print("locations = \(locValue)")
        guard locValue.latitude != currentLocation?.latitude,
              locValue.longitude != currentLocation?.longitude
        else { return }
        currentLocation = locValue
    }
}

extension StoreListViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let radius: Double = Double(100000 / position.zoom)

        circ?.radius = radius
        circlePoint?.radius = radius / 10
    }
}
