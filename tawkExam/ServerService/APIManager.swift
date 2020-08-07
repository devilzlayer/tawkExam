//
//  APIManager.swift
//  tawkExam
//
//  Created by CRAMJ on 8/6/20.
//  Copyright © 2020 CRAMJ. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
static let sharedInstance = APIManager()
    
    func getUserList(page: Int,  completion:@escaping (_ data: [UserlistElementModel]? , _ error: String) -> Void){
        AF.request(Constants.baseURL + "?since=\(page)", method: .get).responseDecodable { (response: AFDataResponse<[UserlistElementModel]>) -> Void in
            switch response.result {
            case .success(let userListModel):
                completion(userListModel,"")
            case .failure(let error):
                completion(nil,error.localizedDescription)
            }
        }
    }
    func getUserProfile(user: String,  completion:@escaping (_ data: UserprofileModel? , _ error: String) -> Void){
        AF.request(Constants.baseURL + "/\(user)", method: .get).responseDecodable { (response: AFDataResponse<UserprofileModel>) -> Void in
            switch response.result {
            case .success(let userProfileModel):
                completion(userProfileModel,"")
            case .failure(let error):
                completion(nil,error.localizedDescription)
            }
        }
    }
}
