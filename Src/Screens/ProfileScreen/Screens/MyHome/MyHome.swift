//
//  MyResidence.swift
//  ugglan
//
//  Created by Sam Pettersson on 2019-02-12.
//

import Apollo
import Flow
import Form
import Presentation

struct MyHome {
    let client: ApolloClient

    init(
        client: ApolloClient = ApolloContainer.shared.client
    ) {
        self.client = client
    }
}

extension MyHome: Presentable {
    func materialize() -> (UIViewController, Disposable) {
        let bag = DisposeBag()

        let viewController = UIViewController()
        viewController.title = String(key: .MY_HOME_TITLE)

        let form = FormView()
        bag += viewController.install(form)

        let addressCircle = AddressCircle()
        bag += form.prepend(addressCircle)

        bag += client.fetch(query: MyHomeQuery()).onValue { result in
            if let insurance = result.data?.insurance {
                let rowTitle = UILabel(value: String(key: .MY_HOME_SECTION_TITLE), style: .rowTitle)
                let section = SectionView(
                    headerView: rowTitle,
                    footerView: nil
                )
                section.dynamicStyle = .sectionPlain

                let adressRow = KeyValueRow()
                adressRow.keySignal.value = String(key: .MY_HOME_ADDRESS_ROW_KEY)
                adressRow.valueSignal.value = insurance.address ?? ""
                adressRow.valueStyleSignal.value = .rowTitleDisabled
                bag += section.append(adressRow)

                let postalCodeRow = KeyValueRow()
                postalCodeRow.keySignal.value = String(key: .MY_HOME_ROW_POSTAL_CODE_KEY)
                postalCodeRow.valueSignal.value = insurance.postalNumber ?? ""
                postalCodeRow.valueStyleSignal.value = .rowTitleDisabled
                bag += section.append(postalCodeRow)

                let livingSpaceRow = KeyValueRow()
                livingSpaceRow.keySignal.value = String(key: .MY_HOME_ROW_SIZE_KEY)

                if let livingSpace = insurance.livingSpace {
                    livingSpaceRow.valueSignal.value = String(key: .MY_HOME_ROW_SIZE_VALUE(
                        livingSpace: String(livingSpace)
                    ))
                    livingSpaceRow.valueStyleSignal.value = .rowTitleDisabled
                    bag += section.append(livingSpaceRow)
                }

                let apartmentTypeRow = KeyValueRow()
                apartmentTypeRow.keySignal.value = String(key: .MY_HOME_ROW_TYPE_KEY)
                apartmentTypeRow.valueStyleSignal.value = .rowTitleDisabled

                if let insuranceType = insurance.type {
                    switch insuranceType {
                    case .brf:
                        apartmentTypeRow.valueSignal.value = String(key: .MY_HOME_ROW_TYPE_CONDOMINIUM_VALUE)
                    case .studentBrf:
                        apartmentTypeRow.valueSignal.value = String(key: .MY_HOME_ROW_TYPE_CONDOMINIUM_VALUE)
                    case .rent:
                        apartmentTypeRow.valueSignal.value = String(key: .MY_HOME_ROW_TYPE_RENTAL_VALUE)
                    case .studentRent:
                        apartmentTypeRow.valueSignal.value = String(key: .MY_HOME_ROW_TYPE_RENTAL_VALUE)
                    case .__unknown:
                        apartmentTypeRow.valueSignal.value = String(key: .GENERIC_UNKNOWN)
                    }
                }
                bag += section.append(apartmentTypeRow)

                form.append(section)
            }

            bag += form.append(Spacing(height: 20))

            let buttonSection = ButtonSection(
                text: String(key: .MY_HOME_CHANGE_INFO_BUTTON),
                style: .normal
            )
            bag += form.append(buttonSection)

            bag += buttonSection.onSelect.onValue {
                let alert = Alert<Bool>(
                    title: String(key: .MY_HOME_CHANGE_ALERT_TITLE),
                    message: String(key: .MY_HOME_CHANGE_ALERT_MESSAGE),
                    actions: [
                        Alert.Action(title: String(key: .MY_HOME_CHANGE_ALERT_ACTION_CANCEL)) { false },
                        Alert.Action(title: String(key: .MY_HOME_CHANGE_ALERT_ACTION_CONFIRM)) { true },
                    ]
                )

                viewController.present(alert).onValue { shouldContinue in
                    if shouldContinue {
                        MyHomeRouting.openChat(viewController: viewController)
                    }
                }
            }
        }

        return (viewController, bag)
    }
}
