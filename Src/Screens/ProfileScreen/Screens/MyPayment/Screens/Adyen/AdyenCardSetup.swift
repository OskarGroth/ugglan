//
//  AdyenCardSetup.swift
//  UITests
//
//  Created by Sam Pettersson on 2019-04-05.
//

import Foundation
import Flow
import Presentation
import UIKit
import Form
import Adyen

struct AdyenCardSetup {
    func performPayment() -> Future<AdyenPaymentMethodsResponse> {
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

extension AdyenCardSetup: Presentable {
    func materialize() -> (UIViewController, Disposable) {
        let viewController = UIViewController()
        viewController.title = "Add card"
        
        let bag = DisposeBag()
        
        let form = FormView(sections: [], style: .defaultPlain)
        form.backgroundColor = .offWhite
        
        bag += viewController.install(form)
        
        let cardNumberSection = SectionView(headerView: UILabel(value: "CARD NUMBER", style: .sectionHeader), footerView: nil)
        
        let cardNumberTextField = CardNumberTextField()
        bag += cardNumberSection.append(cardNumberTextField)
        
        form.prepend(cardNumberSection)
        
        let securitySection = SectionView()
        let securitySectionStackView = UIStackView()
        securitySectionStackView.axis = .horizontal
        
        let expirationStackView = UIStackView()
        expirationStackView.axis = .vertical
        expirationStackView.addArrangedSubview(UILabel(value: "EXPIRATION", style: .sectionHeader))
        bag += expirationStackView.addArangedSubview(CardNumberTextField())
        securitySectionStackView.addArrangedSubview(expirationStackView)
        
        expirationStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        let securityCodeStackView = UIStackView()
        securityCodeStackView.axis = .vertical
        securityCodeStackView.addArrangedSubview(UILabel(value: "CVC", style: .sectionHeader))
        bag += securityCodeStackView.addArangedSubview(CardNumberTextField())
        securitySectionStackView.addArrangedSubview(securityCodeStackView)
        
        securityCodeStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        securitySection.append(securitySectionStackView)
        
        form.append(securitySection)
        
        let saveCardButton = ButtonSection(text: "Spara kort", style: .normal)
        bag += form.append(saveCardButton)
        
        bag += saveCardButton.onSelect.onValue { _ in
            
        }
        
        return (viewController, bag)
    }
}
