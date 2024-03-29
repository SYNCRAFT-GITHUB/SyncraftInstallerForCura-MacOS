import SwiftUI

struct ContentView: View {
    
    @ObservedObject var alertMessages = AlertMessages()
    
    struct Version: Hashable {
        let name: String
        let path: String
        let stable: Bool
    }
    
    @State var curaVersions: [Version] = [
        Version(name: "5.7.X", path: "5.7", stable: false),
        Version(name: "5.6.X", path: "5.6", stable: false),
        Version(name: "5.5.X", path: "5.5", stable: true),
        Version(name: "4.13.X", path: "4.13", stable: true)
    ]
    
    @State var selectedVersion = Version(name: "0.0.X", path: "0.0", stable: true)
    
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
            return .indigo
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
                
                Text ("chooseversion")
                    .padding(.bottom)
                
                ForEach (curaVersions, id: \.self) { version in
                    HStack {
                        Button (action: {selectedVersion = version}) {
                            Text (version.name)
                                .foregroundColor(optionColor(version.name))
                        }
                        Spacer()
                        Text(version.stable ? "stable" : "unstable")
                            .foregroundStyle(version.stable ? Color.green : Color.yellow)
                        Spacer()
                            .frame(width: 8)
                    }
                    .background(
                        version.stable ? Color.green.opacity(0.4).blur(radius: 17.0)
                        : Color.yellow.opacity(0.4).blur(radius: 17.0)
                    )
                    .cornerRadius(5.0)
                    .frame(width: 165)
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
                
                Spacer()
                    .frame(height: 16)
                
                Button(action: {
                    let result = openFolder(selectedVersion.path)
                    if (result != nil) {
                        alertMessages.message = result!
                        alertMessages.triggerAlert.toggle()
                    }
                }) {
                    Text ("openfolder")
                        .font(.system(size: 12))
                }
                
                Group {
                    
                    Link("downloadCuraAppleSilicon", destination: URL(string: "https://github.com/Ultimaker/Cura/releases/download/5.5.0/UltiMaker-Cura-5.5.0-macos-ARM64.dmg")!)
                        .padding(.top)
                    
                    Link("downloadCuraIntel", destination: URL(string: "https://github.com/Ultimaker/Cura/releases/download/5.5.0/UltiMaker-Cura-5.5.0-macos-X64.dmg")!)
                    
                }
                .font(.system(size: 14))
                .foregroundColor(.cyan)
                
                Spacer()
                    .frame(height: 18)
                
                .alert(alertMessages.message, isPresented: $alertMessages.triggerAlert) {
                    Button("OK", role: .cancel) {
                        alertMessages.triggerAlert.toggle()
                    }
                }
            }
        }
    }
}
