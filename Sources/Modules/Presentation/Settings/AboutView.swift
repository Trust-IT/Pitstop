//
//  AboutView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/06/22.
//

import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            GifView("aboutPlaceholder", size: .init(width: 200, height: 200))
                .frame(width: 200, height: 200)
                .background(Circle()
                    .stroke(style: .init(lineWidth: 3))
                    .foregroundStyle(Palette.greyHard)
                    .background(Palette.greyBackground)
                )
                .clipShape(Circle())
            Spacer()
            CustomList {
                Section(header: Text("The team")) {
                    Button(action: {
                        openURL(URL(string: "https://oneanya.com")!)
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Anna Antonova")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerS)
                                Text("UI/UX Designer")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.TextM)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Palette.greyLight)

                                Image(systemName: "link")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .accentColor(Palette.black)
                        }
                    })
                    .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

                    Button(action: {
                        openURL(URL(string: "https://www.linkedin.com/in/francesco-puzone/")!)
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Francesco Puzone")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerS)
                                Text("Project Manager")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.TextM)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Palette.greyLight)
                                Image(systemName: "link")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .accentColor(Palette.black)
                        }
                    })
                    .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

                    Button(action: {
                        openURL(URL(string: "https://github.com/AsyaTea")!)
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Asya Tealdi")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerS)
                                Text("Developer")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.TextM)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Palette.greyLight)
                                Image(systemName: "link")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .accentColor(Palette.black)
                        }
                    })
                    .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

                    Button(action: {
                        openURL(URL(string: "https://github.com/IV0000")!)
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Ivan Voloshchuk")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.headerS)
                                Text("Developer")
                                    .foregroundColor(Palette.black)
                                    .font(Typography.TextM)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Palette.greyLight)
                                Image(systemName: "link")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .accentColor(Palette.black)
                        }
                    })
                    .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                }
            }
            .padding(.top, 0)

            Text("Pitstop version " + (appVersion ?? ""))
                .padding(.top, 30)
                .offset(y: -20)
                .foregroundColor(Palette.black)
                .font(Typography.TextM)

            Spacer()
        }
        .background(Palette.greyBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(String(localized: "About us"))
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
        }
    }
}

#Preview {
    AboutView()
}
