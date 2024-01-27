import Flutter
import UIKit
import Xendit


public class XenditIosPlugin: NSObject, FlutterPlugin {
    private var flutterViewController: FlutterViewController?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xendit_ios", binaryMessenger: registrar.messenger())
    let instance = XenditIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
      
//      print(UIApplication.shared.delegate)
      
//      registrar.addApplicationDelegate(XenditAppDelegate())
  }
    

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "createSingleToken":
        if let window = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController{
            flutterViewController = window
        }else{
            print("saalah")
        }
//        print(call.arguments.debugDescription)
        createSingleToken(call: call,result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

//   private func initialization(publishableKey: String){
//     Xendit
//   }
    
    public func createSingleToken(call: FlutterMethodCall,result: @escaping FlutterResult){
//        let viewController = UIViewController()
        var argument:[String: Any] = [:]
        let cardDataArg = argument["card"]
        var publishableKey = ""
        if let arguments = call.arguments as? Dictionary<String, Any>,
           let _ = arguments["publishedKey"] as? String{
            publishableKey = arguments["publishedKey"] as! String
            argument = arguments
        }
        Xendit.publishableKey = publishableKey
        let cardData = cardFrom(call: call)
        
        let isMuletipleUse = argument["isMultipleUse"] as? Bool ?? false
        let currency = argument["currency"] ?? "IDR"
        let amount = NSNumber(value: (argument["amount"] as! Int64))
        let onBehalfOf = argument["onBehalfOf"] ?? ""
        
        let customer = customerFrom(call: call)
        let billingDetails = billingFrom(call: call)
//        print([customer.referenceId, customer.email, customer.givenNames, customer.surname, customer.description, customer.phoneNumber, customer.mobileNumber, customer.nationality, customer.dateOfBirth, customer.addresses])
        // print(customer)
        // print(customer)
        
        
        
//        let address = XenditAddress()
//        address.category = "home"
//        address.city = "Ponorogo"
//        address.postalCode="628313"
//        address.provinceState = "Jawa Timur"
//        address.streetLine1 = "Jl. Ponorogo - Madiun"
//        address.streetLine2 = "No. 11"
//        address.country = "ID"

//        let customer = XenditCustomer()
//        customer.givenNames = "irfan"
//        customer.surname = "irfan"
//        customer.addresses = [address]
//        customer.email = "apipiirpan@gmail.com"
//        customer.mobileNumber = "+6282132263308"
//        customer.phoneNumber = "+6282132263308"
//        customer.referenceId = "2d3f8"
//        customer.dateOfBirth = nil
//        customer.description = nil
//
//        let billingDetails:XenditBillingDetails = XenditBillingDetails()
//        billingDetails.address = address
//        billingDetails.email = "apipiirpan@gmail.com"
//        billingDetails.phoneNumber = "+6282132263308"
//        billingDetails.mobileNumber = "+6282132263308"
//        billingDetails.givenNames = "irfan afifi"
//        billingDetails.surname = "irfan afifi"
//        billingDetails.middleName = "haki"
        
         let tokenizationRequest = XenditTokenizationRequest.init(cardData: cardData as! XenditCardData, isSingleUse: !isMuletipleUse, shouldAuthenticate: true, amount: amount, currency: currency as! String)
         tokenizationRequest.customer = customer
         tokenizationRequest.billingDetails = billingDetails
//
//
         Xendit.createToken(fromViewController: flutterViewController!, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf as! String) { [self] (token, error) in
             if let token = token {
                 // Handle successful tokenization. Token is of type XenditCCToken
//                 let issuingBank = token.cardInfo?.bank ?? "n/a"
//                 let country = token.cardInfo?.country ?? "n/a"
//                 _ = String(format: "TokenID - %@, AuthID - %@, Status - %@, MaskedCardNumber - %@, Should_3DS - %@, IssuingBank - %@, Country - %@", token.id, token.authenticationId ?? "n/a", token.status, token.maskedCardNumber ?? "n/a", token.should3DS?.description ?? "n/a", issuingBank, country)
                 result(tokenToMap(token: token))
 //                return createAuthRequest(call: call, result: result, publishableKey: publishableKey, tokenId: token.id, amount: amount, currency: currency as! String, cardCVN: cardData!.cardCvn)
 ////                self.createSingleToken(call: call, result: result)
 ////                result(token.id)
             } else {
//                 result(FlutterError(code: error?.errorCode ?? "500", message: error?.message, details: error))
                 result(FlutterError(code: error?.errorCode ?? "500", message: error?.message, details: nil))
                 // Handle error. Error is of type XenditError
             }
         }

        
//        result(cardData.cardNumber)
    }
  
    public func createAuthRequest(call: FlutterMethodCall, result: @escaping FlutterResult, publishableKey: String, tokenId: String, amount: NSNumber, currency: String?, cardCVN : String?){
        var url = URL.init(string: ApiClient.PRODUCTION_XENDIT_BASE_URL)!
        url.appendPathComponent(ApiClient.CREDIT_CARD_PATH)
        url.appendPathComponent(tokenId)
        url.appendPathComponent(ApiClient.AUTHENTICATION_PATH)
        
        var bodyJson : [String : Any] = [
            "amount" : amount
        ]
        
        if currency != nil {
            bodyJson["currency"] = currency
        }
        
        if cardCVN != nil {
            bodyJson["card_cvn"] = cardCVN
        }
        
        let extraHeader : [String: String] = [:]

        
//        XDTApiClient.createAuthenticationRequest(publishableKey: publishableKey, tokenId: tokenId, bodyJson: bodyJson, extraHeader: extraHeader)  {(succes, error) in {
//
//        }}
        var request = URLRequest.authorizedRequest(url: url, method: "POST", publishableKey: publishableKey, extraHeaders: extraHeader)
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: bodyJson)
            request.httpBody = bodyData
        } catch _ {
            DispatchQueue.main.async {
                result(FlutterError(code: "500", message: "JSON_SERIALIZATION_ERROR", details: "Cannot parse data request"))
//                completion(nil, XenditError(errorCode: "JSON_SERIALIZATION_ERROR", message: "Failed to serialized JSON request data"))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data,respon, error) in
            if let error = error{
                result(FlutterError(code: "500", message: "Http Request Error", details: error.localizedDescription))
            }else if let data = data{
                do{
                    let parseData = String(data: data, encoding: .utf8)
//                    print()
                    let decodeData = try JSONSerialization.jsonObject(with: data)
                    print(decodeData)
                    result(decodeData)
                }catch _{
                    print(error?.localizedDescription ?? "Error Poll")
//                    result(FlutterError(code: "500", message: "JSON_SERIALIZATION_ERROR", details: "Cannot parse response data"))
                }
                
                
                
            }
        }
        task.resume()
    }
    
    private func cardFrom(call: FlutterMethodCall) -> XenditCardData? {
        if let cardMap = call.arguments as? [String: Any],
           let cardArgs = cardMap["card"] as? [String:Any],
            
        
           let creditCardNumber = cardArgs["creditCardNumber"] as? String,
           let creditCardCVN = cardArgs["creditCardCVN"] as? String,
           let expirationMonth = cardArgs["expirationMonth"] as? String,
           let expirationYear = cardArgs["expirationYear"] as? String {
            var cardData =  XenditCardData.init(cardNumber: creditCardNumber, cardExpMonth: expirationMonth, cardExpYear: expirationYear)
            cardData.cardCvn = creditCardCVN
            return cardData
        }
        
        return nil
    }

    
    private func billingFrom(call: FlutterMethodCall) -> XenditBillingDetails {
        if let billingDetailsMap = call.arguments as? [String: Any],
           let billingDetailsArgs = billingDetailsMap["billingDetails"] as? [String: Any] {
            
            var billingDetails = XenditBillingDetails()
            
            billingDetails.givenNames = billingDetailsArgs["givenNames"] as? String ?? ""
            billingDetails.surname = billingDetailsArgs["surname"] as? String ?? ""
            billingDetails.email = billingDetailsArgs["email"] as? String ?? ""
            billingDetails.mobileNumber = billingDetailsArgs["mobileNumber"] as? String ?? ""
            billingDetails.phoneNumber = billingDetailsArgs["phoneNumber"] as? String ?? ""

            if let addressArgs = billingDetailsArgs["address"] as? [String: Any] {
                var address = XenditAddress()

                address.country = addressArgs["country"] as? String ?? ""
                address.streetLine1 = addressArgs["streetLine1"] as? String ?? ""
                address.streetLine2 = addressArgs["streetLine2"] as? String ?? ""
                address.city = addressArgs["city"] as? String ?? ""
                address.provinceState = addressArgs["provinceState"] as? String ?? ""
                address.postalCode = addressArgs["postalCode"] as? String ?? ""
                address.category = addressArgs["category"] as? String ?? ""

                billingDetails.address = address
            }

            return billingDetails
        }

        return XenditBillingDetails()
    }
    
    func customerFrom(call: FlutterMethodCall) -> XenditCustomer {
        let customer = XenditCustomer()

        if let customerMap = call.arguments as? [String: Any],
           let customerArgs = customerMap["customer"] as? [String: Any] {

            customer.referenceId = customerArgs["referenceId"] as? String 
            customer.email = customerArgs["email"] as? String 
            customer.givenNames = customerArgs["givenNames"] as? String 
            customer.surname = customerArgs["surname"] as? String 
            customer.description = customerArgs["description"] as? String 
            customer.mobileNumber = customerArgs["mobileNumber"] as? String 
            customer.phoneNumber = customerArgs["phoneNumber"] as? String 
            customer.nationality = customerArgs["nationality"] as? String 
            customer.dateOfBirth = customerArgs["dateOfBirth"] as? String 
            // print(customer)
             
//            customer.cardInfo = customerArgs["cardInfo"] as? [String: String] ?? [:]

            if let addressesList = customerArgs["addresses"] as? [[String: Any]], !addressesList.isEmpty {
                var addresses = [XenditAddress]()

                for aMap in addressesList {
                    var address = XenditAddress()

                    address.country = aMap["country"] as? String 
                    address.streetLine1 = aMap["streetLine1"] as? String 
                    address.streetLine2 = aMap["streetLine2"] as? String 
                    address.city = aMap["city"] as? String 
                    address.provinceState = aMap["provinceState"] as? String 
                    address.postalCode = aMap["postalCode"] as? String 
                    address.category = aMap["category"] as? String 

                    addresses.append(address)
                }

                customer.addresses = addresses
            }else{
                let address = XenditAddress()
                customer.addresses = [address]
            }
        }

        return customer
    }

    private func tokenToMap(token: XenditCCToken) -> [String: Any] {
        var result: [String: Any] = [:]
        result["id"] = token.id
        result["status"] = token.status
        result["authenticationId"] = token.authenticationId
        result["maskedCardNumber"] = token.maskedCardNumber
//        result["should3ds"] = token.should3DS
        result["authentication_url"] = (token.authenticationId)
        result["authentication_id"] = (token.authenticationId)
        result["cardInfo"] = cardInfoToMap(cardInfo: token.cardInfo)
        return result
    }

    private func cardInfoToMap(cardInfo: XenditCardMetadata?) -> [String: Any] {
        guard let cardInfo = cardInfo else {
            return [:]
        }

        var result: [String: Any] = [:]
        result["bank"] = cardInfo.bank
        result["country"] = cardInfo.country
        result["type"] = cardInfo.type
        result["brand"] = cardInfo.brand
        result["cardArtUrl"] = cardInfo.cardArtUrl
        result["fingerprint"] = cardInfo.fingerprint
        return result
    }


}

extension URLRequest {
    static func request(ur: URL) -> URLRequest {
        var request = URLRequest(url: ur)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func authorizedRequest(url: URL, method: String, publishableKey: String, extraHeaders: [String: String]?) -> URLRequest {
        var request = URLRequest.request(ur: url)
        let authorization = "Basic " + (publishableKey + ":").toBase64()
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue(ApiClient.CLIENT_TYPE, forHTTPHeaderField: "client-type")
        request.setValue(ApiClient.CLIENT_API_VERSION, forHTTPHeaderField: "client-version")
        request.setValue(ApiClient.CLIENT_IDENTIFIER, forHTTPHeaderField: "x-client-identifier")
        
        if extraHeaders != nil {
            for (key, value) in extraHeaders! {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpMethod = method
        return request
    }
}

extension String{
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
