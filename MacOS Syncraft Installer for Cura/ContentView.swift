import SwiftUI

struct ContentView: View {
    
    @ObservedObject var alertMessages = AlertMessages()
    @State var customVersion: [Int?] = [nil, nil]
    @State var showCustomVersion: Bool = false
    
    struct Version: Hashable {
        let name: String
        let path: String
        let stable: Bool
    }
    
    @State var curaVersions: [Version] = [
        Version(name: "5.7.X", path: "5.7", stable: true),
        Version(name: "5.6.X", path: "5.6", stable: true),
        Version(name: "5.5.X", path: "5.5", stable: true),
    ]
    
    @State var selectedVersion = Version(name: "0.0.X", path: "0.0", stable: true)
    
    func resetCustomVersion () {
        customVersion[0] = nil
        customVersion[1] = nil
    }
    
    func customVersionPath() -> String {
        return "\(customVersion[0] ?? 0).\(customVersion[1] ?? 0)"
    }
    
    func isCustomVersionClean() -> Bool {
        return customVersion[0] == nil && customVersion[1] == nil
    }
    
    func resetSelectedVersion () {
        selectedVersion = Version(name: "0.0.X", path: "0.0", stable: true)
    }
    
    func showAppVersion () -> some View {
        let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Syncraft"
        return HStack {
            Spacer()
            VStack {
                Spacer()
                Text ("\(ver)")
                    .opacity(0.6)
                    .font(.callout)
                    .padding(.all)
            }
        }
    }
    
    func optionColor (_ version: String?) -> Color {
        if selectedVersion.name == version && isCustomVersionClean() {
            return .black
        } else {
            resetSelectedVersion()
            return .white
        }
    }
    
    var body: some View {
        
        ZStack {
            LinearGradient (
                gradient: Gradient(
                    colors: [Color("background"),
                             Color("bluedark")]),
                startPoint: .top,
                endPoint: .bottom )
                .ignoresSafeArea()
            
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
                        Button (action: {resetCustomVersion(); selectedVersion = version}) {
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
                    .frame(width: 220)
                }
                
                // CUSTOM VERSION
                HStack {
                    HStack{
                        if showCustomVersion {
                            HStack {
                                TextField("?", value: $customVersion[0], format: .number)
                                TextField("?", value: $customVersion[1], format: .number)
                            }
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 110)
                            .onChange(of: customVersion) { _ in
                                resetSelectedVersion()
                            }
                        } else {
                            Button (action: {showCustomVersion = true}) {
                                Text ("＊")
                            }
                        }
                    }
                    Spacer()
                    Text("custom")
                        .foregroundStyle(isCustomVersionClean() ? Color.gray : Color.black)
                    Spacer()
                        .frame(width: 8)
                }
                .background(
                    Color.brown.opacity(0.4).blur(radius: 17.0)
                )
                .cornerRadius(5.0)
                .frame(width: 220)
                .padding(.top)
                
                Button(action: {
                    alertMessages.message = applySyncraft(selectedVersion.path, remove: false, customVersionPath()) ?? LocalizedStringKey("done")
                    alertMessages.triggerAlert.toggle()
                }) {
                    Text ("install")
                        .font(.headline)
                }
                .padding(.top)
                
                Button(action: {
                    alertMessages.message = applySyncraft(selectedVersion.path, remove: true, customVersionPath()) ?? LocalizedStringKey("done")
                    alertMessages.triggerAlert.toggle()
                }) {
                    Text ("remove")
                        .font(.system(size: 12))
                }
                
                Spacer()
                    .frame(height: 16)
                
                Button(action: {
                    let result = openFolder(isCustomVersionClean() ? selectedVersion.path : customVersionPath())
                    if (result != nil) {
                        alertMessages.message = result!
                        alertMessages.triggerAlert.toggle()
                    }
                }) {
                    Text ("openfolder")
                        .font(.system(size: 12))
                }
                
                Group {
                    
                    Link("downloadCuraAppleSilicon", destination: URL(string: "https://github.com/Ultimaker/Cura/releases/download/5.7.2-RC2/UltiMaker-Cura-5.7.2-macos-ARM64.dmg")!)
                        .padding(.top)
                    
                    Link("downloadCuraIntel", destination: URL(string: "https://github.com/Ultimaker/Cura/releases/download/5.7.2-RC2/UltiMaker-Cura-5.7.2-macos-X64.dmg")!)
                    
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
