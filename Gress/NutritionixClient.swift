//
//  NutritionixClient.swift
//  Gress
//
//  Created by Umar Qattan on 9/17/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class NutritionixClient  {
    
    /**
        MARK: Example URL Request looks like the following:
                
              https://api.nutritionix.com/v1_1/search/tofu?results=0:30&cal_min=0&cal_max=1000&fields=item_name,item_id,nf_serving_size_unit,nf_servings_per_container,nf_serving_weight_grams,nf_calories,nf_total_fat,nf_total_carbohydrate,nf_protein&appId=7f0ac3a0&appKey=19297e51b9bf1b5d8d40f88b18de1dcc
    **/
    
    static let baseURL = "https://api.nutritionix.com/v1_1/"

    struct API {
        struct Keys {
            static let API_KEY = "appKey"
            static let APP_ID = "appId"
        }
        
        struct Values {
            static let API_KEY = "19297e51b9bf1b5d8d40f88b18de1dcc"
            static let APP_ID = "7f0ac3a0"
        }
    }
    
    struct Methods {
        
        static let Search = "search/"
        static let Brand = "brand/"
        static let Item = "item/"
    }
    
    struct Search {
        
        static let RESULTS = "results" // 0:10 for first 10 items (non-inclusive)
        static let PHRASE = "phrase" // tofu
        static let CAL_MIN = "cal_min" // 0
        static let CAL_MAX = "cal_max" // 1000
        static let FIELDS = "fields" // item_name,item_id,nf_serving_weight_grams,...
        
        struct Fields {
            static let ITEM_NAME = "item_name"
            static let ITEM_ID = "item_id"
            static let SERVING_WEIGHT_GRAMS = "nf_serving_weight_grams"
            static let SERVINGS_PER_CONTAINER = "nf_servings_per_container"
            static let SERVING_SIZE_QUANTITY = "nf_serving_size_qty"
            static let SERVING_SIZE_UNIT = "nf_serving_size_unit"
            static let CALORIES = "nf_calories"
            static let TOTAL_FAT = "nf_total_fat"
            static let TOTAL_CARBOHYDRATE = "nf_total_carbohydrate"
            static let TOTAL_PROTEIN = "nf_protein"
        }
        
    }
    
    struct JSON {
        struct Keys {
            static let HITS = "hits"
            static let FIELDS = "fields"
        }
    }
    
    class func buildSearchURL(phrase:String, results:Int) -> NSURL {
        let baseSearchURL = baseURL + Methods.Search + phrase + "?"
        let tailSearchURL = "&".join(["\(Search.RESULTS)=\(getResults(results))",
                             "\(Search.FIELDS)=\(getFields())",
                             "\(API.Keys.APP_ID)=\(API.Values.APP_ID)",
                             "\(API.Keys.API_KEY)=\(API.Values.API_KEY)"
                        ])
        let searchURLString = baseSearchURL + tailSearchURL
        println(searchURLString)
        let searchURL = NSURL(string: searchURLString)!
        return searchURL
    }
    
    class func buildSearchURLSessionDataTask(phrase:String, results:Int, completionHandler: (data: NSData?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = buildSearchURL(phrase, results: results)
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                println("Could not complete request due to the following: \(error.localizedDescription)")
                completionHandler(data: nil, error: downloadError)
            } else {
                println("Successfully completed request!")
                completionHandler(data: data, error: nil)
            }
        }
        task.resume()
        return task
    }
    
    func getFoodLogEntries(phrase: String, results: Int, completionHandler: (foodLogEntries : [FoodLogEntry]?, success : Bool, error : String?) -> Void) {
        var task = NutritionixClient.buildSearchURLSessionDataTask(phrase, results: results) { data, downloadError in
            if let error = downloadError {
                completionHandler(foodLogEntries: nil, success: false, error: "\(error.localizedDescription)")
            } else {
                var foodLogEntries:[FoodLogEntry] = []
                if let response = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
                    if let results = response[JSON.Keys.HITS] as? [[String : AnyObject]] {
                        for result in results {
                            if let foodEntry = result[JSON.Keys.FIELDS] as? [String : AnyObject] {
                                var entry = self.buildFoodLogEntry(foodEntry)
                                foodLogEntries.append(entry)
                            }
                        }
                        completionHandler(foodLogEntries: foodLogEntries, success: true, error: nil)
                    } else {
                        completionHandler(foodLogEntries: nil, success: false, error: "Could not complete food entry download request.")
                    }
                } else {
                    completionHandler(foodLogEntries: nil, success: false, error: "Could not format JSON response.")
                }
            }
        }
    }
    
    func buildFoodLogEntry(result : [String : AnyObject]?) -> FoodLogEntry {
        return FoodLogEntry(dictionary: result!, context: self.sharedContext)
    }
    
    
    class func getResults(numberOfResults: Int) -> String {
        return "0:\(numberOfResults)"
    }
    
    class func getFields() -> String {
        var fields = [
            Search.Fields.ITEM_NAME,
            Search.Fields.ITEM_ID,
            Search.Fields.SERVING_WEIGHT_GRAMS,
            Search.Fields.SERVINGS_PER_CONTAINER,
            Search.Fields.SERVING_SIZE_QUANTITY,
            Search.Fields.SERVING_SIZE_UNIT,
            Search.Fields.CALORIES,
            Search.Fields.TOTAL_FAT,
            Search.Fields.TOTAL_CARBOHYDRATE,
            Search.Fields.TOTAL_PROTEIN
        ]
        let fieldsString = ",".join(fields)
        return fieldsString
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
}