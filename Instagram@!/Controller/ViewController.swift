//
//  ViewController.swift
//  Instagram@!
//
//  Created by eslam dweeb on 9/26/18.
//  Copyright © 2018 eslam dweeb. All rights reserved.
//


import UIKit
import Firebase

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let addPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        let photoImage = UIImage(named: "addPhoto")
        button.setImage(photoImage, for: .normal)
        button.addTarget(self, action: #selector(handelPlusPhoto), for: .touchUpInside)
        return button
    }()
    @objc func handelPlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            addPhotoBtn.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            addPhotoBtn.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        addPhotoBtn.layer.cornerRadius = addPhotoBtn.frame.width/2
        addPhotoBtn.layer.masksToBounds = true
        addPhotoBtn.layer.borderWidth = 3
        addPhotoBtn.layer.borderColor = UIColor.rgb(red: 17, green: 154, blue: 273).cgColor
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.layer.cornerRadius = 5
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.contentVerticalAlignment = .center
        tf.addTarget(self, action: #selector(handelTextFields), for: .editingChanged)
        return tf
    }()
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.layer.cornerRadius = 5
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.contentVerticalAlignment = .center
        tf.addTarget(self, action: #selector(handelTextFields), for: .editingChanged)

        return tf
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.layer.cornerRadius = 5
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.contentVerticalAlignment = .center
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handelTextFields), for: .editingChanged)

        return tf
    }()
    
    @objc func handelTextFields() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0
            > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(handelSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handelSignUp() {
        guard let email = emailTextField.text, email.count > 0 else{return}
        guard let userName = usernameTextField.text, userName.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else{return
            
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("faild to Sign Up", err)
                return
            }
            print("Successfully create user", user?.uid ?? "")
            guard let uid = user?.uid else{return}
            let userNameDic = ["userName": userName]
            let valueDic = [uid: userNameDic]
            Database.database().reference().child("user").updateChildValues(valueDic, withCompletionBlock: { (err, ref) in
                if let err = err {
                   print("Faild to save user info to db", err)
                    return
                }
                print("Successfully saved user info to db")
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoBtnView()
        setupStackView()
    }
    
    fileprivate func setupPhotoBtnView() {
        view.addSubview(addPhotoBtn)
        addPhotoBtn.anchor(top: view.topAnchor, left:nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, hight: 140)
        addPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUpBtn])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: addPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, hight: 200)
    }
}

