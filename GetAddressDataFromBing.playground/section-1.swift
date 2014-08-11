// Playground - noun: a place where people can play

import Foundation

var running = false
// had this been a class these will be instance vars instead of globals
var config = NSURLSessionConfiguration.defaultSessionConfiguration()
var session = NSURLSession(configuration: config)

let bingkey="GET_A_MAP_KEY_FROM_BING_and_PUT_IT_HERE"

var address="540%20Evelyn%20Place%20Beverly%20Hills,%20CA%2090210"

var urlstring = "http://dev.virtualearth.net/REST/v1/Locations?q=" + address + "&key=" + bingkey

var url = NSURL(string:urlstring)


typealias ClosureSignatureForPrintingResult = (AnyObject?) -> ()


func parseJson(data: NSData, printResult:ClosureSignatureForPrintingResult) {
    var error: NSError?
    let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error)
    if error != nil {
        println("Error parsing json: \(error)")
        printResult(nil)
    } else {
        printResult(json)
    }
}


func downloadJson(printResult:ClosureSignatureForPrintingResult) {
    
    func myDataTaskCH(let data:NSData!, let response:NSURLResponse!, let error:NSError!)->Void
    {
        
        if let httpResponse = response as? NSHTTPURLResponse {
            switch(httpResponse.statusCode) {
            case 200:
                println("got a 200")
                parseJson(data,printResult)
                
            default:
                println("Got an HTTP \(httpResponse.statusCode)")
            }
        } else {
            println("I don't know how to handle non-http responses")
        }
        running = false;
    }
    
    let task = session.dataTaskWithURL(url, myDataTaskCH)
    task.resume();
    
}

func getSetGo() {
    
    println("starting the get")
    running = true;

    func printResult(jsonResponse:AnyObject?) ->Void {
        println(jsonResponse)
    }
    downloadJson(printResult)
}


getSetGo()

while running {
    println("waiting...")
    sleep(1)
}
