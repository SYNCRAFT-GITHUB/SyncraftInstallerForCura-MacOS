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
            return .teal
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
                    
                }
                .padding(.all)
                
                Text ("enablediskperm")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .padding(.top)
                
                Text ("ifpermgranted")
                    .multilineTextAlignment(.center)
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
                    alertMessages.message = applySyncraft(selectedVersion.path, remove: false) ?? LocalizedStringKey("done")
                    alertMessages.triggerAlert.toggle()
                }) {
                    Text ("install")
                        .font(.headline)
                }
                .padding(.top)
                
                Button(action: {
                    alertMessages.message = applySyncraft(selectedVersion.path, remove: true) ?? LocalizedStringKey("done")
                    alertMessages.triggerAlert.toggle()
                }) {
                    Text ("remove")
                        .font(.system(size: 12))
                }
                .padding(.bottom)
                
                .alert(alertMessages.message, isPresented: $alertMessages.triggerAlert) {
                    Button("OK", role: .cancel) {
                        alertMessages.triggerAlert.toggle()
                    }
                }
            }
        }
    }
}
