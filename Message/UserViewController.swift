//
//  UserViewController.swift
//  Message
//
//  Created by Ren Matsushita on 2018/02/24.
//  Copyright © 2018年 Ren Matsushita. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var userid: UITextField!
    @IBOutlet var password: UITextField!
    
    var saveDatas = save()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func next() {
        saveDatas.saveData.set(username.text, forKey: "username")
        saveDatas.saveData.set(userid.text, forKey: "userid")
        saveDatas.saveData.set(password.text, forKey: "password")
        
        if password == password{
            
        } else {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class save{
    var saveData: UserDefaults = UserDefaults.standard
}

