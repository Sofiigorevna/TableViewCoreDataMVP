//
//  DetailViewController.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import UIKit

class DetailViewController: UIViewController, UserViewProtocol {
    
    private var isEdit = Bool()
    
    var presenter: DetailPresenterType?
    
    // MARK: - Outlets
    
    private lazy var icon: UIImageView = {
        let image = UIImage(systemName: "person.fill")
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var viewContainer: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 120
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textFieldName,textFieldAge,textFieldGender])
        stack.axis = .vertical
        stack.alignment = .center
        stack.setCustomSpacing(2, after: textFieldName)
        stack.setCustomSpacing(2, after: textFieldAge)
        stack.setCustomSpacing(2, after: textFieldGender)
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var textFieldName: UITextField = {
        let textField = UITextField()
        textField.text = presenter?.user?.name
        textField.autocapitalizationType = .words
        textField.keyboardType = .default
        textField.textAlignment = .natural
        textField.tintColor = .lightGray
        textField.setLeftIcon(UIImage(systemName: "person")!)
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var textFieldAge: UITextField = {
        let textField = UITextField()
        textField.text = presenter?.user?.dateOfBirth

        textField.textAlignment = .left
        textField.setLeftIcon(UIImage(systemName: "calendar")!)
        textField.tintColor = .lightGray
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var textFieldGender: UITextField = {
        let textField = UITextField()
        textField.text = presenter?.user?.gender

        textField.setLeftIcon(UIImage(systemName: "person.2.circle")!)
        textField.textAlignment = .natural
        textField.tintColor = .lightGray
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Lifecycle
    
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
        lazy var buttonEdit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonPressed))
        navigationItem.rightBarButtonItem = buttonEdit
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupHierarhy() {
        view.addSubview(viewContainer)
        viewContainer.addSubview(icon)
        view.addSubview(textFieldStack)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            viewContainer.widthAnchor.constraint(equalToConstant: 250),
            viewContainer.heightAnchor.constraint(equalToConstant: 250),
            
            icon.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            icon.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 3),
            icon.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 3),
            
            textFieldStack.topAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 50),
            textFieldStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 11),
            textFieldStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            textFieldStack.heightAnchor.constraint(equalToConstant: 180),
            
            textFieldName.widthAnchor.constraint(equalToConstant: 355),
            textFieldAge.widthAnchor.constraint(equalToConstant: 355),
            textFieldGender.widthAnchor.constraint(equalToConstant: 355),
        ])
    }
    
    // MARK: - Actions

    private func saveData() {
        if let user = presenter?.user {
            presenter?.updateUser(user: user ,
                                  photoImage: "person.fill",
                                  name: textFieldName.text ?? " ",
                                  dateOfBirth: textFieldAge.text ?? "",
                                  gender: textFieldGender.text ?? "")
        }
    }
    
    @objc private func editButtonPressed() {

        isEdit.toggle()
        if isEdit {
            editButtonItem.title = "Save"
            
            textFieldName.isUserInteractionEnabled = true
            textFieldName.borderStyle = .bezel
            
            textFieldAge.isUserInteractionEnabled = true
            textFieldAge.borderStyle = .bezel

            textFieldGender.isUserInteractionEnabled = true
            textFieldGender.borderStyle = .bezel


        } else {
            editButtonItem.title = "Edit"

            icon.isUserInteractionEnabled = false
            textFieldName.isUserInteractionEnabled = false
            textFieldName.borderStyle = .none

            textFieldAge.isUserInteractionEnabled = false
            textFieldAge.borderStyle = .none

            textFieldGender.isUserInteractionEnabled = false
            textFieldGender.borderStyle = .none

            guard let personName = textFieldName.text,
                  !personName.isEmpty else {
                let alert = UIAlertController(title: "Sorry", message: "Please enter the name in textfield", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert,animated: true)
                return
            }
           saveData()
        }
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editButtonPressed()
        return true
    }
}

extension DetailViewController {
    func set(presenter: DetailPresenter){
        self.presenter = presenter
    }
}
