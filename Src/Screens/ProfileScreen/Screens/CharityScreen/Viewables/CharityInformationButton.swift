//
//  CharityInformationButton.swift
//  ugglan
//
//  Created by Gustaf Gunér on 2019-04-04.
//

import Flow
import Foundation
import UIKit
import SnapKit

struct CharityInformationButton {
    let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
}

extension CharityInformationButton: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let view = UIView()
        
        let bag = DisposeBag()
        
        let button = Button(
            title: String(key: .PROFILE_MY_CHARITY_INFO_BUTTON),
            type: .iconTransparent(textColor: .purple, icon: Asset.infoPurple)
        )
        
        bag += view.add(button)
        
        // String(key: .PROFILE_MY_CHARITY_INFO_BODY)
        let demoText = """
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
"""
        
        bag += button.onTapSignal.onValue {_ in
            self.presentingViewController.present(
                DraggableOverlay(
                    content: DraggableOverlayContent(
                        title: String(key: .PROFILE_MY_CHARITY_INFO_TITLE),
                        body: demoText
                    ),
                    presentationOptions: [.defaults, .prefersLargeTitles(false), .largeTitleDisplayMode(.never), .prefersNavigationBarHidden(true)],
                    heightPercentage: 0.60,
                    fullscreenSupported: true
                )
            )
        }
        
        bag += view.makeConstraints(wasAdded: events.wasAdded).onValue { make, _ in
            make.height.equalTo(button.type.height())
        }
        
        return (view, bag)
    }
}
