//
//  BaseModel.swift
//  tawkExam
//
//  Created by CRAMJ on 8/6/20.
//  Copyright © 2020 CRAMJ. All rights reserved.
//

import Foundation

struct UserlistElementModel: Codable {
    let login: String?
    let id: Int?
    let avatar_url: String?
//    let node_id: String?
//    let gravatar_id: String?
//    let url, html_url, followers_url: String?
//    let following_url, gists_url, starred_url: String?
//    let subscriptions_url, organizations_url, repos_url: String?
//    let events_url: String?
//    let received_events_url: String?
//    let type: String?
//    let site_admin: Bool?
//    let details: String?
}

struct UserprofileModel: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url, html_url, followers_url: String?
    let following_url, gists_url, starred_url: String?
    let subscriptions_url, organizations_url, repos_url: String?
    let events_url: String?
    let received_events_url: String?
    let type: String?
    let site_admin: Bool?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email, hireable, bio, twitter_username: String?
    let public_repos, public_gists, followers, following: Int?
    let created_at, updated_at: String?
}
