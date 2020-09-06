//
//  ViewController.swift
//  UserDefaultsAndKeychainSample
//
//  Created by Daisuke TONOSAKI on 2020/09/06.
//  Copyright © 2020 Daisuke TONOSAKI. All rights reserved.
//

import UIKit

import KeychainAccess


struct SaveData: Codable {
    var text: String = ""
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("load UserDefaults \(loadUserDefaults() ?? [])")
        saveUserDefaults(array: [SaveData(text: "text-userdefaults")])
        
        print("load Keychain \(loadKeychain() ?? [])")
        saveKeychain(array: [SaveData(text: "text-keychain")])
    }


}


// MARK: - KeyChain
extension ViewController {
    
    func loadUserDefaults() -> [SaveData]? {
        guard let array = UserDefaults.standard.array(forKey: "UserDefaultsKey") as? [Data] else {
            return nil
        }

        return array.map { try! JSONDecoder().decode(SaveData.self, from: $0) }
    }
    
    func saveUserDefaults(array: [SaveData]) {
        let data = array.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: "UserDefaultsKey")
    }

    func loadKeychain() -> [SaveData]? {
        let keychain = Keychain()
        
        guard let data = keychain[data: "KeychainKey"] else {
            return nil
        }
        
        let decoder = PropertyListDecoder()
        return try? decoder.decode(Array<SaveData>.self, from: data)
    }
    
    func saveKeychain(array: [SaveData]) {
        let encoder = PropertyListEncoder()
        
        guard let data = try? encoder.encode(array) else {
            return
        }
        
        
        let keychain = Keychain()
        
        keychain[data: "KeychainKey"] = NSData(data: data) as Data
    }
    
}
