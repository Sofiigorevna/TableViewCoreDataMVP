//
//  ViewController.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 18
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "    Print your name here"
        textField.keyboardType = .default
        textField.textAlignment = .center
        textField.backgroundColor = .tertiarySystemFill
        textField.layer.cornerRadius = 14
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Press", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //  MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupHierarhy()
        setupLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Users"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let backButton = UIImage(systemName: "arrow.left")
        
        navigationController?.navigationBar.backIndicatorImage = backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        navigationController?.navigationBar.backItem?.title = ""
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
    }
    
    
    private func setupView() {
        view.backgroundColor = .systemGray6
    }
    
    private func setupHierarhy() {
        view.addSubview(textFieldStack)
        textFieldStack.addArrangedSubview(textField)
        textFieldStack.addArrangedSubview(button)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textFieldStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            textFieldStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            textFieldStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -595),
            textFieldStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 11),
            
            textField.widthAnchor.constraint(equalToConstant: 355),
            button.widthAnchor.constraint(equalToConstant: 355),
            
            tableView.heightAnchor.constraint(equalToConstant: 500),
            tableView.topAnchor.constraint(equalTo: textFieldStack.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 11),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            
        ])
    }
    
    // MARK: - Actions
    
    @objc private func buttonAction() {}
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
