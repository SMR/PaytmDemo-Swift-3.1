//
//  TurfCommonFunctions.swift
//  Turf
//
//  Created by Samar on 22/03/16.
//  Copyright © 2016 isparshIT. All rights reserved.
//
import UIKit
import Foundation
import SystemConfiguration

class CommonFunctions: NSObject {
    
    func alert_for(_ title: String!, message: String!) {
        
        let alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.delegate = self
        alertView.addButton(withTitle: "OK")
        alertView.show()
    }
    
    func bottom_border(_ view: UIView!, table_view: UITableView!, cell: UITableViewCell) {
        
        let border_width = view.frame.size.width
        let view1 = UIView(frame: CGRect(x: 0, y: table_view.rowHeight - 1, width: border_width, height: 0.3))
        view1.backgroundColor = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        cell.addSubview(view1)
    }

}



open class CheckNetwork {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
}


/* For Swift 3.0
 guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
 $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
 zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
 } ) else {
 return false
 }
*/
