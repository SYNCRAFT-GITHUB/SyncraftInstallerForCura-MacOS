import Foundation
import SwiftUI

final class AlertMessages: ObservableObject {
    
    @Published var triggerAlert: Bool = false
    
    @Published var message: LocalizedStringKey = ""
    
    static let folderNotFound = LocalizedStringKey("foldernotfound")
    
    static let selectAVersion = LocalizedStringKey("pleaseselectversion")
    
    static let installProblem = LocalizedStringKey("installproblem")
    
}
