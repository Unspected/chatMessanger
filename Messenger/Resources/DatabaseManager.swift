//
//  DataBaseManager.swift
//  Messenger
//
//  Created by Pavel Andreev on 7/22/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    // init database
    private let database = Database.database().reference()
   
}

// MARK: - Account Managment

extension DatabaseManager {
    
    public func userExists(with email: String,
                           complition: @escaping ((Bool) -> Void))  {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard  snapshot.value as? String != nil else {
                complition(false)
                return
            }
            complition(true)
        })
    }
    
    /// insert new users to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ])
        
    }
}


// Model  for saving
struct ChatAppUser {
    
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    // special property for saving in DataBase ( bacause requirements in Firebase doesn't allow to safe with simbols ", . # $ @"
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
