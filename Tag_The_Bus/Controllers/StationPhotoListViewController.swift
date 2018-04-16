//
//  StationPhotoListViewController.swift
//  Tag_The_Bus
//
//  Created by Elyes DOUDECH on 13/04/2018.
//  Copyright © 2018 Elyes DOUDECH. All rights reserved.
//

import UIKit
import CoreData


class StationPhotoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate {
    
    //The list of image of the coreesponding station
    @IBOutlet weak var imageStationList: UITableView!
    
    //the name of the station that is passed from the previous page
    var stationName : String = "";
    
    
   
    
    fileprivate lazy var imagesFetched : NSFetchedResultsController<StationImageDTO> =
    {
        // prepare a request
        let request : NSFetchRequest<StationImageDTO> = StationImageDTO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(StationImageDTO.date), ascending: false)]
        request.predicate = NSPredicate(format: "stationName == %@", stationName)
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        if self.stationName != ""
        {
            self.navigationItem.title = stationName
          
            do{
                //We get the list of images
                try self.imagesFetched.performFetch()
            }
            catch let error as NSError
            {
               DialogBoxHelper.alert(view: self, error: error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    //Return back to the list of stations
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    //MARK : - Data source protocol
    
    //Tells if a row is editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Set the delete option of a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    //Returns the number of object that the list contains
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.imagesFetched.sections?[section] else {
            fatalError("Unexpected section number")
        }
        return section.numberOfObjects;
    }
    
    //Configure a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageStationList.dequeueReusableCell(withIdentifier: "imageStationCell", for: indexPath) as! StationImageTableViewCell
        
        let imageStation = self.imagesFetched.object(at: indexPath)
        
        cell.imageTitleLabel.text = imageStation.image
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        let date = dateFormatter.string(from: imageStation.date!)
        cell.imageDateLabel.text = date
        getImage(imageName: imageStation.image!, imageView: cell.stationImage)
        
        return cell;
    }
    
    //MARK: - Action Handler
    
    /// This function will get the image using its title and displays it in an image view
    ///
    /// - Parameters:
    ///   - imageName: The name of the image
    ///   - image: the image view that will contain the image
    func getImage(imageName: String, imageView: UIImageView)
    {
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath)
        {
            imageView.image = UIImage(contentsOfFile: imagePath)
        }
        else
        {
            print("Error!!! no image")
        }
    }
    
    /// This function will be called when the user delete a cell
    ///
    /// - Parameters:
    ///   - action: the action performed to reveal the delete button
    ///   - indexPath: the index of the row to delete
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void
    {
        let imageStation = self.imagesFetched.object(at: indexPath)
        CoreDataManager.context.delete(imageStation)
    }
    
    //MARK: NSFetchResultController delegate protocl
    
    //Called when a cell will be changed
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.imageStationList.beginUpdates()
    }
    
    //Call after a cell is changed
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.imageStationList.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath
            {
                self.imageStationList.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath
            {
                self.imageStationList.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    //This function will be called after the user took a picture; set its title and confirmed, it will add the new picture to the list
    @IBAction func unwindToStationImagesListAfterSavingNewPhoto(segue: UIStoryboardSegue)
    {
        let newImage = segue.source as! TakeNewPhotoViewController
        let imageTitle = newImage.imageTitleTextField.text!
        let date = Date()
        let image = StationImageDTO(context: CoreDataManager.context)
        image.date = date;
        image.image = imageTitle
        image.stationName = self.stationName
    }
    


}
