//
//  AddNumberView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

enum FocusFieldNumbers: Hashable {
    case numberTitle
    case number
}

struct AddNumberView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager
    @FocusState var focusedField: FocusFieldNumbers?
    @Binding var alert: AlertConfig
    @State private var numberName: String = ""
    @State private var numberPhone: String = ""

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack {
                HStack {
                    Spacer()
                    Text(String(localized: "Add useful contact"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading, 40)
                    Spacer()
                    Button(action: {
                        alert.dismiss()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Palette.greyLight)
                            Image("ics")
                                .foregroundColor(Palette.black)
                        }
                        .padding(.trailing, 20)
                    })
                }
                VStack(spacing: 12) {
                    TextField(String(localized: "Contact name"), text: $numberName)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .numberTitle)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .numberTitle ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                        .onSubmit {
                            focusedField = .number
                        }

                    TextField(String(localized: "Number"), text: $numberPhone)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .number)
                        .keyboardType(.phonePad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .number ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                        .onSubmit {
                            focusedField = .number
                        }

                    Button(PitstopAPPStrings.Common.save) {
                        saveNumber()
                        alert.dismiss()
                    }
                    .buttonStyle(Primary())
                    .disabled(numberName.isEmpty || numberPhone.isEmpty)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.28)
        .onAppear { focusedField = .numberTitle }
    }
}

private extension AddNumberView {
    func saveNumber() {
        let number = Number(
            title: numberName,
            telephone: numberPhone,
            vehicle: vehicleManager.currentVehicle
        )
        number.insert(context: modelContext)
        vehicleManager.currentVehicle.numbers.append(number)
    }
}

// struct AlertAddNumbers_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertAddNumbers(numberTitle: "", number: "")
//
//    }
// }
