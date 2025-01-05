//
//  ThemePickerViewOld.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 13/06/22.
//

// TODO: To refactor
import SwiftUI

let pickOne = NSLocalizedString("Pick one", comment: "")
let picked = NSLocalizedString("Picked", comment: "")
struct ThemePickerViewOld: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var homeVM: HomeViewModel

    var body: some View {
        ZStack {
            Palette.greyBackground.ignoresSafeArea()
            VStack(spacing: 170) {
                Spacer()
                HStack(spacing: 40) {
                    Spacer()
                    ColorButton(color: Palette.colorBlue, cardColor: Palette.colorMainBlue, title: pickOne, homeVM: homeVM)

                    Spacer()

                    ColorButton(color: Palette.colorYellow, cardColor: Palette.colorMainYellow, title: pickOne, homeVM: homeVM)
                    Spacer()
                }

                HStack(spacing: 40) {
                    Spacer()

                    ColorButton(color: Palette.colorGreen, cardColor: Palette.colorMainGreen, title: pickOne, homeVM: homeVM)

                    Spacer()

                    ColorButton(color: Palette.colorViolet, cardColor: Palette.colorMainViolet, title: pickOne, homeVM: homeVM)

                    Spacer()
                }
                Spacer(minLength: 300)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrowLeft")
                })
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Theme")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }
}

// struct ThemePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemePickerView()
//    }
// }

struct ColorButton: View {
    var color: Color
    var cardColor: Color
    var title: String

    @GestureState var tap = false
    @State private var press = false
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

    @ObservedObject var homeVM: HomeViewModel

    var body: some View {
        HStack {
            Text(press ? picked : title)
                .font(Typography.headerM)
                .foregroundColor(press ? Palette.black : Palette.white)

            Image(systemName: press ? "checkmark" : "")
                .foregroundColor(press ? Palette.black : Palette.white)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 150, height: 150)
                .foregroundColor(color)
                .opacity(press ? 1 : 0.7)
                .rotationEffect(Angle(degrees: tap ? 90 : 0))
                .animation(.easeInOut)
                .overlay(
                    Circle()
                        .trim(from: tap ? 0.001 : 1, to: 1)
                        .stroke(Palette.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(Angle(degrees: 90))
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                        .animation(.easeInOut(duration: 0.5))
                        .frame(width: 100, height: 100)
                )
        )
        .scaleEffect(tap ? 1.15 : 1)
        .gesture(
            LongPressGesture(minimumDuration: 0.6).updating($tap) { currentState, gestureState, _ in
                gestureState = currentState
                impactHeavy.impactOccurred()
            }
            .onEnded { _ in
                press.toggle()
                homeVM.saveColor(color: color, key: homeVM.COLOR_KEY)
                homeVM.saveColor(color: cardColor, key: homeVM.COLOR_KEY_CARD)
                homeVM.headerBackgroundColor = color
                homeVM.headerCardColor = cardColor
            }
        )
        .onAppear {
            let loadedColor = homeVM.loadColor(key: homeVM.COLOR_KEY)
            let loadedColorCard = homeVM.loadColor(key: homeVM.COLOR_KEY_CARD)
            if loadedColor == color, loadedColorCard == cardColor {
                press = true
            } else {
                press = false
            }
        }
    }
}
