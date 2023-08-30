import Foundation
import SwiftUI

func applySyncraft (_ version: String) -> LocalizedStringKey? {
    
    if version == "0.0" {
        return AlertMessages.selectAVersion
    }
    
    let manager = FileManager.default
    
    let resourcesInstallerPath = URL(filePath: Bundle.main.bundlePath)
        .appendingPathComponent("Contents")
        .appendingPathComponent("Resources")
    
    let targetPath = manager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        .appendingPathComponent("Application Support")
        .appendingPathComponent("cura")
        .appendingPathComponent(version)
    
    if !targetPath.hasDirectoryPath {
        return AlertMessages.folderNotFound
    }
    
    do {
        for folder in try manager.contentsOfDirectory(at: resourcesInstallerPath, includingPropertiesForKeys: []) {
            if folder.hasDirectoryPath {
                let inspect = resourcesInstallerPath.appendingPathComponent(folder.lastPathComponent)
                for item in try manager.contentsOfDirectory(at: inspect, includingPropertiesForKeys: []) {
                    
                    let atPath = inspect.appendingPathComponent(item.lastPathComponent)
                    let toPath = targetPath
                        .appendingPathComponent(folder.lastPathComponent)
                        .appendingPathComponent(item.lastPathComponent)
                    
                    do {
                        try manager.copyItem(at: atPath, to: toPath)
                    } catch {
                        print (error)
                    }
                }
            }
        }
    } catch {
        return AlertMessages.installProblem
    }
    return nil
}
