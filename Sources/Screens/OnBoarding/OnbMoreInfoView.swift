//
//  OnbMoreInfoView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

struct OnbMoreInfoView: View {
    let input: OnbVehicleInputData
    var body: some View {
        Text(input.name)
    }
}

#Preview {
    OnbMoreInfoView(input: OnbVehicleInputData())
}
