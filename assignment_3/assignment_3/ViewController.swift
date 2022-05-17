//
//  ViewController.swift
//  assignment_3
//
//  Created by Newman Law on 2022-03-20.
//

import UIKit

//Contains methods and properties that allows us to manage addresses and coordinates
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWindDirection: UILabel!
    
    //Geocoder Object
    let geocoder = CLGeocoder()
    
    // Add ! to basically say it will have a value
    var locationManager:CLLocationManager!
    var deviceLon = 0.0
    var deviceLat = 0.0
    
    var apiKey = "b989b856b1634400ab7195229222003"
    
    // List of weather reports
    var weatherReport:[WeatherReport] = []
    
    
    //OUr JSON data structure:
    struct Response: Codable {
        let location: myLocation
        let current: myCurrent
    }
    
    struct myLocation: Codable {
        let name: String
    }
    
    struct myCurrent: Codable {
        let temp_c: Double
        let wind_kph: Double
        let wind_dir: String
    }
    
    // Our Values to be implemented into a weather report
    var cityName:String = ""
    var temperature:Double = 0.0
    var windCurrent:Double = 0.0
    var windDirection:String = " "
    
    // Weather Report List
    var weatherReportList:[WeatherReport] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Current Weather"
        
        //Make location manager object by intializating it with our CLLocationManager function
        //Following four lines of code will receieve update of our phone's location
        self.locationManager = CLLocationManager()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.locationManager.delegate = self
        
        //Must ask permission from user to see if it's ok to use their location in their app, must first go to info in our folder
        // Must add a Location When In Use
        
        
        // Do any additional setup after loading the view.

        print("Main View has been loaded")
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //CLLocation will provide the geographical location and altitude of the device, also speed and direction of the device if needed as well
        
        //Observe the first item in our array
        //locations.first
        
        
        // Get current position of the device
        // If running emulator, different locations simulations we can add:
        // Click on emulator, go to features > locations > [List of different sims]
        if let currPosition = locations.first {
            deviceLat = currPosition.coordinate.latitude
            deviceLon = currPosition.coordinate.longitude

            let location = CLLocation(latitude: deviceLat, longitude:deviceLon)
            
            self.geocoder.reverseGeocodeLocation(location) {
                (resultsList, error) in
                print("Sent request to geocoding service, waiting for response")
                
                //if unsuccesful response from server
                if(error != nil) {
                    print(error)
                    return
                }
                
                if(resultsList != nil)
                {
                    if(resultsList!.count == 0) {
                        print("No addresses found for this coordinate")
                    }
                    else{
                        print("Address found")
                        let placemark:CLPlacemark = resultsList!.first!
                        print(placemark.locality!)
                        
                        //Replace any white spaces with %20 for api
                        let placeMarkAPI = placemark.locality?.replacingOccurrences(of: " ", with: "%20")
                        print(placeMarkAPI!)
 
                        //Fetch data and represent data as instances of the model class
                        
                        var apiEndpoint = "https://api.weatherapi.com/v1/current.json?key=b989b856b1634400ab7195229222003&q="
                        apiEndpoint.append(placeMarkAPI!)
                        apiEndpoint.append("&aqi=no")
                        print(apiEndpoint)
                        
                        //Convert our apiEndpoint into a URL object
                        guard let apiUrl = URL(string:apiEndpoint) else
                        {
                            print("Could not convert the string endpoint to an URL object")
                            return
                        }
                        
                        print("Entering URL session: ")
                        //fetch the data by using built in class called URLSession
                        // how we fetch our data and wait for response
                        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
                            if let err = error {
                                print("Error occurd while fetching data from api")
                                print(err)
                                return
                            }
                            
                            // what wil we do if everything is ok?
                            // assuming you got JSON data back
                        
                            if let jsonData = data {
                                // represent the data we got back from the api
                                // as an instance for the Model class WeatherReport
                                
                                print(jsonData) //will be printed out as bytes
                               
                                do {
                                    let decoder = JSONDecoder()
                                    let decodedItem:Response = try decoder.decode(Response.self, from: jsonData)
                                    
                                    // First, must use self because it can't see global variables
                                    // Second, we need to use Dispatchqueue because this is a background thread, can't update main thread from the background unless we do function
                                    print(decodedItem.location.name)
                                    
                            
                                    DispatchQueue.main.async{
                                        self.cityName = decodedItem.location.name
                                        self.temperature = decodedItem.current.temp_c
                                        self.windCurrent = decodedItem.current.wind_kph
                                        self.windDirection = decodedItem.current.wind_dir
                                        
                                    
                                        self.lblCity.text = "Current city: " + "\(decodedItem.location.name)"
                                        self.lblTemp.text = "Current temperature (in celsius): " + "\(decodedItem.current.temp_c)"
                                        self.lblWindSpeed.text = "Current wind speed (in kph): " + "\(decodedItem.current.wind_kph)"
                                        self.lblWindDirection.text =  "Current wind direction: " + decodedItem.current.wind_dir
                                    }
                                }
                                catch let error {
                                    print("An error has occurd during JSON decoding")
                                    print(error)
                                }
                            }
                            
                        }.resume()
                    }
                }
            }
        }
    }

    @IBAction func savedReport(_ sender: Any) {
        
        let date = Date()
        let calendar = Calendar.current

        var hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var savedTime = " "
        if(hour>12)
        {
            if(minutes < 10)
            {
                let formatMinutes = "0\(minutes)"
                savedTime = "\(hour):\(minutes)"
            }
            
            hour = hour - 12
            savedTime = "\(hour):\(minutes) pm"
        }
        else{
            if(minutes < 10)
            {
                let formatMinutes = "0\(minutes)"
                savedTime = "\(hour):\(formatMinutes)"
            }
            savedTime = "\(hour):\(minutes) am"
        }
        
        if(minutes < 10)
        {
            let formatMinutes = "0\(minutes)"
            savedTime = "\(hour):\(formatMinutes)"
        }

        
        //Create weather report to push into our weatherReportList
        var weatherReportInput:WeatherReport = WeatherReport(city: cityName, temp_c: temperature, wind_kph: windCurrent, wind_dir: windDirection, time_of_Save: savedTime)

        //Save Weather Report into Weather Report List
        weatherReportList.append(weatherReportInput)

        for item in weatherReportList{
            print(item.city)
            print(item.time_of_Report)
        }

    }
    
    
 
    @IBAction func navigateSecondScreen(_ sender: Any) {
        
        print("Entering to second screen!")
        guard let nextScreen = storyboard?.instantiateViewController(identifier: "SecondScreen")as?SavedWeatherReportsViewController else {
            print("Cannot find next screen")
            return
        }

        nextScreen.savedWeatherReport = weatherReportList
        
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
}

