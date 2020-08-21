
import UIKit
import CoreLocation



class WeatherViewController: UIViewController{
    var lat: Double?
    var lon: Double?
    let locationManager = CLLocationManager()
    var weatherManager = WeatherRequestManager()
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func getLocationButtonPressed(_ sender: UIButton) {
//        weatherManager.fetchWeather(lat : self.lat!, lon : self.lon!)
        locationManager.requestLocation()
    }
    

    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
           locationManager.stopUpdatingLocation()
           lat = Double(location.coordinate.latitude)
           lon = Double(location.coordinate.longitude)
            
            weatherManager.fetchWeather(lat : self.lat!, lon : self.lon!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather : WeatherModel) {
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.conditionImageView.image = UIImage(systemName: weather.condition)
               self.cityLabel.text = weather.cityName
        
           }
           
    
    
       }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate {
    
        @IBAction func searchButtonPressed(_ sender: UIButton) {
    //        print(searchTextField.text!)
            searchTextField.endEditing(true)
        }
        
    
        //makes sure pressing the go button on keyboard behaves same as pressing the onscreen button
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //         print(searchTextField.text!)
            searchTextField.endEditing(true)
            return true
        }
        
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if searchTextField.text != "" {
                return true
            }else {
                searchTextField.placeholder = "Enter A Location"
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            //use the text to do whatever here
            if let cityName = searchTextField.text {
            weatherManager.fetchWeather(city: cityName)
            }
            searchTextField.text = " "
        }
        
       
        
    
}


// d925ad15722d9dc510882710c9f6554e API Key
