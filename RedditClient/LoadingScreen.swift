//
//  LoadingScreen.swift
//  RedditClient
//
//  Created by Kyle Dushman on 9/4/18.
//

import UIKit

class LoadingScreen: UIViewController {

    // Used for devide ID for OAuth
    let uuid = UUID().uuidString
    
    // client ID to be used for oAuth
    let clientID = "z61cQmzN3G2_UA"
    let clientIDFormatted = "z61cQmzN3G2_UA:".toBaseSixtyFour()
    
    // app only grant type
    let grantType = "https://oauth.reddit.com/grants/installed_client"
    
    // Use the clientID, deviceID, and grantType to get an access token used to access reddit
    func getAccessToken() {
        
        let params = ["grant_type": grantType, "device_id": uuid]
        
        let url = URL(string: "https://www.reddit.com/api/v1/access_token")!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let paramsString = self.toParamsString(params: params)
        request.httpBody = paramsString.data(using: .utf8)
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(clientIDFormatted)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    // convert dictionary into post params string
    func toParamsString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAccessToken()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Extenstion to convert the client ID into base 64
extension String {
    
    func toBaseSixtyFour() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
