//
//  Handle.swift
//  Spends
//
//  Created by victor amaro on 16/02/25.
//

import Foundation
import SwiftUI

struct Handle: View {
    
    private let handleThickness = CGFloat(3.0)
    
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
            
    }
}
