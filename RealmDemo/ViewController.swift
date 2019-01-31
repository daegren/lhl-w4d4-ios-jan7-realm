//
//  ViewController.swift
//  RealmDemo
//
//  Created by David Mills on 2019-01-31.
//  Copyright © 2019 David Mills. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var dogs: [Dog] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.dataSource = self
    
    fetchDogs()
  }

  /// Fetch the dogs from the realm database
  private func fetchDogs() {
    let realm = try! Realm()
    let results = realm.objects(Dog.self)
    // Make sure to reset the array to an empty array
    dogs = []

    for dog in results {
      // Results is *not* an array, but it is iteratable, so loop through it and
      // add each element to the backing array
      dogs.append(dog)
    }

    // reload the table view
    tableView.reloadData()
  }

  /// Fetch dogs which are over the age of 4
  private func fetchDogsWithPredicate() {
    let realm = try! Realm()
    let predicate = NSPredicate(format: "age >= 4")
    let results = realm.objects(Dog.self).filter(predicate)
    dogs = []

    for dog in results {
      //      print(#line, dog.name)
      //      print(#line, dog.age)
      dogs.append(dog)
    }

    tableView.reloadData()
  }

  /// Callback used by the AddDogViewController to reload the dogs
  private func saveDog() {
    self.fetchDogs()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addDog" {
      // Make sure we setup the save handler to trigger a re-fetch of the data
      let dvc = segue.destination as! AddDogViewController
      dvc.saveHandler = self.saveDog
    } else if segue.identifier == "editDog" {
      // In edit mode, also set the dog property in the AddDogViewController
      let dvc = segue.destination as! AddDogViewController
      dvc.saveHandler = self.saveDog
      let indexPath = tableView.indexPathForSelectedRow!
      dvc.dog = dogs[indexPath.row]
    }
  }
}

/// Extension for ViewController which contains the UITableViewDataSource methods
extension ViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dogs.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dogCell", for: indexPath) as! DogTableViewCell

    let dog = dogs[indexPath.row]

    cell.nameLabel.text = dog.name
    cell.ageLabel.text = String(format: "%ld", dog.age)

    return cell
  }
}

