//
//  SavedWeatherReportsViewController.swift
//  assignment_3
//
//  Created by Newman Law on 2022-03-20.
//

import UIKit

class SavedWeatherReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var savedWeatherReport:[WeatherReport] = []
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self

        // Do any additional setup after loading the view.
        
        for item in savedWeatherReport{
            print(item.city)
            print(item.temp_c)
            print(item.wind_dir)
            print(item.wind_kph)
            print(item.time_of_Report)
            print("------------")
        }
    }
    

    // Define the total number of rows you want to display in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWeatherReport.count
    }

    
    // Controls the DATA that is display in each row of the tableview
    // This function is called once per row in the tableview
    // It will draw the data you want to display in the corresponding row   //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for:indexPath) as! SavedWeatherTableViewCell
        
        let currReport:WeatherReport = savedWeatherReport[indexPath.row]
        cell.lblCity_Time.text = "\(currReport.city) at \(currReport.time_of_Report)"
        cell.lblWindInfo.text = "Wind: \(currReport.wind_kph)kph from \(currReport.wind_dir)"
        cell.lblSavedTemp.text = "\(currReport.temp_c)°C"
        
        return cell
        
    }
   
    // The total number of sections you have in your table view
    // Most table views only have 1 section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
}
