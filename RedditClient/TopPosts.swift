//
//  TopPosts.swift
//  RedditClient
//
//  Created by Kyle Dushman on 9/5/18.
//

import UIKit

class TopPosts: UIViewController {

    
    // Create the layout of the Top Posts screen, first list variables used
    var navBar = UIView()
    var navTitle = UILabel()
    var navIcon = UIImageView()
    var navTime = UILabel()
    
    var collectionViewContainer = UIView()
//    var postCollectionView = UICollectionView()
    
    
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
        navTitle.text = "TOP 50"
        navTitle.textAlignment = .center
        navTitle.font = UIFont(name: "Futura-Bold", size: 36)
        navBar.addSubview(navTitle)
        let centerXNavTitle = NSLayoutConstraint(item: navTitle, attribute: .centerX, relatedBy: .equal, toItem: navBar, attribute: .centerX, multiplier: 1.0, constant: 53/2)
        let topNavTitle = NSLayoutConstraint(item: navTitle, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .top, multiplier: 1.0, constant: 10.0)
        let navTitleHeight = navTitle.heightAnchor.constraint(equalToConstant: (navTitle.text?.size(OfFont: navTitle.font).height)!)
        let navTitleWidth = navTitle.widthAnchor.constraint(equalToConstant: (navTitle.text?.size(OfFont: navTitle.font).width)!)
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerXNavTitle, topNavTitle, navTitleWidth, navTitleHeight])
        
        // navIcon Properties and Contraints
        navIcon.image = #imageLiteral(resourceName: "topPosts")
        navIcon.contentMode = .scaleAspectFit
        navBar.addSubview(navIcon)
        let rightNavIcon = NSLayoutConstraint(item: navIcon, attribute: .right, relatedBy: .equal, toItem: navTitle, attribute: .left, multiplier: 1.0, constant: -15.0)
        let bottomNavIcon = NSLayoutConstraint(item: navIcon, attribute: .bottom, relatedBy: .equal, toItem: navTitle, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        let navIconWidth = navIcon.widthAnchor.constraint(equalToConstant: 38.0)
        let navIconHeight = navIcon.heightAnchor.constraint(equalTo: navTitle.heightAnchor, multiplier: 1.0)
        navIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([rightNavIcon, bottomNavIcon, navIconWidth, navIconHeight])
        
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
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}

// Get the size of a string with a selected font
// Used for UILabels to determine the width/height
extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: font])
    }
}
