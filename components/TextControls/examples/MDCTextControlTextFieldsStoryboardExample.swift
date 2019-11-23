// Copyright 2019-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import UIKit

final class MDCTextControlTextFieldsStoryboardExample: UIViewController {
  
  @IBOutlet weak var filledTextField: MDCFilledTextField!
  @IBOutlet weak var outlinedTextField: MDCOutlinedTextField!

  @objc var containerScheme: MDCContainerScheming = MDCContainerScheme()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerKeyboardNotifications()
    setUpTextFields()
  }
  
  func setUpTextFields() {
    filledTextField.label.text = "label text"
    filledTextField.placeholder = "placeholder text"
    filledTextField.applyTheme(withScheme: containerScheme)
    
    outlinedTextField.label.text = "label text"
    outlinedTextField.placeholder = "placeholder text"
    outlinedTextField.applyTheme(withScheme: containerScheme)
  }
}

extension MDCTextControlTextFieldsStoryboardExample: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return false
  }
}

extension MDCTextControlTextFieldsStoryboardExample: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    print(textView.text)
  }
}

// MARK: - Keyboard Handling

extension MDCTextControlTextFieldsStoryboardExample {
  func registerKeyboardNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillShow(notif:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillHide(notif:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillShow(notif:)),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil)
  }
  
  @objc func keyboardWillShow(notif: Notification) {
    guard let _ = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }
  }
  
  @objc func keyboardWillHide(notif: Notification) {
  }
}

// MARK: - Status Bar Style

extension MDCTextControlTextFieldsStoryboardExample {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

// MARK: - CatalogByConvention

extension MDCTextControlTextFieldsStoryboardExample {
  @objc class func catalogMetadata() -> [String: Any] {
    return [
      "breadcrumbs": ["Text Controls", "MDCTextControl TextFields (Storyboard)"],
      "primaryDemo": false,
      "presentable": false,
      "storyboardName": "MDCTextControlTextFieldsStoryboardExample"
    ]
  }
}

