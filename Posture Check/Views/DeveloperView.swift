//
//  DeveloperView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/31/22.
// // MARK: Solo para uso interno!

import SwiftUI

struct DeveloperView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Place below controls to alter user progress for testing purpose.")
                    .font(.largeTitle.bold())
            }
            .navigationTitle("Developer Mode")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
