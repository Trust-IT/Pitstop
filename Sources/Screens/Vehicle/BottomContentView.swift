//
//  BottomContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import PDFKit
import SwiftData
import SwiftUI

struct BottomContentView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.modelContext) private var modelContext

    @State private var viewAllNumbers = false
    @State private var viewAllEvents = false
    @State private var showEventEdit = false

    @State private var showingOptions = false

    @State private var presentImporter = false
    @State private var showPDF = false

    @Query var documents: [Document]
    @State private var selectedDocument: Document = .mock()

    @State private var selectedFuelExpense: FuelExpense = .mock()
    @State private var selectedDocumentType: DocumentPickerType?

    @State private var newNumberAlert: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var showDocumentPicker: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    var body: some View {
        VStack(spacing: 0) {
            // MARK: LAST EVENTS

            titleSection(
                sectionTitle: "Last events",
                showViewAll: !vehicleManager.currentVehicle.fuelExpenses.isEmpty,
                viewAllAction: {
                    viewAllEvents.toggle()
                }
            )
            .padding()
            .padding(.top, 10)
            .padding(.bottom, -10)
            .sheet(isPresented: $viewAllEvents) { LastEventsView() }

            if vehicleManager.currentVehicle.fuelExpenses.isEmpty {
                HStack {
                    Text(LocalizedStringKey("There are no events to show"))
                        .font(Typography.TextM)
                        .foregroundColor(Palette.greyMiddle)
                    Spacer()
                }
                .padding()
            } else {
                ForEach(vehicleManager.currentVehicle.sortedFuelExpenses.prefix(3), id: \.id) { fuelExpense in
                    Button(action: {
                        selectedFuelExpense = fuelExpense
                        showEventEdit.toggle()
                    }, label: {
                        CategoryComponent(
                            category: .fuel,
                            date: fuelExpense.date,
                            cost: fuelExpense.totalPrice.description
                        )
                    })
                }
            }

            // MARK: DOCUMENTS

            titleSection(
                sectionTitle: "Documents",
                showViewAll: false
            )
            .padding()
            .padding(.top, 10)
            .padding(.bottom, -10)

            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 12)
                    HStack {
                        ForEach(documents, id: \.uuid) { document in
                            DocumentCell(title: document.title) {
                                selectedDocument = document
                                showPDF.toggle()
                            }
                        }
                        Button(action: {
                            showDocumentPicker.present()
                        }, label: {
                            addComponent(title: "Add document")
                        })
                    }
                    Spacer(minLength: 16)
                }
                .fileImporter(
                    isPresented: $presentImporter,
                    allowedContentTypes: [.pdf]
                ) { result in
                    handleFileImport(result: result)
                }
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }

            titleSection(
                sectionTitle: "Useful contacts",
                showViewAll: !vehicleManager.currentVehicle.numbers.isEmpty,
                viewAllAction: {
                    viewAllNumbers.toggle()
                }
            )
            .padding()
            .padding(.top, 10)
            .padding(.bottom, -10)

            // MARK: IMPORTANT NUMBERS

            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 12)
                    HStack {
                        ForEach(vehicleManager.currentVehicle.numbers) { number in
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://" + number.telephone)!)
                            }, label: {
                                importantNumbersComponent(title: number.title, number: number.telephone)
                            })
                        }
                        Button(action: {
                            newNumberAlert.present()
                        }, label: {
                            addComponent(title: "Add contact")
                        })
                    }
                    Spacer(minLength: 16)
                }
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }

            // Trick for scroll space, if you remove this you will see the problem
            Text("")
                .padding(.vertical, 35)
            Spacer()
        }
        .sheet(isPresented: $showEventEdit) {
            EditEventView(fuelExpense: $selectedFuelExpense)
        }
        .sheet(isPresented: $viewAllNumbers) {
            ImportantNumbersView()
                .interactiveDismissDisabled(true)
        }
        .fullScreenCover(isPresented: $showPDF) {
            DocumentView(document: $selectedDocument)
        }
        .alert(config: $newNumberAlert) {
            AddNumberView(alert: $newNumberAlert)
                .environment(\.modelContext, modelContext)
                .environmentObject(vehicleManager)
        }
        .alert(config: $showDocumentPicker) {
            ConfirmationDialog(
                items: DocumentPickerType.allCases,
                message: "Select how to upload your document",
                onTap: { value in
                    selectedDocumentType = value
                    showDocumentPicker.dismiss()
                },
                onCancel: {
                    showDocumentPicker.dismiss()
                }
            )
        }
        .onChange(of: selectedDocumentType) { _, newValue in
            guard let newValue else { return }
            switch newValue {
            case .files:
                presentImporter.toggle()
            case .photo:
                navManager.push(.docScanner)
            }
        }
    }

    @ViewBuilder
    func importantNumbersComponent(title: String, number: String) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(Palette.white)
                .shadowGrey()
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
            VStack(alignment: .leading, spacing: 22) {
                ZStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image(.wrench)
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Palette.black)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .foregroundColor(Palette.black)
                        .font(Typography.ControlS)
                    Text(number)
                        .foregroundColor(Palette.greyMiddle)
                        .font(Typography.TextM)
                        .lineLimit(1)
                        .frame(width: UIScreen.main.bounds.width * 0.25, alignment: .leading)
                }
            }
            .padding(.leading, -34)
            .padding(.top, -2)
        }
    }

    @ViewBuilder
    func addComponent(title: LocalizedStringKey) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.13)
                .foregroundColor(Palette.white)
                .shadowGrey()
            VStack(alignment: .center, spacing: 10) {
                Image(.plus)
                    .foregroundColor(Palette.greyMiddle)
                Text(title)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.ControlS)
            }
        }
    }

    private func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case let .success(url):
            processSelectedFile(url: url)
        case let .failure(error):
            // TODO: Implement proper error handling
            print("File selection failed: \(error)")
        }
    }

    private func processSelectedFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed to access security-scoped resource.")
            return
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let data = try Data(contentsOf: url)
            let documentTitle = url.lastPathComponent.replacingOccurrences(of: ".pdf", with: "")
            let newDocument = Document(data: data, title: documentTitle, fileURL: url)
            try newDocument.saveToModelContext(context: modelContext)
        } catch {
            // TODO: Implement proper error handling
            print("Error when processing document: \(error)")
        }
    }

    enum DocumentPickerType: String, CaseIterable, Identifiable {
        var id: Self { self }

        case files = "Files"
        case photo = "Photo"
    }
}

private extension BottomContentView {
    @ViewBuilder
    func titleSection(
        sectionTitle: LocalizedStringKey,
        showViewAll: Bool,
        viewAllAction: (() -> Void)? = nil
    ) -> some View {
        HStack {
            Text(sectionTitle)
                .foregroundColor(Palette.black)
                .font(Typography.headerL)
            Spacer()
            if showViewAll, let viewAllAction {
                HStack {
                    Button(action: {
                        viewAllAction()
                    }, label: {
                        Text("View all")
                            .font(Typography.ControlS)
                            .foregroundColor(Palette.greyMiddle)
                    })
                }
            }
        }
    }
}

// struct BottomContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomContentView()
//
//    }
// }

struct CategoryComponent: View {
    var category: Category
    var date: Date
    var cost: String

    @Environment(AppState.self) var appState: AppState

    var body: some View {
        HStack {
//            ZStack {
//                Circle()
//                    .frame(width: 32, height: 32)
//                    .foregroundColor(appState.currentTheme.colors.background)
//                Image(category.icon)
//                    .resizable()
//                    .frame(width: 16, height: 16)
//                    .tint(appState.currentTheme.accentColor)
//            }
            VStack(alignment: .leading) {
                HStack {
                    Text(category.label)
                        .foregroundColor(Palette.black)
                        .font(Typography.headerS)
                    Spacer()
                    Text("-\(cost) \(appState.currency)")
                        .foregroundColor(Palette.greyHard)
                        .font(Typography.headerS)
                        .padding(.trailing, -10)
                }
                Text(date.formatDate())
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
