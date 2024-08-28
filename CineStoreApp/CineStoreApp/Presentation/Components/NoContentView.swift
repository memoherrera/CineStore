//
//  NoContentView.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 27/08/24.
//

import SwiftUI

struct NoContentView: View {
    var onReload: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("No content? Please try again")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button(action: {
                onReload()
            }) {
                Text("Reload")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
