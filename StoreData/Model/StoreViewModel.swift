//
//  StoreViewModel.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 07/01/23.
//

import CoreData
import Foundation
import RxSwift

class StoreViewModel {
    static let shared = StoreViewModel()

    var storeSubject = PublishSubject<[Store]>()
    private var disposeBag = DisposeBag()

    private(set) var stores = [Store]()

    init() {
        storeSubject.subscribe(onNext: { [weak self] stores in
            self?.stores = stores
        }).disposed(by: disposeBag)
    }

    func updateStore(store: Store) {
        let index = stores.firstIndex(where: { $0.objectID == store.objectID })
        if let index = index {
            stores[index] = store
        }
        storeSubject.onNext(stores)
    }

    func updateStores(stores: [Store]) {
        self.stores = stores
        storeSubject.onNext(stores)
    }
}
