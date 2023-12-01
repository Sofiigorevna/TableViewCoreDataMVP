//
//  DetailViewController.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import UIKit

class DetailViewController: UIViewController, UserViewProtocol {
    
    private var isEdit = Bool()
    private let datePicker = UIDatePicker()
    private var pickerView = UIPickerView()
    
    private let genders = ["Male",
                           "Female",
                           "Not human"]
    
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
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "person")
        if let image = image{
            textField.setLeftIcon(image)
        }
        
        return textField
    }()
    
    private lazy var textFieldAge: UITextField = {
        let textField = UITextField()
        textField.text = presenter?.user?.dateOfBirth
        textField.textAlignment = .left
        textField.tintColor = .lightGray
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "calendar")
        if let image = image{
            textField.setLeftIcon(image)
        }
        
        return textField
    }()
    
    private lazy var textFieldGender: UITextField = {
        let textField = UITextField()
        textField.text = presenter?.user?.gender
        textField.textAlignment = .natural
        textField.tintColor = .lightGray
        textField.keyboardType = .default
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "person.2.circle")
        if let image = image{
            textField.setLeftIcon(image)
        }
        
        return textField
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.masksToBounds = true
        button.tintColor = .darkGray
        var config = UIButton.Configuration.borderedTinted()
        config.baseBackgroundColor = .clear
        config.title = "Edit"
        config.titleAlignment = .center
        button.configuration = config
        button.addTarget(self, action: #selector(editButtonPressed),
                         for: .allEvents)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupHierarhy()
        setupLayout()
        setupDatePickerDateOfBirth()
        setupPickerGender()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        lazy var buttonEdit = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem = buttonEdit
    }
    
    private func setupDatePickerDateOfBirth() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        textFieldAge.inputView = datePicker
        textFieldAge.inputAccessoryView = toolBar

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace,doneButton], animated: true)
        
        let dateOfBirthMinimum = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.minimumDate = dateOfBirthMinimum
    }
    
    private func setupPickerGender() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textFieldGender.inputView = pickerView
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
            viewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            viewContainer.widthAnchor.constraint(equalToConstant: 250),
            viewContainer.heightAnchor.constraint(equalToConstant: 250),
            
            icon.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
            icon.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 3),
            icon.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 3),
            
            textFieldStack.topAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 60),
            textFieldStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 11),
            textFieldStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            textFieldStack.heightAnchor.constraint(equalToConstant: 180),
            
            textFieldName.widthAnchor.constraint(equalToConstant: 355),
            textFieldAge.widthAnchor.constraint(equalToConstant: 355),
            textFieldGender.widthAnchor.constraint(equalToConstant: 355),
            
            editButton.widthAnchor.constraint(equalToConstant: 70),
            editButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    func getDateFromPicker() {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy"
        textFieldAge.text = formater.string(from: datePicker.date)
    }
   
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
            editButton.configuration?.title = "Save"
            editButton.configuration?.baseBackgroundColor = .magenta
            
            
            textFieldName.isUserInteractionEnabled = true
            textFieldName.borderStyle = .bezel
            
            textFieldAge.isUserInteractionEnabled = true
            textFieldAge.borderStyle = .bezel
            
            textFieldGender.isUserInteractionEnabled = true
            textFieldGender.borderStyle = .bezel
            
            
        } else {
            editButton.configuration?.title =  "Edit"
            editButton.configuration?.baseBackgroundColor = .clear
            
            
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

extension DetailViewController: UIPickerViewDataSource,  UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldGender.text = genders[row]
        textFieldGender.resignFirstResponder()
    }
}
