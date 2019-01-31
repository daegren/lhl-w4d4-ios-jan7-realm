//
//  AddDogViewController.swift
//  RealmDemo
//
//  Created by David Mills on 2019-01-31.
//  Copyright © 2019 David Mills. All rights reserved.
//

import UIKit
import RealmSwift

class AddDogViewController: UIViewController {
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var deleteButton: UIButton!

  var saveHandler: (() -> Void)?
  var dog: Dog?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    // if the dog property is set
    if let dog = self.dog {
      // setup the initial values for the form
      self.nameTextField.text = dog.name
      self.ageTextField.text = String(format: "%ld", dog.age)
      // Change the header to read "Edit Dog"
      self.headerLabel.text = "Edit Dog"
      // Show the delete button
      self.deleteButton.isHidden = false
    } else {
      // Otherwise we're creating a new dog
      // so set the ehader to read "New Dog"
      self.headerLabel.text = "New Dog"
      // and hide the delete button (can't delete something that doesn't exist)
      self.deleteButton.isHidden = true
    }
  }

  /// Save button handler
  @IBAction func save(_ sender: Any) {
    let realm = try! Realm()

    // if we have a dog object
    if let dog = self.dog {
      // Update the model by mutating the changes inside the realm.write block
      try! realm.write {
        dog.name = nameTextField.text!
        dog.age = Int(ageTextField.text!) ?? 0
      }

      // make sure to call the handler (if it's set) to tell the previous view
      // controller to re-fetch and reload the table view
      if let handler = saveHandler {
        handler()
      }
    } else {
      // Otherwise create a new dog object
      let dog = Dog()
      dog.name = nameTextField.text!
      dog.age = Int(ageTextField.text!) ?? 0

      // Add it to the realm database
      try! realm.write {
        realm.add(dog)
      }

      // Have the view controller re-fetch and reload the table view
      if let handler = saveHandler {
        handler()
      }
    }

    dismiss(animated: true, completion: nil)
  }

  /// Cancel handler, just close the modal
  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  /// Delete handler
  @IBAction func deleteTapped(_ sender: Any) {
    // If the dog property has been set
    if let dog = self.dog {
      let realm = try! Realm()

      // Call delete in the realm.write block to remove it from the database
      try! realm.write {
        realm.delete(dog)
      }
    }

    // Call the save handler to re-fetch and reload the table view
    if let handler = saveHandler {
      handler()
    }

    dismiss(animated: true, completion: nil)
  }

}
