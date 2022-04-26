//
//  OrdersiOSTests.swift
//  OrdersiOSTests
//
//  Created by Hashem Abounajmi on 24/04/2022.
//

import XCTest
import Orders
@testable import OrdersiOS

class OrdersSnapshotTests: XCTestCase {
    
    func test_emptyOrdersList() {
        let sut = makeSUT()
        
        sut.display(emptyOrders())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_ORDERS_dark")
    }
    
    func test_downloadingOrders() {
        let sut = makeSUT()
        
        sut.displayLoading()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "DOWNLOADING_ORDERS_dark")
    }
    
    func test_ordersWithContent() {
        let sut = makeSUT()
        sut.display(ordersWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "ORDERS_WITH_CONTENT_dark")
    }
    
    // MARK: - Helpers

    private func makeSUT() -> OrdersViewController {
        let bundle = Bundle(for: OrdersViewController.self)
        let storyboard = UIStoryboard(name: "Orders", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! OrdersViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyOrders() -> [OrderItemCellController] {
        return []
    }
    
    private func ordersWithContent() -> [OrderItemCellController] {
        return [
            OrderItemCellController(
                viewModel:
                    OrderItemViewModel(
                        model: OrderItem(
                            id: "1",
                            currency:"BTC",
                            amount: 12.1,
                            orderType: .buy,
                            orderStatus: .executed,
                            createdAt: Date(timeIntervalSince1970: 1604432909)
                        )
                    )
            ),
            OrderItemCellController(
                viewModel:
                    OrderItemViewModel(
                        model: OrderItem(
                            id: "2",
                            currency:"XRP",
                            amount: 595.1,
                            orderType: .withdraw,
                            orderStatus: .processing,
                            createdAt: Date(timeIntervalSince1970: 1580515537)
                        )
                    )
            )
        ]

    }
    
    private func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(snapshotURL.lastPathComponent)
            try? snapshotData?.write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
    
    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        return data
    }
}

private extension OrdersViewController {
    func display(_ cellControllers: [OrderItemCellController]) {
        tableModel = cellControllers
    }
    
    func displayLoading() {
        downloadView.beginRefreshing()
    }
    
    func displayDownloadFailed() {
        downloadView.endRefreshing()
    }
}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone8(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: CGSize(width: 375, height: 667),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .available),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: .medium),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 2),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style)
            ]))
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone8(style: .light)

    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }

    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }

    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
