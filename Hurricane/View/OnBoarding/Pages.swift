//
//  Pages.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/05/22.
//

import SwiftUI

enum FocusFieldBoarding: Hashable {
    case carName
    case brand
    case model
    case fuelType
    
}

//MARK: PAGE 1 FRONT PAGE
struct Page1 : View {
    
    @Binding var destination : Pages
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            VStack(spacing:12){
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
            Spacer()
            VStack(spacing: 16){
                Button(action: {
                    withAnimation(.easeInOut){
                        destination = .page2
                    }
                }, label: {
                    OnBoardingButton(text: "Add a new vehicle", textColor: Palette.white, color: Palette.black)
                })
                OnBoardingButton(text: "Import data", textColor: Palette.black, color: Palette.white)
                OnBoardingButton(text: "Restore from iCloud", textColor: Palette.black, color: Palette.white)
            }
            
        }.background(Palette.greyBackground)
    }
}

//MARK: PAGE 2 ADD VEHICLE
struct Page2 : View {
    
    @StateObject var onboardingVM : OnboardingViewModel
    
    @Binding var destination : Pages
    @FocusState var focusedField: FocusFieldBoarding?
    
    @State private var isTapped = false
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var customLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .stroke(isTapped ? Palette.black : Palette.greyInput,lineWidth: 1)
                .background(isTapped ? Palette.greyLight : Palette.greyBackground)
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
            HStack{
                Text(onboardingVM.selectedFuel)
                    .font(Typography.TextM)
                Spacer()
            }
            .accentColor(isTapped ? Palette.black : Palette.greyInput)
            .padding(.leading,40)
        }
    }
    
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                    destination = .page1
                }, label: {
                    Image(systemName: onboardingVM.skipNotification ? "" : "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 21)
                        .foregroundColor(Palette.black)
                })
                Spacer()
            }
            .padding()
            VStack(spacing:12){
                Text("Vehicle registration")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Hop in and insert some key details")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            VStack(spacing:20){
                
                TextField("Car's name", text: $onboardingVM.vehicle.name.toUnwrapped(defaultValue: ""))
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .carName)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .carName ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .carName ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $onboardingVM.vehicle.name.toUnwrapped(defaultValue: "")))
                    .onSubmit {
                        focusedField = .brand
                    }
                
                
                TextField("Brand", text: $onboardingVM.vehicle.brand.toUnwrapped(defaultValue: ""))
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .brand)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .brand ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                        .stroke(focusedField == .brand ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $onboardingVM.vehicle.brand.toUnwrapped(defaultValue: "")))
                    .onSubmit {
                        focusedField = .model
                    }
                
                TextField("Model", text: $onboardingVM.vehicle.model.toUnwrapped(defaultValue: ""))
                    .disableAutocorrection(true)
                    .focused($focusedField,equals: .model)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .model ? Palette.greyLight :Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .model ? Palette.black :Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $onboardingVM.vehicle.model.toUnwrapped(defaultValue: "")))
                    .onSubmit {
                        focusedField = nil
                    }
                
                //MARK: NEED TO FIX MULTIPLE FUEL TYPES
                Menu{
                    Picker(selection: $onboardingVM.selectedFuel, label:
                            EmptyView()){
                        ForEach(onboardingVM.fuelCategories,id: \.self) { name in
                            Text(name)
                        }
                    }
                } label: {
                    customLabel
                }.onTapGesture {
                    isTapped = true
                }
                
            }
            .padding(.vertical,40)
            
            
            Spacer()
            Button(action: {
                withAnimation(.easeInOut){
                    destination = .page3
                }
            }, label: {
                OnBoardingButton(text: "Next", textColor: Palette.white, color: Palette.black)
            })
            .disabled(onboardingVM.isDisabled)
            .opacity(onboardingVM.isDisabled ? 0.25 : 1)
        }
        .ignoresSafeArea(.keyboard)
        .background(Palette.greyBackground)
        .onTapGesture {
            focusedField = nil
        }
        .onAppear{
            focusedField = .carName
        }
    }
    
}

//MARK: PAGE 3 ADD MORE INFO
struct Page3 : View {
    
    @State var isImport = false
    @Binding var destination : Pages
    var dataVM = DataViewModel()
    @ObservedObject var onboardingVM : OnboardingViewModel
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    destination = .page2
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 21)
                        .foregroundColor(Palette.black)
                })
                Spacer()
            }
            .padding()
            VStack(spacing:12){
                Text("Add more info")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Keep all of your vehicle info at hand")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            VStack(spacing:20){
                Button(action: {
                    
                }, label: {
                    OnBoardingCard(text: "Documents", bgColor: Palette.colorViolet, iconName:  "documents")
                })
                Button(action: {
                    
                }, label: {
                    OnBoardingCard(text: "Odometer", bgColor: Palette.colorBlue, iconName:  "odometer")
                })
                Button(action: {
                    
                }, label: {
                    OnBoardingCard(text: "Important numbers", bgColor: Palette.colorGreen, iconName:  "phone")
                })
                
            }.padding(.vertical,40)
            
            Spacer()
            Button(action: {
                withAnimation(.easeInOut){
                    dataVM.addVehicle(vehicle: onboardingVM.vehicle)
                    if(onboardingVM.skipNotification == true) {
                        destination = .page5
                    }
                    else{
                        destination = .page4
                    }
                }
            }, label: {
                OnBoardingButton(text: "Next", textColor: Palette.white, color: Palette.black)
            })
        } .background(Palette.greyBackground)
    }
}

//MARK: PAGE 4 NOTIFICATIONS
struct Page4 : View {
    
    @Binding var destination : Pages
    @ObservedObject var onboardingVM : OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .center){
            
            Spacer()
            VStack(spacing:12){
                Text("Don’t miss anything \n important")
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text("Let us remind you key dates about your \nvehicle’s maintenance status and deadlines")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            .padding(.vertical,-70)
            Spacer()
            Image("page4")
                .offset(y:-20)
            Spacer()
            VStack(spacing: 16){
                Button(action: {
                    withAnimation(.easeInOut){
                        onboardingVM.requestAuthNotifications()
                        destination = .page5
                        onboardingVM.skipNotification = true
                        
                    }
                }, label: {
                    OnBoardingButton(text: "Activate notifications", textColor: Palette.white, color: Palette.black)
                })
                Button(action: {
                    withAnimation(.easeInOut){
                        destination = .page5
                    }
                }, label: {
                    OnBoardingButton(text: "Later", textColor: Palette.black, color: Palette.white)
                })
                
            }
            
        }.background(Palette.greyBackground)
    }
}

//MARK: PAGE 5 DISMISS
struct Page5 : View {
    
    @Binding var shouldShowOnboarding : Bool
    @Binding var destination : Pages
    @ObservedObject var onboardingVM : OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Image("page5")
                .offset(y:30)
            Spacer()
            VStack(spacing:12){
                Text("Your vehicle is ready!")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("You are set to start your engine and optimize \n your spendings")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }.padding(.vertical,50)
            VStack(spacing: 16){
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    OnBoardingButton(text: "Okayyyy let's go", textColor: Palette.white, color: Palette.black)
                })
                Button(action: {
                    withAnimation(.easeInOut){
                        destination = .page2
                        onboardingVM.resetFields()
                    }
                }, label: {
                    OnBoardingButton(text: "Add new car", textColor: Palette.black, color: Palette.white)
                })
            }
            
        }.background(Palette.greyBackground)
    }
}

struct OnBoardingButton : View {
    
    var text : String
    var textColor : Color
    var color : Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.060, alignment: .center)
                .cornerRadius(43)
                .foregroundColor(color)
            HStack{
                Spacer()
                Text(text)
                    .foregroundColor(textColor)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}

struct OnBoardingCard : View {
    
    var text : String
    var bgColor : Color
    var iconName : String
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.075, alignment: .center)
                .cornerRadius(12)
                .foregroundColor(Palette.white)
                .shadowGrey()
            HStack{
                ZStack{
                    Circle()
                        .foregroundColor(bgColor)
                        .frame(width: 32, height: 32)
                    Image(iconName)
                        .resizable()
                        .frame(width: 16, height: 16)
                }.padding(.horizontal,8)
                Text(text)
                    .foregroundColor(Palette.black)
                    .font(Typography.headerM)
                Spacer()
            }.padding(.horizontal,30)
        }
    }
}

struct ClearButton: ViewModifier{
    
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing){
            content
            
            if (!text.isEmpty) {
                Button(action:{
                    self.text = ""
                }){
                    Image(systemName: "xmark")
                        .foregroundColor(Palette.black)
                }
                .padding(.trailing, 20)
            }
        }
    }
}