//
//  ImportantNumbersView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import SwiftUI

struct ImportantNumbersView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Palette.greyBackground.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(vehicleManager.currentVehicle.numbers, id: \.self) { number in
                                NavigationLink(destination: EditNumberView(number: number)) {
                                    NumberCardView(title: number.title, number: number.telephone)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Useful contacts")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct NumberCardView: View {
    var title: String
    var number: String

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(12)
                .foregroundColor(Palette.white)
                .shadowGrey()
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(Typography.ControlS)
                        .foregroundColor(Palette.black)
                    Text(number)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.greyMiddle)
                }
                .padding()
                Spacer()
            }
        }
        .frame(
            width: UIScreen.main.bounds.size.width * 0.90,
            height: UIScreen.main.bounds.size.height * 0.075,
            alignment: .center
        )
    }
}

// struct ImportantNumbersView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportantNumbersView()
//    }
// }
