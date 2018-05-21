//
//  SelectCityViewController.swift


import Foundation
import UIKit

protocol SelectCityDelegate {
    
    func selectedCityDetails(cityDetails: CityModel)
}


class SelectCityViewController: UIViewController {

    // MARK: - Variable declaration -
    var cities = [[String: Any]]()                    // all City data from json file
    var selectCityDelegate: SelectCityDelegate!           // Selected City delegate to pass Data
    var citiesFiltered = [CityModel]()                     // Filterd City data
    var citiesModel = [CityModel]()                        // managed data for City List
    
    // MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Default Class Methods -
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initialSetUp()
        tableView.register(CityNameTableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetUp() {
        
        self.cities = Helper.cities
        self.collectCities()
    }

    /// To move controller To Back Button
    ///
    /// - Parameter sender: Action
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

    
}

// MARK: - Custom Methods -
extension SelectCityViewController {
    
    /// make array of data of cities
    func collectCities() {
        for city in cities  {
            
            citiesModel.append(CityModel.init(cityDetails: city))
        }
    }
    
    /// Check If Status Bar is Active
    ///
    /// - Returns: Bool
    func checkSearchBarActive() -> Bool {
        if searchBar.isFirstResponder && searchBar.text != "" {
            return true
        }else {
            return false
        }
    }
    
    
    /// Filter City Name
    ///
    /// - Parameter searchText: To search text in city name
    func filterCity(_ searchText: String) {
        
        citiesFiltered = citiesModel.filter({(cityModel) -> Bool in
            
            let value = cityModel.cityName.lowercased().contains(searchText.lowercased())
            return value
        })
        
        DispatchQueue.main.async(execute: {() -> Void in

            self.tableView.reloadData()

        })
        
        
    }
    
    func localCity(_ searchText: String) -> CityModel {
        
        let cityModel = citiesModel[0]
        for city in citiesModel {
            
            let cityName = city.cityName
            
            if cityName == searchText {
                
                return city
            }
        }
        return cityModel
    }


}
// MARK: - Search Bar Delegate
extension SelectCityViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterCity(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Table View DataSource
extension SelectCityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if checkSearchBarActive() {
            
            return citiesFiltered.count
        }
        return citiesModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkSearchBarActive() {
            
            selectCityDelegate.selectedCityDetails(cityDetails: citiesFiltered[indexPath.row])
            
        } else {
            
            selectCityDelegate.selectedCityDetails(cityDetails: citiesModel[indexPath.row])
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

// MARK: - Table View Delegate
extension SelectCityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CityNameTableViewCell
        
        let cityModel: CityModel
        
        if checkSearchBarActive() {
            
            cityModel = citiesFiltered[indexPath.row]
            
        }else{
            
            cityModel = citiesModel[indexPath.row]
        }
        
        cell.textLabel?.text = cityModel.cityName
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
   
    
}
