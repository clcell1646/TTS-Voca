//
//  LoginVC.swift
//  TTS Voca
//
//  Created by 정지환 on 18/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import FBSDKLoginKit


class LoginVC: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var ppButton: UIButton!
    
    
    let userDB = UserDB.getInstance
    var loginDelegate: LoginDelegate!
    
    @IBOutlet weak var GIDButtonwidth: NSLayoutConstraint!
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = "Login".localized
        cancelButton.title = "Done".localized
        ppButton.setTitle("Privacy Policy".localized, for: .normal)
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        fbLoginButton.permissions = [ "email" ]
        fbLoginButton.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        // 구글, 페이스북 로그인 버튼 길이 화면 가로 길이의 7 / 10으로 설정
        let buttonWidth = view.bounds.width * 7 / 10
        GIDButtonwidth.constant = buttonWidth
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        // 아래의 검증코드는 앱 수준 사용 제한의 gr:get:User 카운트를 증가시킨다. 하루 200회 제한이므로 그냥 빼자...
//        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(large)"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    if (error == nil)
                    {
                        //everything works print the user data
                        //                        print(result!)
                        if let data = result as? NSDictionary
                        {
                            let id = "fb" + (data.object(forKey: "id") as? String)!
                            let fullName = (data.object(forKey: "name") as? String)!
                            let profileURL = URL(string: (((data.object(forKey: "picture") as? NSDictionary)?.object(forKey: "data") as? NSDictionary)?.object(forKey: "url") as? String)!)!
                            
                            
                            self.userDB.setOfferEnterprise(offerEnterprise: "Facebook")
                            self.loginSuccessWith(email: id, fullName: fullName, profileURL: profileURL)
                        }
                    }
            })
//        }
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // 로그아웃 버튼을 눌러서 로그아웃 할 때만 호출되기에 작동하지 않음.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        let email = user.profile.email
        let fullName = user.profile.name
        let profileURL = user.profile.imageURL(withDimension: 100)
        
        userDB.setOfferEnterprise(offerEnterprise: "Google")
        loginSuccessWith(email: email!, fullName: fullName!, profileURL: profileURL!)
        
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func loginSuccessWith(email: String, fullName: String, profileURL: URL) {
        // Processing Email
        userDB.setEmail(email: email)
        
        let hausDAO = HausDAO()
        hausDAO.updateUUID()
//        print("updateUUIDResult: \(hausDAO.updateUUID())") // unused 나옴.
        
        var slotCount = hausDAO.getSlot(email: email, fullName: fullName, profileURL: profileURL)
        if(slotCount == -1) { // DB 접속 실패.
            slotCount = 10
        }
        
        userDB.setSlotCount(slotCount: slotCount)

        userDB.setName(name: fullName)
        
        loginDelegate.loginSuccess()
        self.dismiss(animated: true, completion: nil)
        
        downloadImage(from: profileURL)
    }
    
    func downloadImage(from url: URL) {
        let semaphore = DispatchSemaphore(value: 0)
        var imageData: Data?
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                semaphore.signal()
                return
            }
            imageData = data
            semaphore.signal()
            
        }
        semaphore.wait()
        
        if let data = imageData {
            self.userDB.setProfileData(profileImage: data)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func openPrivacyPolicy(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://www.cloudvoca.co.kr/HausPrivacyPolicy.do")!, options: [:], completionHandler: nil)
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
