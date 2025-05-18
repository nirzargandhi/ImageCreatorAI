//
//  HomeVC.swift
//  ImageCreatorAI
//
//  Created by Nirzar Gandhi on 16/05/25.
//

import UIKit

class HomeVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var generatedImgView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    
    
    // MARK: - Properties
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    
    fileprivate lazy var bottomConstant: CGFloat = 20
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.setControlsProperty()
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        NC.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NC.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NC.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NC.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setControlsProperty() {
        
        self.view.backgroundColor = .white
        self.view.isOpaque = false
        
        // Generated Image View
        self.generatedImgView.backgroundColor = .black
        self.generatedImgView.contentMode = .scaleAspectFit
        self.generatedImgView.addRadiusWithBorder(radius: 10.0)
        self.generatedImgView.clipsToBounds = true
        
        // StackView
        self.stackView.axis = .horizontal
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        self.stackView.spacing = 15.0
        
        // Description TextField
        self.descTF.backgroundColor = .clear
        self.descTF.textColor = .black
        self.descTF.tintColor = .black
        self.descTF.font = UIFont.systemFont(ofSize: 14)
        self.descTF.setLeftPadding(width: 15)
        self.descTF.setRightPadding(width: 15)
        self.descTF.addRadiusWithBorder(radius: 10.0, border: 1.0)
        self.descTF.layer.borderColor = UIColor.lightGray.cgColor
        self.descTF.delegate = self
        self.descTF.keyboardType = .default
        self.descTF.autocorrectionType = .no
        self.descTF.attributedPlaceholder = NSAttributedString(string: "Enter image description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.descTF.text = ""
        self.descTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        // Submit Buttton
        self.submitBtn.setBackgroundColor(color: .black, forState: .normal)
        self.submitBtn.setTitleColor(.white, for: .normal)
        self.submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        self.submitBtn.titleLabel?.lineBreakMode = .byClipping
        self.submitBtn.addRadiusWithBorder(radius: 10.0)
        self.submitBtn.layer.masksToBounds = true
        self.submitBtn.setTitle("Submit", for: .normal)
    }
}


// MARK: - Call Back
extension HomeVC {
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if SCREENHEIGHT <= 667 {
                return
            }
            
            self.stackViewBottom.constant = keyboardSize.height - getBottomSafeAreaHeight() + self.bottomConstant + (UIDevice.current.hasNotch ? 20 : 0)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        
        if SCREENHEIGHT <= 667 {
            return
        }
        
        self.stackViewBottom.constant = UIDevice.current.hasNotch ? getBottomSafeAreaHeight() : self.bottomConstant
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


// MARK: - HomeVM Delegate
extension HomeVC: HomeVMDelegate {
    
    
    func showLoader() {
        self.showActivityIndicator()
    }
    
    func hideLoader() {
        self.hideActivityIndicator()
    }
    
    func showErrorMsg(message: String?) {
        
        var msgStr = Constants.Generic.SomethingWentWrong
        if let msg = message {
            msgStr = msg
        }
        
        DispatchQueue.main.async {
            self.showAlertMessage(titleStr: "Error", messageStr: msgStr)
        }
    }
    
    func loadImage(imageData: Data?) {
        
        if let data = imageData {
            self.generatedImgView.image = UIImage(data: data)
        }
    }
}


// MARK: - Button Touch & Action
extension HomeVC {
    
    @IBAction func submitBtnTouch(_ sender: UIButton) {
        
        self.descTF.resignFirstResponder()
        self.generatedImgView.image = nil
        
        if let description = self.descTF.text, !description.isEmpty {
            self.viewModel.getHomeData(text: description)
        } else {
            self.showAlertMessage(titleStr: "", messageStr: "Please enter image description")
        }
    }
}


// MARK: - UITextField Delegate
extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc fileprivate func textFieldDidChange() {
        
        if let descText = self.descTF.text, !descText.isEmpty {
            self.descTF.layer.borderColor = UIColor.black.cgColor
        } else {
            self.descTF.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
