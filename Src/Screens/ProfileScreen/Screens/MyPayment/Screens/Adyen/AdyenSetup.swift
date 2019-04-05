//
//  AdyenSetup.swift
//  UITests
//
//  Created by Sam Pettersson on 2019-04-05.
//

import Foundation
import Presentation
import Flow
import UIKit
import Form

struct AdyentPaymentMethodsRequest: Codable {
    let merchantAccount = "HedvigABCOM"
    let countryCode = "SE"
    
    struct Amount: Codable {
        let currency = "SEK"
        let value: Int
    }
    
    let amount: Amount
}

struct AdyenPaymentMethodsResponse: Codable {
    let groups: [AdyenGroup]
}

struct AdyenGroup: Codable {
    let name: String
    let types: [AdyenGroupType]
}

struct AdyenGroupType: Codable {
    let value: String
    
    init(from decoder: Decoder) {
        let value = try? decoder.singleValueContainer().decode(String.self)
        self.value = value ?? "Unknown"
    }
}

extension AdyenGroupType: Reusable {
    static func makeAndConfigure() -> (make: UIView, configure: (AdyenGroupType) -> Disposable) {
        let row = RowView()
        let nameLabel = UILabel()
        
        row.append(nameLabel)
        
        return (row, { type in
            nameLabel.text = type.value
            return NilDisposer()
        })
    }
}

extension AdyenGroupType: Hashable {}

enum AdyenError: Error {
    case fetchPaymentMethods
}

private let AdyenCheckoutURL = URL(string: "https://checkout-test.adyen.com/v41/paymentMethods")!

struct AdyenPaymentSetup {
    func fetchPaymentMethods() -> Future<AdyenPaymentMethodsResponse> {
        return Future { completion in
            
            var request = URLRequest(url: AdyenCheckoutURL)
            request.setValue(
                "AQEjhmfuXNWTK0Qc+iSYl2AuruO6asUZ5ply6PqxJFV7zNpfI3YQwV1bDb7kfNy1WIxIIkxgBw==-1qy1TbEi5aDw7ouyKG4iD/vPTM/xvCUjW4a+lrnlv38=-8DbSYR728JpegVvw",
                forHTTPHeaderField: "X-API-key"
            )
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            
            request.httpMethod = "POST"
            
            let paymentMethodsRequest = AdyentPaymentMethodsRequest(amount: AdyentPaymentMethodsRequest.Amount(value: 1690))
            request.httpBody = try JSONEncoder().encode(paymentMethodsRequest)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(AdyenError.fetchPaymentMethods))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(AdyenPaymentMethodsResponse.self, from: data)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(error))
                }
            }
         
            task.resume()
            
            return Disposer {
                task.cancel()
            }
        }
    }
}

extension AdyenPaymentSetup: Presentable {
    func materialize() -> (UIViewController, Disposable) {
        let viewController = UIViewController()
        
        let bag = DisposeBag()
        
        let tableKit = TableKit<String, AdyenGroupType>(
            table: Table(),
            style: .grouped,
            bag: bag
        )
        
        //bag += tableKit.delegate.didSelectRow.onValue { group in
        //    viewController.present(AdyenCardSetup(group: group))
        //}
        
        bag += viewController.install(tableKit)
        
        self.fetchPaymentMethods().onValue { response in
            let sections = response.groups.map { group in
                return (group.name, group.types)
            }
            
            tableKit.set(Table<String, AdyenGroupType>(sections: sections))
        }
        
        return (viewController, bag)
    }
}
