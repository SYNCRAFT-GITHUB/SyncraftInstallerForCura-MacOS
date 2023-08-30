//
//  AlertMessages.swift
//  MacOS Syncraft Installer for Cura
//
//  Created by Rafael Neuwirth Swierczynski on 30/08/23.
//

import Foundation
import SwiftUI

final class AlertMessages: ObservableObject {
    
    @Published var triggerAlert: Bool = false
    
    @Published var message: LocalizedStringKey = ""
    
    static let folderNotFound = LocalizedStringKey("foldernotfound")
    
    static let selectAVersion = LocalizedStringKey("pleaseselectversion")
    
    static let installProblem = LocalizedStringKey("installproblem")
    
}
