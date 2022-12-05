//
//  DetailsViewController.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.//

import UIKit
import Combine
import SwiftUI

final class DetailsViewController: UIViewController, LoaderProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var hostingView: UIView!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return activityIndicatorView
    }()
    
    var viewModel: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSetup()
    }
    
    private func initalSetup() {
        tableView.reloadData()
        addGraphView()
        viewModel?.onFetchTopCurrencies.sink { [weak self] in
            self?.tableView?.reloadData()
            self?.hideLoader()
        }.store(in: &subscriptions)
    }
    
    private func addGraphView() {
        let hostingViewController = UIHostingController(rootView: ChartView(dataSource: viewModel?.getChartDataSource() ?? []))
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingViewController)
        hostingView.addSubview(hostingViewController.view)
        hostingViewController.didMove(toParent: self)
        hostingViewController.view.leadingAnchor.constraint(equalTo: hostingView.leadingAnchor).isActive = true
        hostingViewController.view.topAnchor.constraint(equalTo: hostingView.topAnchor).isActive = true
        hostingView.bottomAnchor.constraint(equalTo: hostingViewController.view.bottomAnchor).isActive = true
        hostingView.trailingAnchor.constraint(equalTo: hostingViewController.view.trailingAnchor).isActive = true
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.dataSourceKeys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.convertedCurrencies[viewModel.dataSourceKeys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.dataSourceKeys[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)"),
                let viewModel = viewModel else { return UITableViewCell() }
        
        let element = viewModel.convertedCurrencies[viewModel.dataSourceKeys[indexPath.section]]?[indexPath.row]
        cell.textLabel?.text = element?.model.description
        cell.detailTextLabel?.text = element?.topConvertedCurrenciesModel.enumerated().map { "\n\($0 + 1). " + $1.description }.joined(separator: "\n")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel,
                let model = viewModel.convertedCurrencies[viewModel.dataSourceKeys[indexPath.section]]?[indexPath.row],
                    model.topConvertedCurrenciesModel.isEmpty else { return }
        showLoader()
        viewModel.fetchTopCountryCurrencies(for: model)
    }
}
