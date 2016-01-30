//
//  Reachibility.swift
//  webAppliBNP
//
//  Created by Resulis MAC 1 on 17/12/2015.
//  Copyright © 2015 Resulis MAC 1. All rights reserved.
//

import Foundation
public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        do {
            _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        } catch {
            print("Erreur test connexion internet")
        }
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}