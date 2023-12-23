//
//  ChatModel.swift
//  Chat
//
//  Created by Nirav on 14/06/19.
//  Copyright © 2019 Nirav. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    var text: String
    var isIncoming: Bool
    var date: Date
    
    init(text: String, isIncoming: Bool, date: Date) {
        self.text = text
        self.isIncoming = isIncoming
        self.date = date
        super.init()
    }

    override init() {
        self.text = ""
        self.isIncoming = false
        self.date = Date()
        super.init()
    }

    func getMessages(chatText: String, object: Bool) -> [ChatModel] {
        let chat1: ChatModel = ChatModel(text: chatText, isIncoming: object, date: Date())
        
        var messagesFromServer: [ChatModel] = [ChatModel]()
        messagesFromServer.append(chat1)
      
        return messagesFromServer
    }
}
