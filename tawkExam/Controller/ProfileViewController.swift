//
//  ProfileViewController.swift
//  tawkExam
//
//  Created by CRAMJ on 8/6/20.
//  Copyright © 2020 CRAMJ. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var selectedUser = ""
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var txtviewNotes: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserProfile()
        // Do any additional setup after loading the view.
    }
    
    func getUserProfile()
    {
        APIManager.sharedInstance.getUserProfile(user: selectedUser, completion: { (userProfileModel, error) in
            
            if let _ = userProfileModel
            {
                let url = URL(string: userProfileModel?.avatar_url ?? "")
                self.imgAvatar.kf.setImage(with: url)
                self.lblFollowers.text = "Followers: \(userProfileModel?.followers ?? 0)"
                self.lblFollowing.text = "Following: \(userProfileModel?.following ?? 0)"
                self.lblName.text = userProfileModel?.name ?? ""
                self.lblCompany.text = userProfileModel?.company ?? ""
                self.lblBlog.text = userProfileModel?.blog ?? ""
            }
            else
            {
                let alertController = UIAlertController(title: "Failed", message: "Server", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    @IBAction func TappedSave(_ sender: Any) {
        let alertController = UIAlertController(title: "Saved", message: "Note has been save", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
}
