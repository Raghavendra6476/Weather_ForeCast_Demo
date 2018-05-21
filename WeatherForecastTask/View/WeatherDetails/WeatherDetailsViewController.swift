//
//  ViewController.swift
//  WeatherForecastTask
//
//  Created by 3Embed on 19/05/18.
//  Copyright © 2018 3Embed. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherDetailsViewController: UIViewController {
    
    
    /// RefreshButton on top right of the screen, used to refresh the current city weather details
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    /// Location Name Label used to show the selected city name
    @IBOutlet weak var locationNameLabel: UILabel!
    
    /// Temperature Label used to show the Temperature in city
    @IBOutlet weak var temperatureLabel: UILabel!
    
    /// Description Label used to show the Weather Description
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// Description Label used to show the Temperature in city
    @IBOutlet weak var tempLabel: UILabel!
    
     /// Wind Speed Label used to show the Weather wind speed
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    /// Humidity Label used to show the Weather Humidity
    @IBOutlet weak var humidityLabel: UILabel!
    
    /// Pressure Label used to show the Weather Pressure
    @IBOutlet weak var pressureLabel: UILabel!
    
    /// Wheather ImageView used to show the current weather in image format
    @IBOutlet weak var weatherImage: UIImageView!
    
    /// Day1 Button used to show the First day weather details
    @IBOutlet weak var day1Button: UIButton!
    
    /// Day2 Button used to show the Second day weather details
    @IBOutlet weak var day2Button: UIButton!
    
    /// Day3 Button used to show the Third day weather details
    @IBOutlet weak var day3Button: UIButton!
    
    /// Day4 Button used to Show the Fourth day weather details
    @IBOutlet weak var day4Button: UIButton!
    
    /// Day5 Button used to Show the Fifth day weather details
    @IBOutlet weak var day5Button: UIButton!
    
    /// Select City Button used to Filter the city
    @IBOutlet weak var selectCityButton: UIButton!
    
    
    /// Object of WeatherDetailsViewModel class
    let weatherDetailsViewModel = WeatherDetailsViewModel()
    
    /// Used to maintain the Currently Selected City Id Details
    var selectedCityId:Int32 = 0
    
    /// used to maintain the selected city forecast details
    var arrayOfForeCastModels = [ForeCastModel]()
    
    /// Used to maintain the Currently Selected DayId Details
    var selectedDayId = 0
    
    var locationManager = LocationManager.sharedInstance()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.checkForCallWeatherDetailServiceForCurrentLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.locationManager.delegate = self
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        
        self.locationManager.delegate = nil
    }
    
    /// This method is used to show all initial empty details & disable the days buttons
    func showIntialDetails() {
    
        self.locationNameLabel.text = "--"
        self.descriptionLabel.text = "--"
        self.humidityLabel.text = "--"
        self.pressureLabel.text = "--"
        self.windSpeedLabel.text = "--"
        self.temperatureLabel.text = "--"
        
        self.day1Button.setTitle("--", for: UIControlState.normal)
        self.day2Button.setTitle("--", for: UIControlState.normal)
        self.day3Button.setTitle("--", for: UIControlState.normal)
        self.day4Button.setTitle("--", for: UIControlState.normal)
        self.day5Button.setTitle("--", for: UIControlState.normal)
        
        self.enableOrDisableDaysButtons(boolValue: false)
    }
    
    
    /// This method is used to enable or disable the day buttons
    ///
    /// - Parameter boolValue: boolean value for enable or disable the day buttons
    func enableOrDisableDaysButtons(boolValue:Bool) {
        
        self.day1Button.isUserInteractionEnabled = boolValue
        self.day2Button.isUserInteractionEnabled = boolValue
        self.day3Button.isUserInteractionEnabled = boolValue
        self.day4Button.isUserInteractionEnabled = boolValue
        self.day5Button.isUserInteractionEnabled = boolValue
    }
    
    
    /// This method is used to show the days button titles
    func showDaysButtonTitles() {
        
        if arrayOfForeCastModels.count >= 5 {//5 Days Results
            
            day1Button.setTitle(arrayOfForeCastModels[0].dayTitle, for: UIControlState.normal)
            day2Button.setTitle(arrayOfForeCastModels[1].dayTitle, for: UIControlState.normal)
            day3Button.setTitle(arrayOfForeCastModels[2].dayTitle, for: UIControlState.normal)
            day4Button.setTitle(arrayOfForeCastModels[3].dayTitle, for: UIControlState.normal)
            day5Button.setTitle(arrayOfForeCastModels[5].dayTitle, for: UIControlState.normal)
            
            self.enableOrDisableDaysButtons(boolValue: true)
            
        }
    }
    
    
    /// This method is used to show city weather details
    func showWeatherDetails() {
        
        let foreCastModel = arrayOfForeCastModels[selectedDayId]
        
        self.locationNameLabel.text = Helper.getCityNameByCityId(cityId: selectedCityId)
        self.descriptionLabel.text = foreCastModel.weatherDescription
        self.humidityLabel.text = Helper.getValueByItsExtension(value: foreCastModel.humidity, extensionValue: "%")
        self.pressureLabel.text = Helper.getValueByItsExtension(value: foreCastModel.pressure, extensionValue: "hPA")
        self.windSpeedLabel.text = Helper.getValueByItsExtension(value: foreCastModel.windSpeed, extensionValue: "m/s")
        self.temperatureLabel.text = Helper.getValueByItsExtension(value: foreCastModel.temperature, extensionValue: "°C")
        self.tempLabel.text = Helper.getValueByItsExtension(value: foreCastModel.temperature, extensionValue: "°C")
        
        
        self.showWeatherDetailsImageView(imageURL: API.IMAGE_BASE_URL + foreCastModel.weatherImageURL)
    }
    
    
    /// This method is used to download weather description image from server
    ///
    /// - Parameter imageURL: weather image URL link
    func showWeatherDetailsImageView(imageURL:String) {
        
        if !imageURL.isEmpty {
            
            weatherImage.kf.setImage(with: URL(string: imageURL + ".png"),
                                         placeholder:nil,
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in
            },
                                         completionHandler: { image, error, cacheType, imageURL in
                                            
            })
            
        } else {
            
            self.weatherImage.image = UIImage(named: "")
        }
    }
    
    
    
    /// This method to check need to call weather forecast service or fetch prev data from coredata & show weather details for current location
    func checkForCallWeatherDetailServiceForCurrentLocation() {
        
        if UserDefaultsManager.currentCityId > 0 {
            
            //Interacting with coredata to get weather details
            let prevSavedWeatherDetails = CoreDataContextOperationsManager.sharedInstance.fetchParticularCityWeatherDetails(cityId: UserDefaultsManager.currentCityId)
            
            if prevSavedWeatherDetails.count > 0 {
                
                //Show Previous Saved Result in WeatherDetailsVC
                
                if let weatherDetailsData = prevSavedWeatherDetails[0] as? WeatherDetails, let weatherDetails = weatherDetailsData.weatherDetails as? [[String:Any]] {
                    
                    self.arrayOfForeCastModels = weatherDetailsViewModel.parseForeCastResponse(foreCastDetailsResponse: weatherDetails)
                    
                    self.selectedCityId = UserDefaultsManager.currentCityId
                    self.showDaysButtonTitles()
                    self.daysButtonAction(self.day1Button)
                }
                
            } else {
                
                //Show empty details in Weather Details VC
                self.showIntialDetails()
            }
            
            //Calling Weather details service API to get current location weather details
            self.weatherDetailsViewModel.getCurrentCityWeatherDetails { (foreCastModels) in
                
                self.arrayOfForeCastModels = foreCastModels
                self.selectedCityId = UserDefaultsManager.currentCityId
                self.showDaysButtonTitles()
                self.daysButtonAction(self.day1Button)
            }
                
//            if UserDefaultsManager.serviceCalledTimeStamp > 0 {
//
//                if Date().timeIntervalSince(Date.init(timeIntervalSince1970: UserDefaultsManager.serviceCalledTimeStamp)) > 10*60 { //After 10 min
//
//
//                }
//            }
            
        } else {
            
            //Show empty details in Weather Details VC
            self.showIntialDetails()
            
            if locationManager.latitute != 0.0 {
                
                //Calling Weather details service API to get current location weather details
                self.weatherDetailsViewModel.getCurrentCityWeatherDetails { (foreCastModels) in
                    
                    self.arrayOfForeCastModels = foreCastModels
                    self.selectedCityId = UserDefaultsManager.currentCityId
                    self.showDaysButtonTitles()
                    self.daysButtonAction(self.day1Button)
                }
            }
        }
    }
    
    /// This method to check need to call weather forecast service or fetch prev data from coredata & show weather details for selected city
    func checkForCallWeatherDetailServiceForAnyCity(cityId:Int32) {
    
        if cityId > 0 {
            
            //Interacting with coredata to get weather details
            let prevSavedWeatherDetails = CoreDataContextOperationsManager.sharedInstance.fetchParticularCityWeatherDetails(cityId: cityId)
            
            if prevSavedWeatherDetails.count > 0 {
                
                //Show Previous Saved Result in WeatherDetailsVC
                
                if let weatherDetailsData = prevSavedWeatherDetails[0] as? WeatherDetails, let weatherDetails = weatherDetailsData.weatherDetails as? [[String:Any]] {
                    
                    self.arrayOfForeCastModels = weatherDetailsViewModel.parseForeCastResponse(foreCastDetailsResponse: weatherDetails)
                    
                    self.selectedCityId = cityId
                    self.showDaysButtonTitles()
                    self.daysButtonAction(self.day1Button)
                }
                
            } else {
                
                //Show empty details in Weather Details VC
                self.showIntialDetails()
            }
            
             //Calling Weather details service API to get selcted city weather details
            self.weatherDetailsViewModel.getAnyCityWeatherDetails(cityId: cityId,
                                                                  completion: { (foreCastModels) in
                
                self.arrayOfForeCastModels = foreCastModels
                
                self.selectedCityId = cityId
                self.showDaysButtonTitles()
                self.daysButtonAction(self.day1Button)
                
            })
            
//            if Date().timeIntervalSince(Date.init(timeIntervalSince1970: UserDefaultsManager.serviceCalledTimeStamp)) > 10*60 { //After 10 min
//
//
//            }
        }
    }
    
    
    /// Select City Button Action Method, used to show select city view controller
    ///
    /// - Parameter sender: Select City Button
    @IBAction func selectCityButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: SegueIdetifiers.WeatherDetailsToCitiesVC, sender: nil)
    }
    
    
    /// Refresh Right Bar Button, Used to Refresh the current location weather details
    ///
    /// - Parameter sender: refresh button
    @IBAction func refreshBarbuttonAction(_ sender: Any) {
        
        self.checkForCallWeatherDetailServiceForCurrentLocation()
    }
    
    
    /// Days Button Action, used to show selected day weather details
    ///
    /// - Parameter sender: Day buttons
    @IBAction func daysButtonAction(_ sender: Any) {
        
        if let selectedButton = sender as? UIButton {
            
            self.day1Button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.day2Button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.day3Button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.day4Button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.day5Button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            
            
            self.selectedDayId = selectedButton.tag
            
            switch selectedButton.tag {
                
                case 1:
                    day1Button.backgroundColor = #colorLiteral(red: 0.1541004777, green: 0.4130676389, blue: 0.6906326413, alpha: 1)
                
                case 2:
                    day2Button.backgroundColor = #colorLiteral(red: 0.1541004777, green: 0.4130676389, blue: 0.6906326413, alpha: 1)
                
                case 3:
                    day3Button.backgroundColor = #colorLiteral(red: 0.1541004777, green: 0.4130676389, blue: 0.6906326413, alpha: 1)
                
                case 4:
                    day4Button.backgroundColor = #colorLiteral(red: 0.1541004777, green: 0.4130676389, blue: 0.6906326413, alpha: 1)
                
                case 5:
                    day5Button.backgroundColor = #colorLiteral(red: 0.1541004777, green: 0.4130676389, blue: 0.6906326413, alpha: 1)
                
                default:
                    break
                
            }
            
            self.showWeatherDetails()
        }
        
        
    }
    
    /// Method to segue one controller to another
    ///
    /// - Parameters:
    ///   - segue: segue Information
    ///   - sender: Any parameter sends in segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdetifiers.WeatherDetailsToCitiesVC {
            
            if let cityListVC = segue.destination as? SelectCityViewController {
                
                cityListVC.selectCityDelegate = self//Setting delegate
            }
        }
    }
    
}

extension WeatherDetailsViewController:LocationManagerDelegate {
    
    func didChangedCurrentCity(location: LocationManager) {
        
        //Calling Weather details service API to get current location weather details
        self.weatherDetailsViewModel.getCurrentCityWeatherDetails { (foreCastModels) in
            
            self.arrayOfForeCastModels = foreCastModels
            self.selectedCityId = UserDefaultsManager.currentCityId
            self.showDaysButtonTitles()
            self.daysButtonAction(self.day1Button)
        }
    }
}

extension WeatherDetailsViewController:SelectCityDelegate {
    
    /// Selected City Delegate Method
    ///
    /// - Parameter cityDetails: contains selected city details
    func selectedCityDetails(cityDetails: CityModel) {
        
        selectedCityId = cityDetails.cityId
        
        //Make the Service Call With the selected city Id
        self.checkForCallWeatherDetailServiceForAnyCity(cityId: cityDetails.cityId)
        self.locationNameLabel.text = cityDetails.cityName
        

    }
}

