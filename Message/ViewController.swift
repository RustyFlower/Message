//
//  ViewController.swift
//  Message
//
//  Created by Ren Matsushita on 2018/01/13.
//  Copyright © 2018年 Ren Matsushita. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ViewController: JSQMessagesViewController {
    
    var messages: [JSQMessage]!
    var saveDatas = save()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = saveDatas.saveData.object(forKey: "userid") as! String!
        self.senderDisplayName = saveDatas.saveData.object(forKey: "username") as! String!
        setupFirebase()
        
        self.messages = [JSQMessage(senderId: "user1", displayName: "Ren", text: "first message")]
    }
    
    func setupFirebase() {
        let rootRef = Database.database().reference()
        rootRef.queryLimited(toLast: 100).observe(DataEventType.childAdded, with: { (snapshot) in
            let textSnapshotValue = snapshot.value as! NSDictionary
            let text = textSnapshotValue["text"] as! String

            let senderSnapshotValue = snapshot.value as! NSDictionary
            let sender = senderSnapshotValue["from"] as! String

            let nameSnapshotValue = snapshot.value as! NSDictionary
            let name = nameSnapshotValue["name"] as! String

            let message = JSQMessage(senderId: sender, displayName: name, text: text)
            self.messages?.append(message!)
            self.finishReceivingMessage()
        })
    }
    
    //メッセージの送信
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.finishSendingMessage(animated: true)
        sendTextToDb(text: text)
    }
    
    func sendTextToDb(text: String) {
        //データベースへの送信（後述）
        let rootRef = Database.database().reference()
        let post = ["from": senderId,
                    "name": senderDisplayName,
                    "text": text]
        let postRef = rootRef.childByAutoId()
        postRef.setValue(post)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == self.senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.blue)
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.black)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: messages[indexPath.row].senderDisplayName, backgroundColor: UIColor.lightGray, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 10), diameter: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
