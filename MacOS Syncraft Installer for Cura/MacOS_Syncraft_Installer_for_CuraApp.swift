import SwiftUI

@main
struct MacOS_Syncraft_Installer_for_CuraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(AlertMessages())
        }
    }
}
