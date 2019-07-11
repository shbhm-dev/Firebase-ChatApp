//
//  ViewController.swift
//  Flash Chat
//

//

import UIKit

import Firebase
class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "customMessageCell") as! CustomMessageCell
        // let msg = ["First Messsage","First Messsage","First Messsage"]
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email
        {
            cell.avatarImageView.backgroundColor = UIColor.red
            cell.messageBody.backgroundColor = UIColor.purple
        }
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.yellow
            cell.messageBody.backgroundColor = UIColor.blue

            
        }
        
        return cell
    }
    
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        //TODO: Set yourself as the delegate of the text field here:

        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped()
    {
            messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView()
    {
        
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
   
        heightConstraint.constant = 308
        
        view.layoutIfNeeded()
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        let msgDict = ["Sender": Auth.auth().currentUser?.email,"MEssage Body": messageTextfield.text]
        messageDB.childByAutoId().setValue(msgDict){
            (error,reference) in
            if error != nil
            {
            print(error)
            }
            else
            
            {
                self.sendButton.isEnabled = true
                self.messageTextfield.isEnabled = true
                
                self.messageTextfield.text = ""
            }
            
            
            
        }
        
        
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
func retrieveMessages()
{
    let messageDB = Database.database().reference().child("Messages")
    messageDB.observe(.childAdded) { (snapshot) in
        
        let snapshotValue = snapshot.value as! Dictionary<String,String>
        let textVal = snapshotValue["MEssage Body"]!
        let sender = snapshotValue["Sender"]!
        print(textVal,sender)
        let message = Message()
        message.messageBody = textVal
        message.sender = sender
        self.messageArray.append(message)
        self.configureTableView()
        self.messageTableView.reloadData()
      
    }
    
    
    }
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do{
            
            try Auth.auth().signOut()
        }
        catch
        {
            print("ERROR")
            
        }
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    


}
