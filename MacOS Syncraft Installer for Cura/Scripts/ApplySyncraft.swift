import Foundation
import SwiftUI

func applySyncraft (_ version: String, remove: Bool) -> LocalizedStringKey? {
    
    if version == "0.0" {
        return AlertMessages.selectAVersion
    }
    
    let manager = FileManager.default
    var fileReference = "NewFiles"
    
    switch (version) {
    case "5.5":
        fileReference = "NewFiles";
        break;
    case "5.4":
        fileReference = "NewFiles";
        break;
    case "5.3":
        fileReference = "OldFiles";
        break;
    case "4.13":
        fileReference = "LegacyFiles";
        break;
    default:
        return AlertMessages.selectAVersion
    }
    
    
    let resourcesInstallerPath = URL(filePath: Bundle.main.bundlePath)
        .appendingPathComponent("Contents")
        .appendingPathComponent("Resources")
        .appendingPathComponent(fileReference)
    
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
                        
                        if remove {
                            try manager.removeItem(at: toPath)
                        } else {
                            try manager.copyItem(at: atPath, to: toPath)
                        }
                        
                    } catch {
                        print (error)
                    }
                }
            }
        }
    } catch {
        return remove ? AlertMessages.removeProblem : AlertMessages.installProblem
    }
    return nil
}
