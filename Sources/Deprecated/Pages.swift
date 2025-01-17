//
//  Pages.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/05/22.
//

import SwiftUI

enum FocusFieldOnboarding: Hashable {
    case vehicleName
    case brand
    case model
    case fuelType
    case plate
}

// MARK: PAGE 1 FRONT PAGE

struct Page1: View {
    @StateObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(spacing: 12) {
                Text("Warm up your engine")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Gear up for a simple way of managing your \nvehicle and cutting costs")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Image("page1")
            Spacer(minLength: 65)
            VStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        onboardingVM.destination = .page2
                    }
                }, label: {
                    Text("Add a new vehicle")
                })
                .buttonStyle(Primary())
            }
            Spacer()
        }
        .background(Palette.greyBackground)
    }
}

// MARK: PAGE 2 ADD VEHICLE

struct Page2: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var onboardingVM: OnboardingViewModel

    @FocusState var focusedField: FocusFieldOnboarding?

    @State private var isTapped = false

    @State private var showMainFuelSelection: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State var vehicle: Vehicle = .mock()

    var body: some View {
        VStack {
            HStack {
                if onboardingVM.addNewVehicle == true {
                    Button(action: {
                        onboardingVM.addNewVehicle = false
                    }, label: {
                        Text("Cancel")
                            .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard)
                } else {
                    Button(action: {
                        onboardingVM.destination = .page1
                    }, label: {
                        Image(systemName: onboardingVM.removeBack ? "" : "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 21)
                            .foregroundColor(Palette.black)
                    })
                }
                Spacer()
            }
            .padding()
            VStack(spacing: 12) {
                Text("Vehicle registration")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Hop in and insert some key details")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            VStack(spacing: 20) {
                TextField("Vehicle name", text: $vehicle.name)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .vehicleName)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .vehicleName ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .vehicleName ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicle.name))
                    .onSubmit {
                        focusedField = .brand
                    }

                TextField("Brand", text: $vehicle.brand)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .brand)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .brand ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .brand ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicle.brand))
                    .onSubmit {
                        focusedField = .model
                    }

                TextField("Model", text: $vehicle.model)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .model)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .model ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .model ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $vehicle.model))
                    .onSubmit {
                        focusedField = nil
                    }

                // MARK: PRIMARY FUEL

                Button(action: {
                    showMainFuelSelection.present()
                    isTapped.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(isTapped ? Palette.black : Palette.greyInput, lineWidth: 1)
                            .background(isTapped ? Palette.greyLight : Palette.greyBackground)
                            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                        HStack {
                            Text(vehicle.mainFuelType.rawValue)
                                .font(Typography.TextM)
                            Spacer()
                        }
                        .padding(.leading, 40)
                    }
                    .accentColor(Palette.black)
                })
                .alert(config: $showMainFuelSelection) {
                    ConfirmationDialog(
                        items: FuelType.allCases,
                        message: "Select a fuel type",
                        onTap: { fuel in
                            vehicle.mainFuelType = fuel
                            isTapped.toggle()
                            focusedField = nil
                            showMainFuelSelection.dismiss()
                        },
                        onCancel: {
                            isTapped.toggle()
                            focusedField = nil
                            showMainFuelSelection.dismiss()
                        }
                    )
                }
            }
            .padding(.vertical, 40)

            Spacer()
            Button(action: {
                withAnimation(.easeInOut) {
                    onboardingVM.destination = .page3($vehicle)
                }
            }, label: {
                Text("Next")
            })
            .buttonStyle(Primary())
            .disabled(vehicle.name.isEmpty || vehicle.brand.isEmpty || vehicle.model.isEmpty || vehicle.mainFuelType == .none)
        }
        .ignoresSafeArea(.keyboard)
        .background(Palette.greyBackground)
        .onTapGesture {
            focusedField = nil
        }
        .onAppear {
            focusedField = .vehicleName
        }
    }
}

// MARK: PAGE 3 ADD MORE INFO

struct Page3: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var onboardingVM: OnboardingViewModel

    @State private var showSecondaryFuelSelection: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )
    @State private var showPlateSelection: Bool = false
    @State private var showOdometerSelection: Bool = false
    @State private var showOverlay: Bool = false

    @Binding var vehicle: Vehicle

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        onboardingVM.destination = .page2
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 21)
                            .foregroundColor(Palette.black)
                    })
                    Spacer()
                }
                .padding()
                VStack(spacing: 12) {
                    Text("Add more info")
                        .font(Typography.headerXL)
                        .foregroundColor(Palette.black)
                    Text("Keep all of your vehicle info at hand")
                        .font(Typography.TextM)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Palette.black)
                }
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // MARK: PLATE NUMBER

                        Button(action: {
                            showPlateSelection.toggle()
                            showOverlay = true
                        }, label: {
                            OnBoardingCard(text: "Plate number", bgColor: Palette.colorOrange, iconName: .basedOn)
                        })

                        if let plate = vehicle.plate {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Palette.greyLight)
                                    .cornerRadius(12)

                                HStack {
                                    Text(plate)
                                        .font(Typography.ControlS)
                                        .foregroundColor(Palette.black)
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.075, alignment: .center)
                        }

                        // MARK: ODOMETER

                        Button(action: {
                            showOdometerSelection.toggle()
                            showOverlay = true
                        }, label: {
                            OnBoardingCard(text: "Odometer", bgColor: Palette.colorBlue, iconName: .odometer)
                        })
                        if vehicle.odometer != 0 || showOdometerSelection == true {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Palette.greyLight)
                                    .cornerRadius(12)

                                HStack {
                                    Text(String(Int(vehicle.odometer)))
                                        .font(Typography.ControlS)
                                        .foregroundColor(Palette.black)
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(
                                width: UIScreen.main.bounds.size.width * 0.90,
                                height: UIScreen.main.bounds.size.height * 0.075,
                                alignment: .center
                            )
                        }

                        // MARK: SECOND FUEL TYPE

                        Button(action: {
                            showSecondaryFuelSelection.present()
                        }, label: {
                            OnBoardingCard(text: "Second fuel type", bgColor: Palette.colorYellow, iconName: .fuel)
                        })
                        .alert(config: $showSecondaryFuelSelection) {
                            ConfirmationDialog(
                                items: FuelType.allCases,
                                message: "Select a fuel type",
                                onTap: { fuel in
                                    vehicle.secondaryFuelType = fuel
                                    showSecondaryFuelSelection.dismiss()
                                },
                                onCancel: {
                                    showSecondaryFuelSelection.dismiss()
                                }
                            )
                        }
                        if let secondaryFuel = vehicle.secondaryFuelType {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Palette.greyLight)
                                    .cornerRadius(12)

                                HStack {
                                    Text(secondaryFuel.rawValue)
                                        .font(Typography.ControlS)
                                        .foregroundColor(Palette.black)
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(
                                width: UIScreen.main.bounds.size.width * 0.90,
                                height: UIScreen.main.bounds.size.height * 0.075,
                                alignment: .center
                            )
                        }

                    }.padding(.vertical, 40)
                }
                Spacer()

                // MARK: ADD A NEW VEHICLE FROM SETTINGS

                if onboardingVM.addNewVehicle == true {
                    Button(action: {
                        onboardingVM.addNewVehicle = false
                        vehicleManager.setCurrentVehicle(vehicle)
                        do {
                            try vehicle.saveToModelContext(context: modelContext)
                        } catch {
                            print("\(error)")
                        }
                    }, label: {
                        Text("Add vehicle")
                    })
                    .buttonStyle(Primary())
                } else {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            do {
                                try vehicle.saveToModelContext(context: modelContext)
                            } catch {
                                print("\(error)")
                            }
                            vehicleManager.setCurrentVehicle(vehicle)
                            if onboardingVM.skipNotification == true {
                                onboardingVM.destination = .page5
                            } else {
                                onboardingVM.destination = .page4
                            }
                        }
                    }, label: {
                        Text("Next")
                    })
                    .buttonStyle(Primary())
                }
            }
            .ignoresSafeArea(.keyboard)
            .background(Palette.greyBackground)
            .disabled(showOverlay)
            .overlay(
                ZStack {
                    showOverlay ? Color.black.opacity(0.4) : Color.clear
                }
                .ignoresSafeArea()
            )
            .ignoresSafeArea(.keyboard)
        }
    }
}

// MARK: PAGE 4 NOTIFICATIONS

struct Page4: View {
    @ObservedObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(spacing: 12) {
                Text("Don’t miss anything \nimportant")
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text("Let us remind you key dates about your \nvehicle’s maintenance status and deadlines")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            .padding(.vertical, -70)
            Spacer()
            Image("page4")
                .offset(y: -20)
            Spacer()
            VStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        NotificationManager.shared.requestAuthNotifications()
                        onboardingVM.destination = .page5
                        onboardingVM.skipNotification = true
                        onboardingVM.removeBack = true
                    }
                }, label: {
                    Text("Activate notifications")
                })
                .buttonStyle(Primary())
                Button(action: {
                    withAnimation(.easeInOut) {
                        onboardingVM.destination = .page5
                        onboardingVM.removeBack = true
                    }
                }, label: {
                    Text("Later")
                })
                .buttonStyle(Secondary())
            }

        }.background(Palette.greyBackground)
    }
}

// MARK: PAGE 5 DISMISS

struct Page5: View {
    @Binding var shouldShowOnboarding: Bool
    @ObservedObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image("page5")
                .offset(y: 30)
            Spacer()
            VStack(spacing: 12) {
                Text("Your vehicle is ready!")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("You are set to start your engine and optimize \n your spendings")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }.padding(.vertical, 50)
            VStack(spacing: 16) {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    Text("Okayyyy let's go")
                })
                .buttonStyle(Primary())
            }
        }
        .background(Palette.greyBackground)
    }
}

struct OnBoardingCard: View {
    init(text: LocalizedStringKey, bgColor: Color, iconName: ImageResource) {
        self.text = text
        self.bgColor = bgColor
        self.iconName = iconName
    }

    var text: LocalizedStringKey
    var bgColor: Color
    var iconName: ImageResource

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 68, alignment: .center)
                .cornerRadius(12)
                .foregroundColor(Palette.white)
                .shadowGrey()
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(bgColor)
                        .frame(width: 32, height: 32)
                    Image(iconName)
                        .resizable()
                        .foregroundColor(Color(rgb: 0x9A7EFF))
                        .frame(width: 16, height: 16)
                }
                .padding(.horizontal, 8)
                Text(text)
                    .foregroundColor(Palette.black)
                    .font(Typography.headerM)
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Palette.black)
                })
                .padding(.trailing, 20)
            }
        }
    }
}
