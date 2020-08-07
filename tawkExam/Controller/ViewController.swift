//
//  ViewController.swift
//  tawkExam
//
//  Created by CRAMJ on 8/6/20.
//  Copyright © 2020 CRAMJ. All rights reserved.
//

import UIKit
import Kingfisher
import PagingTableView
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PagingTableViewDelegate, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var srchBar: UISearchBar!
    @IBOutlet weak var tableView: PagingTableView!
    var selectedUser = ""
    var datas: [UserlistElementModel]?
    var arrFilteredDataModel: [UserlistElementModel]?
    var refreshControler = UIRefreshControl()
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.pagingDelegate = self
        self.srchBar.delegate = self
        refreshControler.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControler.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControler)
        self.retrieveData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(self.srchBar.text?.isEmpty ?? true)
        {
            self.arrFilteredDataModel =  self.datas?.filter({$0.login?.lowercased().contains(self.srchBar.text!.trimmingCharacters(in: .whitespaces).lowercased()) ?? false})
            self.tableView.reloadData()
        }
        else
        {
            self.arrFilteredDataModel = self.datas
            self.tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        self.datas = []
        self.arrFilteredDataModel = []
        self.tableView.reloadData()
        self.tableView.reset()
        self.retrieveData()
    }
    
    func paginate(_ tableView: PagingTableView, to page: Int) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height)
            {
                if !(self.tableView.isLoading)
                {
                    debugPrint("shouldReload \(currentPage)")
                    self.getUserList(page: currentPage)
                    self.tableView.isLoading = true
                }
                
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("Count: \(self.arrFilteredDataModel?.count ?? 0)")
        return self.arrFilteredDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row % 4) == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userInvertedCell", for: indexPath) as! InvertedTableViewCell
            let currentData = self.arrFilteredDataModel?[indexPath.row]
            let url = URL(string: currentData?.avatar_url ?? "")
            let resource = ImageResource(downloadURL: url!, cacheKey: currentData?.avatar_url)

            cell.imgAvatar.kf.setImage(with: resource) { result in
                switch result {
                case .success(let images):
                    cell.imgAvatar.image = images.image.invertedColors()
                case .failure(_):
                    debugPrint("Error Image")
                }
            }
            
            cell.lblUsername.text = currentData?.login ?? ""
            cell.lblDetails.text = "details"
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userNormalCell", for: indexPath) as! NormalTableViewCell
            let currentData = self.arrFilteredDataModel?[indexPath.row]
            let url = URL(string: currentData?.avatar_url ?? "")
            let resource = ImageResource(downloadURL: url!, cacheKey: currentData?.avatar_url)
            cell.imgAvatar.kf.setImage(with: resource) { result in
                switch result {
                case .success(let images):
                    cell.imgAvatar.image = images.image
                case .failure(_):
                   debugPrint("Error Image")
                }
            }
            cell.lblUsername.text = currentData?.login ?? ""
            cell.lblDetails.text = "details"
            return cell
        }
        
    }
    
    func getUserList(page: Int)
    {
        APIManager.sharedInstance.getUserList(page: page, completion: { (userListModel, error) in
            self.refreshControler.endRefreshing()
            if let _ = userListModel
            {

                self.datas = userListModel
                self.arrFilteredDataModel = self.datas
                self.saveData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.arrFilteredDataModel?[indexPath.row].login ?? ""
        self.performSegue(withIdentifier: "segueProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueProfile"
        {
            if let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.selectedUser = self.selectedUser
            }
        }
    }
    
    func saveData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: manageContext)!
        self.deletePage()
        let pageEntity = NSEntityDescription.entity(forEntityName: "Page", in: manageContext)!
        let pager = NSManagedObject(entity: pageEntity, insertInto: manageContext)
        pager.setValue(self.currentPage+1, forKey: "page")
        for data in self.datas ?? []
        {
            let user = NSManagedObject(entity: userEntity, insertInto: manageContext)
            user.setValue(data.login, forKey: "name")
            user.setValue(data.avatar_url, forKey: "avatar_url")
            user.setValue(data.id, forKeyPath: "id")
            
        }
        do {
            try manageContext.save()
        }
        catch let error as NSError
        {
            debugPrint("Error \(error), \(error.userInfo)")
        }
        self.retrieveData()
    }
    
    func retrieveData()
    {
        self.datas = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

        let fetchPageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Page")
        
        do {
            let result = try manageContext.fetch(fetchRequest)
            let pageResult = try manageContext.fetch(fetchPageRequest)
            
            for data in result as! [NSManagedObject] {
                let login = data.value(forKey: "name") as? String ?? ""
                let id = data.value(forKey: "id") as? Int ?? 0
                let avatar = data.value(forKey: "avatar_url") as? String ?? ""
                if self.datas?.count ?? 0 > 0
                {
                    self.datas?.append(UserlistElementModel(login: login, id: id, avatar_url: avatar))
                }
                else
                {
                    let data1 = UserlistElementModel(login: login, id: id, avatar_url: avatar)
                    self.datas = [data1]
                }
                
                
            }
            for data in pageResult as! [NSManagedObject] {
                self.currentPage = data.value(forKey: "page") as? Int ?? 0
                debugPrint("page: \(data.value(forKey: "page") ?? "")")
            }
            
            if !(self.datas?.count ?? 0 > 0)
            {
                self.getUserList(page: 0)
            }
            else
            {
                self.arrFilteredDataModel = self.datas
            }

            self.refreshControler.endRefreshing()
            self.tableView.reloadData()
            
            self.tableView.isLoading = false

        }
        catch
        {
            debugPrint("Error")
        }
    }
    
    func deletePage()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Page")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try manageContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                manageContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Error : \(error), \(error.userInfo)")
        }
    }
}

