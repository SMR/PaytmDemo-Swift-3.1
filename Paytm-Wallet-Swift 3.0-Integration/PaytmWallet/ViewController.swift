//
//  ViewController.swift
//  PaytmWallet
//
//  Created by Samar on 22/03/16.
//  Copyright © 2016 isparshIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PGTransactionDelegate {

    @IBOutlet var btn_testPayment: UIButton!
     let function = CommonFunctions()
    var txnID: String!
    var order_id: String!
    var Refund: String!
    
    class func generateOrderIDWithPrefix(_ prefix: String) -> String {
        
        srandom(UInt32(time(nil)))
        
        let randomNo: Int = Int(arc4random_uniform(UInt32(6)))//just randomizing the number
        let orderID: String = "\(prefix)\(randomNo)"
        return orderID
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btn_testPayment.addTarget(self, action: #selector(ViewController.Pay_btn_Action(_:)), for: UIControlEvents.touchUpInside)
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showController(_ controller: PGTransactionViewController) {
        
        if self.navigationController != nil {
            self.navigationController!.pushViewController(controller, animated: true)
        }
        else {
            self.present(controller, animated: true, completion: {() -> Void in
            })
        }
    }
    
    func removeController(_ controller: PGTransactionViewController) {
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        }
        else {
            controller.dismiss(animated: true, completion: {() -> Void in
            })
        }
    }
    
    func Pay_btn_Action(_ sender:UIButton!) {
        
        //Step 1: Create a default merchant config object
        let mc: PGMerchantConfiguration = PGMerchantConfiguration.default()
        
       //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls        
        
        mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
        mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        
        //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
        var orderDict: [AnyHashable: Any] = NSMutableDictionary() as! [AnyHashable: Any]
        
        orderDict["MID"] = "WorldP64425807474247"
         //Merchant configuration in the order object
        orderDict["CHANNEL_ID"] = "WAP"
        orderDict["INDUSTRY_TYPE_ID"] = "Retail"
        orderDict["WEBSITE"] = "worldpressplg"
         //Order configuration in the order object
        orderDict["TXN_AMOUNT"] = "5"
        orderDict["ORDER_ID"] = ViewController.generateOrderIDWithPrefix("")
        orderDict["REQUEST_TYPE"] = "DEFAULT"
        orderDict["CUST_ID"] = "1234567890"
        
        let order: PGOrder = PGOrder(params: orderDict)
        
        //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
        //PGTransactionViewController and set the serverType to eServerTypeProduction
        PGServerEnvironment.selectServerDialog(self.view, completionHandler: {(type: ServerType) -> Void in
            
            let txnController = PGTransactionViewController.init(transactionFor: order)
            
            
            if type != eServerTypeNone {
                txnController?.serverType = type
                txnController?.merchant = mc
                txnController?.delegate = self
                self.showController(txnController!)
            }
        })
        
        
    }
    
    // MARK: Delegate methods of Payment SDK.
    func didSucceedTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        
       // After Successful Payment
        
        print("ViewController::didSucceedTransactionresponse= %@", response)
        let msg: String = "Your order was completed successfully.\n Rs. \(response["TXNAMOUNT"]!)"
       
        
        self.function.alert_for("Thank You for Payment", message: msg)
        self.removeController(controller)
        
        
    }
    
    func didFailTransaction(_ controller: PGTransactionViewController, error: Error, response: [AnyHashable: Any]) {
        // Called when Transation is Failed
        print("ViewController::didFailTransaction error = %@ response= %@", error, response)
        
        if response.count == 0 {
            
            self.function.alert_for(error.localizedDescription, message: response.description)
            
        }
        else if error != nil {
            
            self.function.alert_for("Error", message: error.localizedDescription)
            
            
        }
        
        self.removeController(controller)
        
    }
    
    func didCancelTransaction(_ controller: PGTransactionViewController, error: Error, response: [AnyHashable: Any]) {
        
        //Cal when Process is Canceled
        var msg: String? = nil
        
        if error != nil {
            
            msg = String(format: "Successful")
        }
        else {
            msg = String(format: "UnSuccessful")
        }
        
        
        self.function.alert_for("Transaction Cancel", message: msg!)
        
        self.removeController(controller)
        
    }
    
    func didFinishCASTransaction(_ controller: PGTransactionViewController, response: [AnyHashable: Any]) {
        
        print("ViewController::didFinishCASTransaction:response = %@", response);
        
    }


}

