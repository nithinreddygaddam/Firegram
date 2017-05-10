//
//  ChatInputContainerView.swift
//  NewMessenger
//
//  Created by Nithin Reddy Gaddam on 5/3/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    var chatLogController: ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    let sendButton = UIButton(type: .system)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    
        addSubview(uploadImageView)
        
        // Constraint anchors: x, y, width, height
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(sendButton)
        
        // Constraint anchors: x, y, width, height
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(self.inputTextField)
        
        // Constraint anchors: x, y, width, height
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorLineView)
        
        // Constraint anchors: x, y, width, height
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
