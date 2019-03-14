//
//  SocketIOManager.swift
//  Koku
//
//  Created by HoangVu on 3/12/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "http://localhost:4000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
//    var friendList: [FriendModel] = []
//    var messageList: [String:[ChatMessage]] = [:]
//    var nickName: String = "unknown"
//    var selectedFriend: FriendModel = FriendModel()
    
    override init() {
        super.init()
         socket = manager.defaultSocket
        socket.on("updateListTransaction") { ( id, ack) -> Void in
           

            //Send notification for friendlist update
            NotificationCenter.default.post(name: Notification.Name("reloadActivityList"), object: nil)

        }
//
//        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
//            let userID: String = dataArray[0] as! String
//            let message: String = dataArray[1] as! String
//            let newMessage: ChatMessage = ChatMessage(isRemoteMessage: true, message: message)
//
//            if self.messageList[userID] == nil {
//                self.messageList[userID] = []
//            }
//            self.messageList[userID]?.append(newMessage)
//            NotificationCenter.default.post(name: Notification.Name("newChatMessage"), object: nil)
//        }
    }
    
    
    func establishConnection(_ onConnectedEvent:@escaping ()->Void) {
        socket.connect()
        socket.on("connect") {data, ack in
            onConnectedEvent()
        }
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
    func connectToServerWithNickname(nickname: String) {
        socket.emit("updateNickname", nickname)
    }
    
    func sendMessage(message: String, toUserID userID: String) {
        socket.emit("newChatMessage", userID, message)
    }
    
    
    
    
    
    
}

