//
//  TopPosts.swift
//  RedditClient
//
//  Created by Kyle Dushman on 9/5/18.
//

import UIKit
import Photos
import SafariServices

// Store posts in this array
public var posts = [Dictionary<String, AnyObject>]()


class TopPosts: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // Cache Downloaded Images
    let thumbnailCache = NSCache<NSString, UIImage>()
    let postCache = NSCache<NSString, UIImage>()

    // Create the layout of the Top Posts screen, first list variables used
    var navBar = UIView()
    var navTitle = UILabel()
    var navFifty = UILabel()
    var navIcon = UIImageView()
    var navTime = UILabel()
    
    var collectionViewContainer = UIView()
    var postCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let postFlowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    func createLayout() {
        
        // navBar Properties and Contraints
        view.addSubview(navBar)
        let navBarLeft = NSLayoutConstraint(item: navBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let navBarRight = NSLayoutConstraint(item: navBar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let navBarTop = NSLayoutConstraint(item: navBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0)
        let navBarHeight = navBar.heightAnchor.constraint(equalToConstant: 90)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([navBarLeft, navBarRight, navBarTop, navBarHeight])
        
        // navTitle Properties and Contraints
        navTitle.text = "ALL"
        navTitle.textAlignment = .center
        navTitle.font = UIFont(name: "Futura-Bold", size: 36)
        navBar.addSubview(navTitle)
        let centerXNavTitle = NSLayoutConstraint(item: navTitle, attribute: .centerX, relatedBy: .equal, toItem: navBar, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let topNavTitle = NSLayoutConstraint(item: navTitle, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .top, multiplier: 1.0, constant: 10.0)
        let navTitleHeight = navTitle.heightAnchor.constraint(equalToConstant: 30)
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerXNavTitle, topNavTitle, navTitleHeight])
        
        // navIcon Properties and Contraints
        navIcon.image = #imageLiteral(resourceName: "topPosts")
        navIcon.contentMode = .scaleAspectFit
        navBar.addSubview(navIcon)
        let navIconLeft = NSLayoutConstraint(item: navIcon, attribute: .left, relatedBy: .equal, toItem: navBar, attribute: .left, multiplier: 1.0, constant: 5.0)
        let navIconBottom = NSLayoutConstraint(item: navIcon, attribute: .bottom, relatedBy: .equal, toItem: navTitle, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let navIconWidth = navIcon.widthAnchor.constraint(equalToConstant: 34.0)
        let navIconHeight = navIcon.heightAnchor.constraint(equalToConstant: 34.0)
        navIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([navIconLeft, navIconBottom, navIconWidth, navIconHeight])
        
        // navTitle 50
        navFifty.text = "0"
        navFifty.textAlignment = .right
        navFifty.font = UIFont(name: "Futura-Bold", size: 36)
        navBar.addSubview(navFifty)
        let navFiftyRight = NSLayoutConstraint(item: navFifty, attribute: .right, relatedBy: .equal, toItem: navBar, attribute: .right, multiplier: 1.0, constant: -5.0)
        let navFiftyTop = NSLayoutConstraint(item: navFifty, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .top, multiplier: 1.0, constant: 10.0)
        let navFiftyHeight = navFifty.heightAnchor.constraint(equalToConstant: 30)
        navFifty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([navFiftyRight, navFiftyTop, navFiftyHeight])
        
        // navTime Properties and Contraints
        navTime.text = "Past 24 Hours"
        navTime.textAlignment = .center
        navTime.font = UIFont(name: "Futura-MediumItalic", size: 18)
        navBar.addSubview(navTime)
        let centerXNavTime = NSLayoutConstraint(item: navTime, attribute: .centerX, relatedBy: .equal, toItem: navBar, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let topNavTime = NSLayoutConstraint(item: navTime, attribute: .top, relatedBy: .equal, toItem: navTitle, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        navTime.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerXNavTime, topNavTime])
            
        // collectionViewContainer Properties and Contraints
        collectionViewContainer.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        view.addSubview(collectionViewContainer)
        let collectionViewContainerLeft = NSLayoutConstraint(item: collectionViewContainer, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let collectionViewContainerRight = NSLayoutConstraint(item: collectionViewContainer, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let collectionViewContainerTop = NSLayoutConstraint(item: collectionViewContainer, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let collectionViewContainerBottom = NSLayoutConstraint(item: collectionViewContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0)
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionViewContainerLeft, collectionViewContainerRight, collectionViewContainerTop, collectionViewContainerBottom])
        
        
        // Collection View and Flow Layout Properties and Contraints
        postFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        postFlowLayout.minimumLineSpacing = 10.0
        
        postFlowLayout.scrollDirection = .vertical
        postCollectionView.setCollectionViewLayout(postFlowLayout, animated: true)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(postCell.self, forCellWithReuseIdentifier: "Cell")
        postCollectionView.backgroundColor = UIColor.clear
        postCollectionView.showsVerticalScrollIndicator = true
        postCollectionView.alwaysBounceVertical = true
        collectionViewContainer.addSubview(postCollectionView)
        let postCollectionViewLeft = NSLayoutConstraint(item: postCollectionView, attribute: .left, relatedBy: .equal, toItem: collectionViewContainer, attribute: .left, multiplier: 1.0, constant: 0.0)
        let postCollectionViewTop = NSLayoutConstraint(item: postCollectionView, attribute: .top, relatedBy: .equal, toItem: collectionViewContainer, attribute: .top, multiplier: 1.0, constant: 10.0)
        let postCollectionViewRight = NSLayoutConstraint(item: postCollectionView, attribute: .right, relatedBy: .equal, toItem: collectionViewContainer, attribute: .right, multiplier: 1.0, constant: 0.0)
        let postCollectionViewBottom = NSLayoutConstraint(item: postCollectionView, attribute: .bottom, relatedBy: .equal, toItem: collectionViewContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([postCollectionViewLeft, postCollectionViewRight, postCollectionViewBottom, postCollectionViewTop])
        
    }
    
    // Get a slice of posts based on selected subreddit, filter (top), and limit with pagination
    
    func getPosts(subreddit: String, filter: String, limit: Int, after: String, count: Int) {
        
        var urlString = ""
        
        if after != "" && count != 0 {
            // Subsequent runs to get the next slice of posts
            urlString = "https://oauth.reddit.com/r/\(subreddit)/\(filter).json?limit=\(limit)&after=\(after)&count=\(count)"
            
        } else if after == "" && count == 0 {
            // First run to get a slice of posts
            urlString = "https://oauth.reddit.com/r/\(subreddit)/\(filter).json?limit=\(limit)"
        }
        
        let url = URL(string: urlString)!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessData["access_token"]!)", forHTTPHeaderField: "Authorization")
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
//                    print(json)

                    let children = json["data"]!["children"]! as! [AnyObject]
                    let after = json["data"]!["after"]! as! String
                    let dist = json["data"]!["dist"]! as! Int
                    
                    for i in 0..<(dist) {
                        
                        let title = (children[i]["data"]! as AnyObject)["title"]! as! String
                        let author = (children[i]["data"]! as AnyObject)["author"]! as! String
                        let comment = (children[i]["data"]! as AnyObject)["num_comments"]! as! Int
                        let time = (children[i]["data"]! as AnyObject)["created_utc"]! as! Int
                        let timeSince = Date(timeIntervalSince1970: Double(time))
                        let timeFormatted = self.hours(from: timeSince)
                        let thumbnailURL = (children[i]["data"]! as AnyObject)["thumbnail"]! as! String
                        
                        var imageURL = String()
                        var thumbnailHeight = CGFloat()
                        
                        if thumbnailURL.starts(with: "http") {
                            thumbnailHeight = (children[i]["data"]! as AnyObject)["thumbnail_height"]! as! CGFloat
                            imageURL = (children[i]["data"]! as AnyObject)["url"]! as! String
                        }
                        
                        var dict = Dictionary<String, AnyObject>()
                        dict["title"] = (title as AnyObject)
                        dict["author"] = (author as AnyObject)
                        dict["comment"] = (comment as AnyObject)
                        dict["time"] = (timeFormatted as AnyObject)
                        dict["thumbnailURL"] = (thumbnailURL as AnyObject)
                        dict["thumbnailHeight"] = (thumbnailHeight as AnyObject)
                        dict["imageURL"] = (imageURL as AnyObject)

                        
//                        print(dict)
                        posts.append(dict)
                        
                        // if there is a thumbnail, download and cache it
                        if thumbnailURL.starts(with: "http") {
                            self.downloadImage(urlString: thumbnailURL, type: "thumbnail")
                        }
                        

                    }
                    
                    DispatchQueue.main.async(execute: {
                        // update the counter and reload the cells with the new posts
                        self.navFifty.text = "\(posts.count)"
                        self.postCollectionView.reloadData()
                    })
                    
                    // Continue pagination until there are 50 posts
                    if posts.count < 50 {
                        self.getPosts(subreddit: "all", filter: "top", limit: 10, after: after, count: posts.count)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    // Get the hours between a date argument (Time of created post) and the current date/time
    // Used to get the "x hours ago" format
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
    }
    
    
    // Download image and cache
    // If the image is a thumbnail, cache and reload cells
    // If the image is a postimage, cache, and then display the image with the image viewer
    func downloadImage(urlString: String, type: String) {
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                // If this is a thumbnail, cache it to the thumbnail storage
                if type == "thumbnail" {
                    
                    self.thumbnailCache.setObject(imageToCache!, forKey: urlString as NSString)
                    
                    self.postCollectionView.reloadData()
                    
                // If this is a full size image, cache it to the full image storage, then display the image
                // When the type is a postimage, this function is firing when a user wants to view an image
                // Postimage type means that its full url is an image not a link
                } else if type == "postimage" {
                    
                    self.postCache.setObject(imageToCache!, forKey: urlString as NSString)
                    
                    // Expand Cell and Display Image
                    self.postCollectionView.scrollToItem(at: self.selectedItem, at: .top, animated: true)
                    self.postCollectionView.reloadData()
                }
                
            })
            
        }).resume()
    }
    
    // When an image is tapped, check to see if its a thumbnail or a postimage to get the proper URL
    // if it is a post image: check cache, if it is cached, view image, if not, download then view
    // if it is a thumbnail, view image
    @objc func handleViewImage(cached: Bool, type: String, url: String, fullurl: String) {
        
        if cached == true {
            
            if type == "postimage" {
                self.postCollectionView.scrollToItem(at: self.selectedItem, at: .top, animated: true)
                self.postCollectionView.reloadData()
            } else if type == "thumbnail" {
                let image = thumbnailCache.object(forKey: url as NSString)
                handleImageHold(url: fullurl, image: image!, type: "thumbnail")
            }
            
        } else {
            
            // download then display image
            self.downloadImage(urlString: url, type: "postimage")
        }
    }
    
    // When an image is held down, ask the user if they want to open a link or save the image
    func handleImageHold(url: String, image: UIImage, type: String) {
        
                let alert = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
                let openLink = UIAlertAction(title: "Open Link", style: .default) { (action) in
                    self.goTo(urlString: url)
                }
        
                var text = ""
                if type == "thumbnail" {
                    text = "Save Thumbnail"
                } else {
                    text = "Save Image"
                }
        
                let saveImage = UIAlertAction(title: "\(text)", style: .default) { (action) in
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }, completionHandler: { success, error in
                        if success {
                            // Success
                        }
                        else if error != nil {
                            // Error
                        }
                    })
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alert.addAction(openLink)
                alert.addAction(saveImage)
                alert.addAction(cancel)
                
                self.present(alert, animated: true) {
                }
    }
    
    // Used to go to a safari extension to view a link or image
    func goTo(urlString: String) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
        let url = URL(string: urlString)
        let vc = SFSafariViewController(url: url!, configuration: config)
            present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLayout()
        
        getPosts(subreddit: "all", filter: "top", limit: 10, after: "", count: 0)
        
            // Notification that manages when the app will re-enter the foreground
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkPermission()
    }
    
    // Check to make sure user can save photos to their camera roll
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    // The function handle that fires when the app re-enters the foreground
    // If necesarry, this will get a new access token if expired, then reload collection view with new posts
    @objc func willEnterForeground() {
        
        // Clear old posts
        posts.removeAll(keepingCapacity: true)
        self.navFifty.text = "0"
        self.selectedItem = IndexPath()
        postCollectionView.reloadData()
        
        let now = Date().timeIntervalSince1970
        let exp = expTime.timeIntervalSince1970
        
        // Check if the access token is expired
        if now >= exp {
            // get new access token before refreshing posts
            reloadSession()
        } else {
            // access token is valid, refresh posts
            getPosts(subreddit: "all", filter: "top", limit: 10, after: "", count: 0)
        }
    }
    
    
    // Gets a new access token
    func reloadSession() {
        
        // Used for devide ID for OAuth
        let uuid = UUID().uuidString
        
        // client ID to be used for oAuth
        let clientIDFormatted = "z61cQmzN3G2_UA:".toBaseSixtyFour()
        
        // app only grant type
        let grantType = "https://oauth.reddit.com/grants/installed_client"
        
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
                    expTime = Date().addingTimeInterval(Double(3600))
                    
                    // Now with the access token refreshed, load posts
                    DispatchQueue.main.async(execute: {
                        self.getPosts(subreddit: "all", filter: "top", limit: 10, after: "", count: 0)
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

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    // Collection View Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1 section for all the posts
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // the count of posts as more posts load
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! postCell

        // Set title text and height based on title length
        cell.titleLabel.text = (posts[indexPath.item]["title"]! as! String)
        cell.titleHeight.constant = (posts[indexPath.item]["title"]! as! String).height(withConstrainedWidth: cell.frame.width*0.8, font: cell.titleLabel.font!)
        
        // Set author text and height based on author length
        cell.authorLabel.text =  "by: \(posts[indexPath.item]["author"]! as! String)"
        cell.authorHeight.constant = (posts[indexPath.item]["author"]! as! String).height(withConstrainedWidth: cell.frame.width*0.8, font: cell.authorLabel.font!)
        
        // Set the comment number
        cell.commentLabel.text = "\(posts[indexPath.item]["comment"]! as! Int)"
        
        // Set the time, if 1 use hour, if greater than 1 use hours
        if posts[indexPath.item]["time"] as! Int == 1 {
            cell.timeLabel.text = "\(posts[indexPath.item]["time"] as! Int) hour ago"
        } else {
            cell.timeLabel.text = "\(posts[indexPath.item]["time"] as! Int) hours ago"
        }
        
        // Set both constants of urls, fullImageURL may just be a link
        let thumbnailURL = posts[indexPath.item]["thumbnailURL"]! as! String
        let fullImageURL = posts[indexPath.item]["imageURL"]! as! String
        
        // Check to see if the post has a thumbnail
        // Other options if no thumbnail are NSFW, Self, and Default
        // This check won't show posts that do not have a safe thumbnail
        if thumbnailURL.starts(with: "http") {
            
            // If selected, expand cell with cached image
            if self.selectedItem == indexPath {
                if postCache.object(forKey: fullImageURL as NSString) != nil {
                    cell.postImageView.image = postCache.object(forKey: fullImageURL as NSString)
                } else {
                    cell.postImageView.image = thumbnailCache.object(forKey: thumbnailURL as NSString)
                }
                
            } else {
                cell.postImageView.image = thumbnailCache.object(forKey: thumbnailURL as NSString)
            }
            
        } else {
            cell.postImageView.image = UIImage()
        }
        
        // If there is an image allow interactions with the imageView
        // If no image, it is empty, but this is an extra precaution
        if cell.postImageView.image?.size != CGSize.zero {
            
            // When an image is tapped
            cell.postImageView.addTapGestureRecognizer(action: {
                
                var cached = Bool()
                var type = String()
                var url = String()
                var fullurl = String()
                
                // Check if the full image is an image or a link
                if fullImageURL.contains(".jpg") == true {
                    // use full image url, check if cached
                    if self.postCache.object(forKey: fullImageURL as NSString) != nil {
                        cached = true
                        type = "postimage"
                        url = fullImageURL
                        fullurl = fullImageURL

                    } else {
                        // Not cached, will need to download the image
                        cached = false
                        type = "postimage"
                        url = fullImageURL
                        fullurl = fullImageURL
                    }
                } else {
                    // use thumbnail, already cached
                    cached = true
                    type = "thumbnail"
                    url = thumbnailURL
                    fullurl = fullImageURL

                }
                
                if type == "postimage" {
                    
                    // If the cell is already expanded, tapping will offer a save option or go to link
                    if indexPath == self.selectedItem {
                        self.handleImageHold(url: fullImageURL, image: cell.postImageView.image!, type: "postimage")
                    } else {
                        // expand cell
                        self.selectedItem = indexPath
                        collectionView.reloadData()
                    }
                    
                }
                // Handle image based on caching, type, and pass both the fullurl and thumbnail url
                // In some cases, the url will be the same as the fullurl
                self.handleViewImage(cached: cached, type: type, url: url, fullurl: fullurl)
            })
            
            // When an image is held down
            cell.postImageView.addHoldGestureRecognizer(action: {
                
                // Set the type of image for the save image/thumbnail option
                if indexPath == self.selectedItem {
                    self.handleImageHold(url: fullImageURL, image: cell.postImageView.image!, type: "postimage")
                } else {
                    self.handleImageHold(url: fullImageURL, image: cell.postImageView.image!, type: "thumbnail")
                }
            })
            
        }
        
        return cell
    }
    
    var selectedItem = IndexPath()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Set the titleHeight of the title based on its width and font
        let titleHeight = (posts[indexPath.item]["title"]! as! String).height(withConstrainedWidth: self.view.frame.width*0.8, font: postCell().titleLabel.font!)
        
        let urlString = posts[indexPath.item]["thumbnailURL"]! as! String
        
        // Check if there is an image
        if urlString.starts(with: "http") {
            
            let imageHeight = posts[indexPath.item]["thumbnailHeight"]! as! CGFloat

            // Expand cell if it is the selected cell
            if indexPath == self.selectedItem {
                // expanded cell
                return CGSize(width: self.view.frame.width, height: self.collectionViewContainer.frame.height-20)
            } else {
                // Cell that is not expanded, but has an image
                return CGSize(width: self.view.frame.width, height: 100+titleHeight+imageHeight)
            }

        } else {
            // Height of post with no image, just based on titleHeight
            return CGSize(width: self.view.frame.width, height: 100+titleHeight)
        }
        
    }
    


    // When deived orientation changes, change the flowLayout
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        postFlowLayout.invalidateLayout()
    }
    
    
}

// Layout of postCell

class postCell: UICollectionViewCell {
    
    // Title and Author Height Contraints
    var titleHeight = NSLayoutConstraint()
    var authorHeight = NSLayoutConstraint()

    // Label to display title
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TITLE"
        label.font = UIFont(name: "Futura-Medium", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label to display author
    var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "by: author name"
        label.font = UIFont(name: "Futura-Medium", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ImageView displaying comment icon
    var commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "comment")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label to display comment number
    var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.font = UIFont(name: "Futura-Medium", size: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label to display hours
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "x hours ago"
        label.font = UIFont(name: "Futura-Medium", size: 18)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ImageView to hold the post image
    var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    
    func addViews(){
        
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(commentImageView)
        addSubview(commentLabel)
        addSubview(timeLabel)
        addSubview(postImageView)
        
        // Title Contraints, title height will be updated later so it is stored as a contraint in the cell
        let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5.0)
        let titleLabelWidth = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0.0)
        titleHeight = titleLabel.heightAnchor.constraint(equalToConstant: 18)
        NSLayoutConstraint.activate([titleLabelCenterX, titleLabelTop, titleLabelWidth, titleHeight])
        
        // Author Contraints, author height will be updated later so it is stored as a contraint in the cell
        let authorLabelCenterX = NSLayoutConstraint(item: authorLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let authorLabelTop = NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let authorLabelWidth = NSLayoutConstraint(item: authorLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0.0)
        authorHeight = authorLabel.heightAnchor.constraint(equalToConstant: 18)
        NSLayoutConstraint.activate([authorLabelCenterX, authorLabelTop, authorLabelWidth, authorHeight])
        
        // Comment Image Contraints
        let commentImageViewLeft = NSLayoutConstraint(item: commentImageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5.0)
        let commentImageViewBottom = NSLayoutConstraint(item: commentImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        let commentImageViewHeight = commentImageView.heightAnchor.constraint(equalToConstant: 26.0)
        let commentImageViewWidth = commentImageView.widthAnchor.constraint(equalToConstant: 25.0)
        NSLayoutConstraint.activate([commentImageViewLeft, commentImageViewBottom, commentImageViewWidth, commentImageViewHeight])
        
        // Comment Number Label Contraints
        let commentLabelLeft = NSLayoutConstraint(item: commentLabel, attribute: .left, relatedBy: .equal, toItem: commentImageView, attribute: .right, multiplier: 1.0, constant: 5.0)
        let commentLabelCenterY = NSLayoutConstraint(item: commentLabel, attribute: .centerY, relatedBy: .equal, toItem: commentImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([commentLabelCenterY, commentLabelLeft])
        
        // Time Contraints
        let timeLabelRight = NSLayoutConstraint(item: timeLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -5.0)
        let timeLabelBottom = NSLayoutConstraint(item: timeLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        NSLayoutConstraint.activate([timeLabelRight, timeLabelBottom])
        
        
        // Post Image Contraints
        let postImageViewTop = NSLayoutConstraint(item: postImageView, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        let postImageViewBottom = NSLayoutConstraint(item: postImageView, attribute: .bottom, relatedBy: .equal, toItem: commentImageView, attribute: .top, multiplier: 1.0, constant: -10.0)
        let postImageViewCenterX = NSLayoutConstraint(item: postImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let postImageViewWidth = postImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        NSLayoutConstraint.activate([postImageViewTop, postImageViewBottom, postImageViewCenterX, postImageViewWidth])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




// Get the size of a string with a selected font
// Used for UILabels to determine the width/height
extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}

// Get the height of a label frame with a specified font and width/height
// Used to make dynamic cells with title height
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


// Quick tap gesture for adding actions to an imageview in a collection view cell
// Used to expand the cell to reveal the full image of a thumbnail if there is a full image
// Allows for skipping selector, can be used in cellforitem
extension UIImageView {
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}

// Quick hold gesture for adding actions to an imageview in a collection view cell
// Used to save images
// Allows for skipping selector, can be used in cellforitem
extension UIImageView {
    
    fileprivate struct HoldAssociatedObjectKeys {
        static var holdGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias HoldAction = (() -> Void)?
    
    fileprivate var holdGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &HoldAssociatedObjectKeys.holdGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let holdGestureRecognizerActionInstance = objc_getAssociatedObject(self, &HoldAssociatedObjectKeys.holdGestureRecognizer) as? Action
            return holdGestureRecognizerActionInstance
        }
    }
    
    public func addHoldGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.holdGestureRecognizerAction = action
        let holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleHoldGesture))
        holdGestureRecognizer.allowableMovement = 5.0
        holdGestureRecognizer.minimumPressDuration = 0.5
        self.addGestureRecognizer(holdGestureRecognizer)
    }
    
    @objc fileprivate func handleHoldGesture(sender: UITapGestureRecognizer) {
        if let action = self.holdGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}


