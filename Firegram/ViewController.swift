//
//  ViewController.swift
//  Firegram
//
//  Created by Nithin Reddy Gaddam on 4/16/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)

        return button
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    func handlePhotoButton () {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated:true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        else if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && (emailTextField.text?.contains("@"))! && (emailTextField.text?.contains("."))! && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 5
        
        if (isFormValid){
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17,green: 154,blue: 237)
        }
        else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        }
        
    }
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .blue
        button.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    func handleSignUp() {
        
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
    
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let err = error {
                print("Failed to create user: ", err)
                return
            }
            else{
                print("Successfully created user: ", user?.uid ?? "")
                
                guard let image = self.plusPhotoButton.imageView?.image else {return}
                
                guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
                
                let fileName = NSUUID().uuidString
                
                FIRStorage.storage().reference().child("profile_images").child(fileName).put(uploadData, metadata: nil, completion: {(metadata, err) in
                    
                    if let err = err{
                        print("Failed to upload profile image:" , err)
                        return
                    }
                    
                    guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
                    
                    print("Succefulle Uploaded profile image")
                    print(profileImageUrl)
                    
                    guard let uid = user?.uid else { return }
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values =  [uid: dictionaryValues]
                    
                    FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: {(err, ref) in
                        
                        if let err = err{
                            print("Failed to save user info to database: ", err)
                            return
                        }
                        else{
                            print("Succefully saved user info to db")
                        }
                    })
                })
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
    }

    fileprivate func setupInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
