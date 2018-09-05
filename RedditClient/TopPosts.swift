//
//  TopPosts.swift
//  RedditClient
//
//  Created by Kyle Dushman on 9/5/18.
//

import UIKit


class TopPosts: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // Store posts in this array
    var posts = [Dictionary<String, AnyObject>]()
    
    // Cache Downloaded Images
    let imageCache = NSCache<NSString, UIImage>()
    
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
        navFifty.text = "50"
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
        postCollectionView.showsVerticalScrollIndicator = false
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
                        
                        var thumbnailHeight = CGFloat()
                        
                        if thumbnailURL != "self" {
                            thumbnailHeight = (children[i]["data"]! as AnyObject)["thumbnail_height"]! as! CGFloat
                        }
                        

                        
                        var dict = Dictionary<String, AnyObject>()
                        dict["title"] = (title as AnyObject)
                        dict["author"] = (author as AnyObject)
                        dict["comment"] = (comment as AnyObject)
                        dict["time"] = (timeFormatted as AnyObject)
                        dict["thumbnailURL"] = (thumbnailURL as AnyObject)
                        dict["thumbnailHeight"] = (thumbnailHeight as AnyObject)

                        
//                        print(dict)
                        self.posts.append(dict)
                        
                        // if there is a thumbnail, download and cache it
                        if thumbnailURL != "default" {
                            self.donwloadImageFrom(urlString: thumbnailURL)
                        }
                        

                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.postCollectionView.reloadData()
                    })
                    
                    
//                    print(self.posts.count)
                    
                    if self.posts.count < 50 {
                        self.getPosts(subreddit: "all", filter: "top", limit: 10, after: after, count: self.posts.count)
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
    
    
    // Download thumbnails and Cache the image
    func donwloadImageFrom(urlString: String) {
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                
                self.imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                
                self.postCollectionView.reloadData()
            })
            
        }).resume()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLayout()
        
        getPosts(subreddit: "all", filter: "top", limit: 10, after: "", count: 0)
        
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
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! postCell

        cell.titleLabel.text = (self.posts[indexPath.item]["title"]! as! String)
        
        cell.authorLabel.text =  "by: \(self.posts[indexPath.item]["author"]! as! String)"
        
        cell.commentLabel.text = "\(self.posts[indexPath.item]["comment"]! as! Int)"
        
        if self.posts[indexPath.item]["time"] as! Int == 1 {
            cell.timeLabel.text = "\(self.posts[indexPath.item]["time"] as! Int) hour ago"
        } else {
            cell.timeLabel.text = "\(self.posts[indexPath.item]["time"] as! Int) hours ago"
        }
        
        let urlString = self.posts[indexPath.item]["thumbnailURL"]! as! String
        
        if urlString != "default" {
            cell.postImageView.image = imageCache.object(forKey: urlString as NSString)
        } else {
            cell.postImageView.image = UIImage()
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let titleHeight = (self.posts[indexPath.item]["title"]! as! String).height(withConstrainedWidth: self.view.frame.width*0.8, font: postCell().titleLabel.font!)
        
        let urlString = self.posts[indexPath.item]["thumbnailURL"]! as! String
        
        if urlString != "default" {
            
            let imageHeight = self.posts[indexPath.item]["thumbnailHeight"]! as! CGFloat
            
            return CGSize(width: self.view.frame.width, height: 100+titleHeight+imageHeight)
            
        } else {
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
    
    var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
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
        
        // Title Contraints
        let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5.0)
        let titleLabelWidth = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0.0)
        NSLayoutConstraint.activate([titleLabelCenterX, titleLabelTop, titleLabelWidth])
        
        // Author Contraints
        let authorLabelCenterX = NSLayoutConstraint(item: authorLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let authorLabelTop = NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let authorLabelWidth = NSLayoutConstraint(item: authorLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0.0)
        NSLayoutConstraint.activate([authorLabelCenterX, authorLabelTop, authorLabelWidth])
        
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

