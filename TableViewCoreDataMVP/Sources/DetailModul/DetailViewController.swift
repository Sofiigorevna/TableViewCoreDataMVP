//
//  DetailViewController.swift
//  TableViewCoreDataMVP
//
//  Created by 1234 on 26.11.2023.
//

import UIKit

class DetailViewController: UIViewController, UserViewProtocol {
    
    private var isEdit = Bool()
    private var avatar: Data? = nil
    
    private let datePicker = UIDatePicker()
    private var pickerView = UIPickerView()
    
    private let genders = ["Male",
                           "Female",
                           "Not human"]
    
    var presenter: DetailPresenterType?
    
    // MARK: - Outlets
    
    private lazy var icon: UIImageView = {
        var imageView = UIImageView()
                if let avatarData = presenter?.user?.avatar {
                     imageView = UIImageView(image: UIImage(data: avatarData))
                } else {
                     imageView = UIImageView(image: UIImage(systemName: "person.fill"))

                }
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var buttonOpenGallery: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Gallery", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(openGalleryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var viewContainer: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 120
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
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
        let dateOfBirthMax = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        datePicker.minimumDate = dateOfBirthMinimum
        datePicker.maximumDate = dateOfBirthMax
        
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
        view.addSubview(buttonOpenGallery)
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

            icon.widthAnchor.constraint(equalToConstant: 250),
            icon.heightAnchor.constraint(equalToConstant: 250),
            
            buttonOpenGallery.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            buttonOpenGallery.bottomAnchor.constraint(equalTo: textFieldStack.topAnchor, constant: -10),


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
    
    @objc
    private func openGalleryTapped() {
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .savedPhotosAlbum
        present(imagepicker, animated: true)
        
    }
    
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
                                  avatar: avatar,
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
            
            buttonOpenGallery.isHidden = false

            textFieldName.isUserInteractionEnabled = true
            textFieldName.borderStyle = .bezel
            
            textFieldAge.isUserInteractionEnabled = true
            textFieldAge.borderStyle = .bezel
            
            textFieldGender.isUserInteractionEnabled = true
            textFieldGender.borderStyle = .bezel
            
            
        } else {
            editButton.configuration?.title =  "Edit"
            editButton.configuration?.baseBackgroundColor = .clear
            
            buttonOpenGallery.isHidden = true

            textFieldName.isUserInteractionEnabled = false
            textFieldName.borderStyle = .none
            
            textFieldAge.isUserInteractionEnabled = false
            textFieldAge.borderStyle = .none
            
            textFieldGender.isUserInteractionEnabled = false
            textFieldGender.borderStyle = .none
            
            guard let personName = textFieldName.text,
                  !personName.isEmpty else {
                ShowAlert.shared.alert(view: self, title: "Sorry", message: "Please enter the name in textfield")
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

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            icon.contentMode = .scaleAspectFit
            icon.image = image
            
            DispatchQueue.main.async {
                self.avatar = image.pngData()
            }
            
        } else if let image = info[.originalImage] as? UIImage {
            icon.image = image
            
            DispatchQueue.main.async {
                self.avatar = image.pngData()
            }
        }
        dismiss(animated: true)
        
        
    }
    
}
