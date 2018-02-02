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
    
    var messages: [JSQMessage]?
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFirebase()
        setupChatUI()
        
        self.messages = []
    }
    
    func setupFirebase() {
        let rootRef = Database.database().reference()
        
        rootRef.queryLimited(toLast: 100).observe(DataEventType.childAdded, with: { (snapshot) in
            let text = snapshot.value!["text"] as! String
            let sender = snapshot.value!["from"] as! String
            let name = snapshot.value!["name"] as! String
            let message = JSQMessage(senderId: sender,
                                     displayName: name, text: text)
            self.messages?.append(message)
            self.finishReceivingMessage()
        })
    }
    
    func setupChatUI() {
        inputToolbar!.contentView!.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        
        self.senderId = "user1"
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "icon_default")!, diameter: 64)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "icon_default")!, diameter: 64)
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleGreen())
    }
    
    //メッセージの送信
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.finishSendingMessage(animated: true)
        sendTextToDb(text: text)
    }
    
    func sendTextToDb(text: String) {
        //データベースへの送信（後述）
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages?[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.messages?.count)!
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
