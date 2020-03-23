//
// Copyright 2017 Anton Tananaev (anton.tananaev@gmail.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import iOSDropDown

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var serverField: DropDown!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func onStart(_ sender: AnyObject) {
        startButton.isEnabled = false

        var urlString = serverField.text!
        if !urlString.hasSuffix("/") {
            urlString += "/"
        }
        urlString += "api/server"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error == nil {
                    do {
                        try JSONSerialization.jsonObject(with: data!, options: [])
                        DispatchQueue.main.async {
                            self.onSuccess()
                        }
                    } catch _ as NSError {
                        DispatchQueue.main.async {
                            self.onError()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onError()
                    }
                }
            }
            task.resume()
        } else {
            self.onError()
        }
    }
    
    override func viewDidLoad() {
        serverField.delegate = self
        serverField.optionArray = ["URL_1",
                                   "URL_2",
                                   "URL_3"]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func onSuccess() {
        UserDefaults.standard.set(serverField.text, forKey: "url")
        performSegue(withIdentifier: "StartSegue", sender: self)
    }
    
    func onError() {
        startButton.isEnabled = true
        
        let alert = UIAlertController(title: "Error", message: "Server connection failed", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alert, animated: true)
    }

}
