//
//  LoadingScreen.swift
//  RedditClient
//
//  Created by Kyle Dushman on 9/4/18.
//

import UIKit

public var accessData = [String: Any]()

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
                    accessData = json
                    
                    // Now with the access token saved, animate, then segue
                    DispatchQueue.main.async(execute: {
                        self.animateIcon()
                    })
                    
                    
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
    
    
    // Create the layout of the launch screen, first list variables used
    let redditIconImageView = UIImageView()
    let iconBG = UIView()
    
    func createLayout() {
        
        let width = self.view.frame.width
        
        // redditIconImageView Properties and Contraints
        redditIconImageView.image = #imageLiteral(resourceName: "redditClear")
        redditIconImageView.contentMode = .scaleAspectFit
        view.addSubview(redditIconImageView)
        let centerXImageView = NSLayoutConstraint(item: redditIconImageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYImageView = NSLayoutConstraint(item: redditIconImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let widthImageView = redditIconImageView.widthAnchor.constraint(equalToConstant: width*0.5)
        let heightImageView = redditIconImageView.heightAnchor.constraint(equalTo: redditIconImageView.widthAnchor, multiplier: 1.0)
        redditIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerXImageView, centerYImageView, widthImageView, heightImageView])
        
        // IconBG Properties and Contraints
        iconBG.backgroundColor = UIColor(red: 237/255, green: 84/255, blue: 41/255, alpha: 1.0)
        view.addSubview(iconBG)
        let leftIconBG = NSLayoutConstraint(item: iconBG, attribute: .left, relatedBy: .equal, toItem: redditIconImageView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightIconBG = NSLayoutConstraint(item: iconBG, attribute: .right, relatedBy: .equal, toItem: redditIconImageView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topIconBG = NSLayoutConstraint(item: iconBG, attribute: .top, relatedBy: .equal, toItem: redditIconImageView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomIconBG = NSLayoutConstraint(item: iconBG, attribute: .bottom, relatedBy: .equal, toItem: redditIconImageView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        iconBG.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leftIconBG, rightIconBG, topIconBG, bottomIconBG])
        
        
        view.bringSubview(toFront: redditIconImageView)
        
    }
    
    // Animated the Icon from Reddit Orange to Black
    func animateIcon() {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.iconBG.backgroundColor = .black
            
        }, completion: { (completed) in

            // segue to app
            DispatchQueue.main.async(execute: {
                
                self.performSegue(withIdentifier: "toTopPostsFromLoadingScreen", sender: self)
                
            })
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLayout()
        
        getAccessToken()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// Extenstion to convert the client ID into base 64
extension String {
    
    func toBaseSixtyFour() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
