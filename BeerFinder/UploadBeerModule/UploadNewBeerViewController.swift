//
//  UploadNewBeerViewController.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit

protocol UploadBeerNetworkingProtocol {
    func uploadBeer(presenter: UIViewController, beer: Beer)
}

protocol ReloadTableViewDelegate: NSObject {
    func reloadTableView(with beer: Beer)
}

class UploadNewBeerViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: UploadBeerNetworkingProtocol? = nil
    
    var beer: Beer?
    
    weak var delegate: ReloadTableViewDelegate?
    
    private var isLastTextfieldTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.layer.cornerRadius = 5
        backButton.layer.cornerRadius = 5
        setupHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let beer = beer else { return }
        delegate?.reloadTableView(with: beer)
    }
    
    private func toggleUploadButton() {
        let shouldBeEnabled = (nameTextField.text != nil && nameTextField.text != "") && (typeTextField.text != nil && typeTextField.text != "") && (descriptionTextField.text != nil && descriptionTextField.text != "")
        uploadButton.backgroundColor = shouldBeEnabled ? .link : .systemGray
        uploadButton.isUserInteractionEnabled = shouldBeEnabled
    }
    
    @IBAction func keyboardWillShow(notification: NSNotification) {
        if isLastTextfieldTapped {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }

    @IBAction func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func didTapUploadButton(_ sender: Any) {
        guard let name = nameTextField.text, let type = typeTextField.text, let description = descriptionTextField.text else { return }
        //id = 0 - no matter what is the id, the server sets it by itself
        let beer = Beer(id: 0, name: name, beerType: type, description: description)
        self.beer = beer
        viewModel?.uploadBeer(presenter: self, beer: beer)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UploadNewBeerViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isLastTextfieldTapped = textField.tag == 3
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        toggleUploadButton()
    }
}
