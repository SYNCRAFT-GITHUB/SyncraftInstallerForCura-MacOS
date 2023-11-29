import SwiftUI

struct ContentView: View {
    
    @ObservedObject var alertMessages = AlertMessages()
    
    struct Version: Hashable {
        let name: String
        let path: String
    }
    
    @State var curaVersions: [Version] = [
        Version(name: "5.6.X", path: "5.6"),
        Version(name: "5.5.X", path: "5.5"),
        Version(name: "4.13.X", path: "4.13")
    ]
    
    @State var selectedVersion = Version(name: "0.0.X", path: "0.0")
    
    func showAppVersion () -> some View {
        let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Syncraft"
        return HStack {
            Spacer()
            VStack {
                Spacer()
                Text ("\(ver)")
                    .opacity(0.5)
                    .font(.callout)
                    .padding(.all)
            }
        }
    }
    
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
            
            showAppVersion()
            
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
                    .padding(.bottom)
                
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
