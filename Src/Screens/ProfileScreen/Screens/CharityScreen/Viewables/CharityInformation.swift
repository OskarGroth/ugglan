//
//  CharityInformation.swift
//  ugglan
//
//  Created by Gustaf Gunér on 2019-03-28.
//

import Apollo
import Flow
import Form
import Presentation
import UIKit

struct CharityInformation {}

extension CharityInformation: Presentable {
    func materialize() -> (UIViewController, Disposable) {
        let bag = DisposeBag()
        
        let viewController = UIViewController()
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        let header = DraggableOverlayHeader(title: String(key: .PROFILE_MY_CHARITY_INFO_TITLE))
        bag += containerView.add(header)
        
        let bodyView = UIView()
        containerView.addSubview(bodyView)
        
        /*
        bodyView.snp.remakeConstraints { make in
            make.top.equalTo(56 + 8)
            make.width.equalToSuperview()
            // make.height.equalToSuperview().offset(56 + 8)
            make.height.equalTo(bodyView.intrinsicContentSize.height)
        }*/
        
        // let body = CharityInformationBody(text: String(key: .PROFILE_MY_CHARITY_INFO_BODY))
        let body = CharityInformationBody(text: """
Hedvig tar en fast avgift oavsett hur mycket ersättning som betalas ut. Överskottet skänks till ett gott ändamål istället för att gå till extra vinst.
            
**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna

**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna

**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna

**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna

**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna

**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna

**Så funkar det**
**1.** Välj det ändamål du vill stötta
**2.** Vid årets slut summerar vi alla pengar som inte betalats ut i ersättningar till dig, eller till andra som valt samma ändamål
**3.** Tillsammans gör vi skillnad genom att skänka pengarna
""");

        bag += bodyView.add(body) { bodyText in
            bodyText.snp.makeConstraints { make in
                make.height.equalTo(bodyText.intrinsicContentSize.height)
                make.top.bottom.trailing.leading.equalToSuperview()
            }
        }
        
        bodyView.snp.makeConstraints { make in
            print(bodyView.intrinsicContentSize.height)
            make.top.equalTo(56 + 8)
            make.width.equalToSuperview()
            // make.height.equalToSuperview().offset(56 + 8)
            make.height.equalTo(bodyView.intrinsicContentSize.height)
        }
        
        viewController.view = containerView;
        
        return (viewController, bag)
    }
}

