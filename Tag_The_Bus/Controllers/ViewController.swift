//
//  ViewController.swift
//  Tag_The_Bus
//
//  Created by Elyes DOUDECH on 13/04/2018.
//  Copyright © 2018 Elyes DOUDECH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //The table view that will contain the list of stations
    @IBOutlet weak var stationsList: UITableView!
    
    //An array of the stations
    var stations : [BusStation] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        getBusStation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - data Source -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.stationsList.dequeueReusableCell(withIdentifier: "stationNameCell",for: indexPath)
        
        cell.textLabel?.text = self.stations[indexPath.row].streetName;
        return cell;
    }
    
    
    /// This function will get the list of stations
    func getBusStation(){
        let getStationsUrl = "http://barcelonaapi.marcpous.com/bus/nearstation/latlon/41.3985182/2.1917991/1.json"
         guard let url = URL(string: getStationsUrl) else
         {
             print("Error: cannot create URL");
             return;
         }
         var urlRequest = URLRequest(url: url);
         urlRequest.httpMethod = "GET";
         let config = URLSessionConfiguration.default;
         let session = URLSession(configuration: config,delegate: nil, delegateQueue: OperationQueue.main)
         
         let task = session.dataTask(with: urlRequest , completionHandler: {(data,response,error) in
             guard let responseData = data else {
                 print("Error: did not receive data");
                 return;
             }
             guard error == nil else {
                 print("errir calling GET on http://barcelonaapi.marcpous.com");
                 print(error as Any);
                 return
             }
         
             let post: NSDictionary;
             do
             {
             
             post = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as! NSDictionary
             }
             catch {
                 print("error trying to convert data to JSON")
                 print(error)
                 return
             }
            
             if let dataStation = post["data"] as? NSDictionary{
                 if let stations = dataStation["nearstations"] as? [NSDictionary]{
                 for station in stations {
                     let streetName : String;
                    
                    
                     if let nameSation = station["street_name"] as? String{
                        streetName = nameSation;
                     }
                     else
                     {
                        streetName = "";
                     }
                    
                    
                    
                        self.stations.append(BusStation(streetName: streetName))
                    
                 
                 }
                 
                    self.stationsList.reloadData();
                 }
             }
            
             })
             task.resume();
    }
    
    
    let stationImageSeg = "stationImagies"
    
    //After clicking on a station name, the page which contains the image wil be displayed, we pass to the next page the name of the station
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.stationImageSeg
        {
            if let indexPath = self.stationsList.indexPathForSelectedRow
            {
                let stationPhotoListNavigationController = segue.destination as! UINavigationController
                let stationPhotoListViewController = stationPhotoListNavigationController.topViewController as! StationPhotoListViewController
                stationPhotoListViewController.stationName = self.stations[indexPath.row].streetName
                self.stationsList.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    


}

