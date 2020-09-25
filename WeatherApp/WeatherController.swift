//
//  WeatherController.swift
//  WeatherApp
//
//  Created by Justin Chester on 2020-08-02.
//  Copyright © 2020 Justin Chester. All rights reserved.
//

import Foundation

class WeatherController {
    weak var delegate: WeatherControllerDelegate?

    struct Request : Decodable {
        let type : String?
        let query : String?
        let language : String?
        let unit : String?
    }
    
    struct Location : Decodable {
        let name : String?
        let country : String?
        let region : String?
        let lat : String?
        let lon : String?
        let timezone_id : String?
        let localtime : String?
        let localtime_epoch : Int?
        let utc_offset : String?
    }

    struct Current : Decodable {
        let observation_time : String?
        var temperature : Int? 
        let weather_code : Int?
        let weather_icons : [String?]
        let weather_descriptions : [String?]
        let wind_speed : Int?
        let wind_degree : Int?
        let wind_dir : String?
        let pressure : Int?
        let precip : Double?
        let humidity : Int?
        let cloudcover : Int?
        let feelslike : Int?
        let uv_index : Int?
        let visibility : Int?
    }
    
    struct Weather : Decodable {
        let request : Request?
        let location : Location?
        var current : Current?
    }
    
    var weatherAtUserLocation: Weather?
    
    var temperature: Int = 0 {
        didSet {
            self.weatherAtUserLocation?.current?.temperature = temperature
            delegate?.updateTemperatureLabel("\(temperature)°C")
        }
    }
    
    init(_ weatherString: String) {
        let formattedQueryString = weatherString.replacingOccurrences(of: " ", with: "%20")
        self.getWeatherData(formattedQueryString)
    }

    func getWeatherData(_ queryParameters: String) {
        //Build query string with user's location
        let jsonURLString = "http://api.weatherstack.com/current?access_key=\(getApiKey())&query=\(queryParameters)"
        // make URL
        guard let url = URL(string: jsonURLString) else { return }
        // start shared URL session
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check for error
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }
            do {
                //Decode JSON response into Swift object
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                print(weather)
                self.weatherAtUserLocation = weather
                // TEMPORARY just using the temperature for UI, add rest of details to a UITableView later
                self.temperature = (weather.current?.temperature) ?? 0

            } catch let err {
                print ("Json Err", err)
            }
            //resume() starts the session
        }.resume()
    }
    
    func handleClientError(_ error: Error) {
        //TODO: Actually handle client error
        print(error)
    }
    
    func handleServerError(_ response: URLResponse) {
        //TODO: Actually handle severe error
        print(response)
    }
    
    func getApiKey() -> String {
        //Have to figure out a more secure way to store this key
        return "df2a9476d71406b71f81de4ac98c1f23"
    }
}

protocol WeatherControllerDelegate: AnyObject {
    func updateTemperatureLabel(_ temperature: String)
}
