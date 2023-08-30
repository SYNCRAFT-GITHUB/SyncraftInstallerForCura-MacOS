//
//  ContentView.swift
//  MacOS Syncraft Installer for Cura
//
//  Created by Rafael Neuwirth Swierczynski on 28/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var alertMessages = AlertMessages()
    
    struct Version: Hashable {
        let name: String
        let path: String
    }
    
    @State var curaVersions: [Version] = [
        Version(name: "5.4.X", path: "5.4"),
        Version(name: "5.3.X", path: "5.3"),
        Version(name: "5.2.X", path: "5.2")
    ]
    
    @State var selectedVersion = Version(name: "0.0.X", path: "0.0")
    
    func optionColor (_ version: String) -> Color {
        if selectedVersion.name == version {
            return .cyan
        } else {
            return .white
        }
    }
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(Color("background").gradient)
            
            VStack {
                VStack {
                    
                    Text ("title")
                        .font(.system(size: 45))
                    
                    Text ("subtitle")
                        .foregroundColor(.gray)
                    
                }
                .padding(.all)
                
                Text ("enablediskperm")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.callout)
                    .padding(.all)
                
                Text ("chooseversion")
                
                ForEach (curaVersions, id: \.self) { version in
                    Button (action: {selectedVersion = version}) {
                        Text (version.name)
                            .foregroundColor(optionColor(version.name))
                    }
                }
                
                Button(action: {
                    alertMessages.message = applySyncraft(selectedVersion.path) ?? LocalizedStringKey("done")
                    alertMessages.triggerAlert.toggle()
                }) {
                    Text ("install")
                }
                .padding(.all)
                
                .alert(alertMessages.message, isPresented: $alertMessages.triggerAlert) {
                    Button("OK", role: .cancel) {
                        alertMessages.triggerAlert.toggle()
                    }
                }
            }
        }
    }
}
