import UIKit
import GoogleGenerativeAI

class ViewController: UIViewController {
    
    
    @IBOutlet weak var 输出: UITextView!
    
    @IBOutlet weak var 输入栏: UITextField!
    
    
    // 在 ViewController 类中添加一个属性来保存 GenerativeModel 实例
    var generativeModel: GenerativeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化 generativeModel
        generativeModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
            
        // 设置输入栏的代理
        输入栏.delegate = self
    }
    
    // 发送按钮的 IBAction
    @IBAction func 发送(_ sender: UIButton) {
        guard let inputs = 输入栏.text, !inputs.isEmpty else {
            // 处理输入为空的情况
            return
        }
        
        // 调用 ww 函数，并将结果显示在 UITextView 中
        ww(inputs: inputs)
        
        // 清除输入栏内容
                输入栏.text = ""
    }
    }
    

// 扩展 ViewController，实现 UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    // 处理 Return 键
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 收回键盘并调用 ww 函数
        textField.resignFirstResponder()
        guard let inputs = textField.text, !inputs.isEmpty else {
            // 处理输入为空的情况
            return true
        }
        ww(inputs: inputs)
        
        // 清除输入栏内容
                textField.text = ""
        
        return true
    }
}

// 在 ViewController 中添加 ww 函数
extension ViewController {
    func ww(inputs: String) {
        Task {
            do {
                let response = try await generativeModel.generateContent(inputs)
                if let text = response.text {
                    // 保留之前的输出内容，并以右对齐的形式追加新的输入内容和输出内容之间的空白行
                    输出.text += "\n\(inputs.rightAligned())\n\(text)\n"
                }
            } catch {
                print("Error generating content: \(error)")
            }
        }
    }
}

extension String {
    func rightAligned(totalWidth: Int = 40) -> String {
        let padding = max(0, totalWidth - count)
        return String(repeating: " ", count: padding) + self
    }
}
