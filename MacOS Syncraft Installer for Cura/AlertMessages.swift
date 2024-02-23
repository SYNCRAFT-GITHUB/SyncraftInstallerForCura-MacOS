import Foundation
import SwiftUI

final class AlertMessages: ObservableObject {
    
    @Published var triggerAlert: Bool = false
    
    @Published var message: LocalizedStringKey = ""
    
    static let folderNotFound = LocalizedStringKey("foldernotfound")
    
    static let selectAVersion = LocalizedStringKey("chooseversion")
    
    static let installProblem = LocalizedStringKey("installproblem")
    
    static let removeProblem = LocalizedStringKey("removeproblem")
    
    static let internet = LocalizedStringKey("requiresweb")
    
}
