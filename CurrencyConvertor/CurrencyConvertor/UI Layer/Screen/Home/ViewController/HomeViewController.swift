//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import UIKit
import Combine

final class HomeViewController: UIViewController, AlertMessagesProtocol, LoaderProtocol {
    
    @IBOutlet weak private var fromCurrencyTextField: UITextField!
    @IBOutlet weak private var toCurrencyTextField: UITextField!
    @IBOutlet weak private var inputAmountTextField: UITextField!
    @IBOutlet weak private var convertedAmountTextField: UITextField!
    
    private var subscriptions: Set<AnyCancellable> = []
    private weak var textField: UITextField?
    private var textFields: [UITextField] { [fromCurrencyTextField, toCurrencyTextField, inputAmountTextField] }
    private lazy var currencyCodesPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return activityIndicatorView
    }()
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let environmentConfig = try? Environment.loadNetworkConfig() else { fatalError("Environment config not found")}
        self.viewModel = HomeViewModel(apiClient: NetworkManager(baseURL: environmentConfig.baseUrl, apiKey: environmentConfig.apiKey))

        initalSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailsViewController, let viewModel = viewModel else { return }
        detailViewController.viewModel = DetailViewModel(currencies: viewModel.getGroupedCurrencies(), converterExecuter: viewModel.conveterExecuter)
    }
    
    private func initalSetup() {
        fromCurrencyTextField.inputView = currencyCodesPicker
        toCurrencyTextField.inputView = currencyCodesPicker
        textFields.forEach { $0.addToolBar() }
        setUpSubscribers()
    }
    
    private func setUpSubscribers() {
        
        Publishers.CombineLatest3(fromCurrencyTextField.textPublisher, toCurrencyTextField.textPublisher, inputAmountTextField.textPublisher)
            .sink { [weak self] in
                guard !$0.0.isEmpty, !$0.1.isEmpty, !$0.2.isEmpty else { return }
                self?.showLoader()
                self?.viewModel?.convert(inputCurrency: $0.0, convertCurrency: $0.1, inputAmount: $0.2)
            }.store(in: &subscriptions)
        
        viewModel?.convertedCurrency
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                    case .success(let result):
                        self?.convertedAmountTextField.text = "\(result)"
                    case .failure(let error):
                        self?.showError(error)
                }
                self?.hideLoader()
            }.store(in: &subscriptions)
    }
    
    @IBAction func swapCurrencies(_ sender: UIButton) {
        let fromCurrency = fromCurrencyTextField.text
        fromCurrencyTextField.text = toCurrencyTextField.text
        toCurrencyTextField.text = fromCurrency
        guard let toCurrency = fromCurrency, !toCurrency.isEmpty,
              let fromCurrency = fromCurrencyTextField.text, !fromCurrency.isEmpty,
        let inputAmount = inputAmountTextField.text, !inputAmount.isEmpty else { return }
        showLoader()
        viewModel?.convert(inputCurrency: fromCurrency, convertCurrency: toCurrency, inputAmount: inputAmount)
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textField = textField
        if textField != inputAmountTextField {
            let selectedIndex = viewModel?.currencyCodes.firstIndex(of: textField.text ?? "") ?? 0
            currencyCodesPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
            pickerView(currencyCodesPicker, didSelectRow: selectedIndex, inComponent: 0)
        } else {
            textField.text = nil
        }
        return true
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel?.currencyCodes.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.currencyCodes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = viewModel?.currencyCodes[row]
    }
}
