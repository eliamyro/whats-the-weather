//
//  ViewController.swift
//  What Is The Weather
//
//  Created by Elias Myronidis on 21/4/17.
//  Copyright © 2017 eliamyro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButton(_ sender: Any) {
        if let city = cityTextField.text {
            let BASE_URL = "http://www.weather-forecast.com/locations/\(city.replacingOccurrences(of: " ", with: "-"))/forecasts/latest"
            
            if let url = URL(string: BASE_URL) {
                let request = NSMutableURLRequest(url: url)
                var message = ""
                
                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    if error != nil {
                        self.weatherLabel.text = "Please enter a valid location"
                    } else {
                        if let unwrappedData = data {
                            let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                            
                            var separator = "Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                            
                            if let contentArray = dataString?.components(separatedBy: separator) {
                                
                                if contentArray.count > 1 {
                                    separator = "</span>"
                                    
                                    let newContentArray = contentArray[1].components(separatedBy: separator)
                                    if newContentArray.count > 1 {
                                        message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    if message == "" {
                        message = "The weather there couldn't be found. Please try again."
                    }
                    
                    DispatchQueue.main.sync(execute: {
                        self.weatherLabel.text = message
                    })
                })
                
            task.resume()
            }
        } else {
            weatherLabel.text = "The weather there couldn't be found. Please try again. "
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

}

