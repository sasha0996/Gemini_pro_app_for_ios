import GoogleGenerativeAI
import Foundation

enum APIKey {
  // Fetch the API key from `GenerativeAI-Info.plist`
  static var `default`: String {
    guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
    else {
      fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
    }
    if value.starts(with: "_") {
      fatalError(
        "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
      )
    }
    return value
  }
}


let model = GenerativeModel(name: "MODEL_NAME", apiKey: APIKey.default)

func ww (inputs:String) async->String{
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)

    let prompt:String = inputs
    let response = try! await model.generateContent(prompt)
    if let text = response.text {
      print(text)
    }
    return response.text ?? "0"
}

