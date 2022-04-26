//
//  SceneDelegate.swift
//  CopperApp
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import UIKit
import CoreData
import Orders
import OrdersiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    private lazy var store: OrdersStore = {
        try! CoreDataOrdersStore(storeURL: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("orders-store.sqlite"))
    }()
    
    private lazy var localOrdersLoader: LocalOrdersLoader = {
        LocalOrdersLoader(store: store)
    }()
    
    convenience init(httpClient: HTTPClient, store: OrdersStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        configureWindow()
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://assessments.stage.copper.co/ios/orders")!
        let remoteOrdersLoader = RemoteOrdersLoader(url: remoteURL, client: httpClient)
        
        let navigationController = UINavigationController(rootViewController: OrdersUIComposer.ordersComposedWith(ordersLoader: OrdersLoaderWithFallbackComposite(primary: localOrdersLoader, fallback: OrdersLoaderCacheDecorator(decoratee: remoteOrdersLoader, cache: localOrdersLoader))))
        navigationController.overrideUserInterfaceStyle = .dark
        window?.rootViewController = navigationController
    }
}

