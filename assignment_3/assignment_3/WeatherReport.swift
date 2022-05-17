//
//  Weatherreport.swift
//  assignment_3
//
//  Created by Newman Law on 2022-03-20.
//

import Foundation
import CoreLocation

class WeatherReport {
        
    var city:String = "Default City"
    var temp_c:Double = 99.9
    var wind_kph:Double = 99.9
    var wind_dir:String = "Default Direction"
    var time_of_Report:String = " "
    
    enum CodingKeys: String, CodingKey {
        case city="name"
        case temp_c="temp_c"
        case wind_kph="wind_kph"
        case wind_dir = "wind_dir"
    }
        
//    func encode(to encoder:Encoder) throws{
//        //do nothing
//    }
//
//    //implementation of the encode() --> Codable protocol
//    public required init(from decoder:Decoder) throws {
//        // 1. Try to take the api response and convert it to data we can use
//        let response = try decoder.container(keyedBy: CodingKeys.self)
//
//        // 2. extract the relevant keys from that api response
//        self.city = try response.decodeIfPresent(String.self, forKey: .city) ?? "No city exists"
//        self.temp_c = try response.decodeIfPresent(Double.self, forKey: .temp) ?? 0.0
//        self.wind_kph = try response.decodeIfPresent(Double.self, forKey: .windSpeed) ?? 0.0
//        self.wind_dir = try response.decodeIfPresent(String.self, forKey: .windDirection) ?? "No wind direction present"
//    }
    
    init(city: String, temp_c: Double, wind_kph: Double, wind_dir: String, time_of_Save:String)
    {
        self.city = city
        self.temp_c = temp_c
        self.wind_kph = wind_kph
        self.wind_dir = wind_dir
        self.time_of_Report = time_of_Save
    }
}
