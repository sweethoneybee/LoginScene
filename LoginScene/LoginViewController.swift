//
//  ViewController.swift
//  LoginScene
//
//  Created by 정성훈 on 2021/04/12.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    private var keyboardShown: Bool = false;
    private var logoInvisible: Bool = false;
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userIdLabelTop: NSLayoutConstraint!
    @IBOutlet weak var versionInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object:     nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        let contentViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapContentView))
        
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(contentViewTapRecognizer)
        
        self.userIdTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // setupUI()
    }

    // func setupUI() {}
    
    // MARK:- Keyboard
    // Show
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrameBegin = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
        
        if !self.keyboardShown {
            let distanceFromBottom = self.view.frame.height - self.LoginButton.frame.maxY
            if distanceFromBottom <= keyboardFrameBeginRect.size.height + 90 {
                animateUI(keyboardFrameBeginRect.size.height)
            }
        }
        self.keyboardShown = true
    }
    
    // Hide
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.keyboardShown && logoInvisible {
            animateUI(0)
        }
        self.keyboardShown = false
    }
    
    // Disable
    @objc func tapContentView() {
        if self.keyboardShown == true {
            self.view.endEditing(true)
        }
    }
    
    func animateUI(_ scrollValue: CGFloat) {
        self.view.layoutIfNeeded()
        self.scrollViewBottom.constant = scrollValue
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.userIdLabelTop.constant = !self.keyboardShown ? 23 : 56
            self.view.layoutIfNeeded()
            self.versionInfoLabel.alpha = self.keyboardShown ? 1 : 0
        }
        animator.startAnimation()
        logoInvisible = !logoInvisible
    }
    
    // MARK:- IBAction
    @IBAction func didTapLoginButton() {
        self.login()
    }
    
    // MARK:- Functions
    func login() {
        let alert = UIAlertController(title: nil, message: "로그인버튼누름", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userIdTextField {
            textField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.login()
        }
        
        return true
    }
}

