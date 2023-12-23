import UIKit
import GoogleGenerativeAI

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var 输入栏: UITextField!

    var generativeModel: GenerativeModel!
    var objcChatModel: ChatModel = ChatModel()
    var MessagesFromServer = [ChatModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        


        
        
      
        
        

        generativeModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)

        输入栏.delegate = self
        
        
        
       
        
        

        navigationItem.title = "Gemini Chat"
        navigationController?.navigationBar.prefersLargeTitles = false

        setupTableView()

        // 添加点击空白处收回键盘的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    
    
    
    
  
    
    
  

    
    
    

    // 处理点击空白处的手势
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        输入栏.resignFirstResponder()
    }

    // 发送按钮点击事件
    @objc func 发送(_ sender: UIBarButtonItem?) {
        guard let userInput = 输入栏.text, !userInput.isEmpty else {
            return
        }

        // 清空输入栏
        self.输入栏.text = ""

        // 收回键盘
        self.输入栏.resignFirstResponder()

        // 调用 getMessage 方法传递参数
        self.getMessage(chatText: userInput, object: false)

        // 使用 GenerativeModel 生成聊天内容
        async {
            let generatedMessage = await ww(inputs: userInput)

            // 将生成的消息添加到数组中
            let generatedMessageModel = ChatModel(text: generatedMessage, isIncoming: true, date: Date())
            self.MessagesFromServer.append(generatedMessageModel)

            // 刷新表格显示
            DispatchQueue.main.async {
                self.tblChat.reloadData()

                // 滚动到新消息位置
                let indexPath = IndexPath(row: self.MessagesFromServer.count - 1, section: 0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func setupTableView() {
        tblChat.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellReuseIdentifier: "ChatMessageCell")

        tblChat.rowHeight = UITableView.automaticDimension
        tblChat.estimatedRowHeight = 60.0

        tblChat.delegate = self
        tblChat.dataSource = self
    }

    func getMessage(chatText: String, object: Bool) {
        let newMessages = objcChatModel.getMessages(chatText: chatText, object: object)
        MessagesFromServer += newMessages
        tblChat.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesFromServer.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell

            let message = MessagesFromServer[indexPath.row]
            cell.messageLabel.text = message.text

            // 添加长按手势
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            cell.addGestureRecognizer(longPressGesture)

            cell.timeLabel.text = formatDate(message.date)

            if message.isIncoming {
                // 接收消息的样式
                cell.leadingConstraint.isActive = true
                cell.trailingConstraint.isActive = false
                cell.bubbleBackgroundView.backgroundColor = .green
            } else {
                // 发送消息的样式
                cell.leadingConstraint.isActive = false
                cell.trailingConstraint.isActive = true
                cell.bubbleBackgroundView.backgroundColor = .blue
            }

            return cell
        }
    
    
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }

        if let cell = gestureRecognizer.view as? ChatMessageCell {
            guard let textToCopy = cell.messageLabel.text else { return }

            let pasteboard = UIPasteboard.general
            pasteboard.string = textToCopy

            // 弹出提示（可选）
            let alertController = UIAlertController(title: "复制成功", message: "消息已复制到剪贴板", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    


    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 设置时间格式
        return formatter.string(from: date)
    }

    // UITextFieldDelegate方法，用户点击 return 按钮时调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        发送(nil) // 调用发送按钮的方法
        return true
    }
}
