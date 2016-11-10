//
//  String.swift
//  Munchkin
//
//  Created by Kátai Imre on 2016. 10. 18..
//  Copyright © 2016. Munchkin. All rights reserved.
//

import Foundation

extension String {
    
    //! MARK: Email validation
    func isValidEmailAddress() ->Bool {
    
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
        
    }
    
    //! MARK: NSLocalizedString
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localizedWithComment(_ comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}
