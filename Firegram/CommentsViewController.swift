//
//  CommentsViewController.swift
//  Firegram
//
//  Created by Nithin Reddy Gaddam on 5/3/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var post: Post?
//    var currentUser: User?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rgb(red: 255, green: 153, blue: 153)
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navBar?.tintColor = .white
        navBar?.barStyle = UIBarStyle.black;
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.backgroundColor = .white
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        self.commentTextField.delegate = self
        
        fetchComments()
    }
    
    var comments = [Comment]()
    
    fileprivate func fetchComments() {
        
        guard let postId = self.post?.id else {return}
        let ref = FIRDatabase.database().reference().child("comments").child(postId)
        ref.observe(.childAdded , with:{ (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            
            let uid = dictionary["uid"] as? String ?? ""
            FIRDatabase.fetchUserWithUID(uid: uid
                , completion: { (user) in
                    let comment = Comment(user:user, dictionary: dictionary)
                    self.comments.append(comment)
                    self.orderCommentsAndDisplay()
            })
            
        }) {(err) in
            print("Failed to observe comments", err)
        }
    }
    
    fileprivate func orderCommentsAndDisplay(){
        self.comments.sort(by: { (c1, c2) -> Bool in
            return c1.creationDate.compare(c2.creationDate) == .orderedAscending
        })
        
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func handleSubmit() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        guard let postId = post?.id else {return}
        FIRDatabase.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment: ", err)
                return
            }
            
            print("Succefully inserted comment")
            self.commentTextField.resignFirstResponder()
            self.commentTextField.text = ""
            self.comments.removeAll()
            self.fetchComments()

            
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true;
    }
}
