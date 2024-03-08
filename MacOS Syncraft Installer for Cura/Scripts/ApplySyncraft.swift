import Foundation
import SwiftUI
import ZipArchive
import Network


func downloadAndUnzip(from url: URL, to destinationURL: URL, completion: @escaping (Error?) -> Void) {
    
    let fileManager = FileManager.default
    let newLocation = destinationURL.appendingPathComponent("Cura-SyncraftFiles")
    
    do {
        try fileManager.removeItem(at: newLocation)
    } catch {
        print("Impossible to remove: \(newLocation)")
    }
    
    do {
        try fileManager.createDirectory(at: newLocation, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print("Impossible to create: \(newLocation)")
    }

    let task = URLSession.shared.downloadTask(with: url) { (tempLocalUrl, response, error) in
        
        if let error = error {
            completion(error)
            return
        }

        guard let tempLocalUrl = tempLocalUrl else {
            completion(NSError(domain: "Download Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Temporary file URL is nil."]))
            return
        }

        do {
            let zipLocation = newLocation
                .appendingPathComponent("files.zip")
            
            try fileManager.moveItem(at: tempLocalUrl, to: zipLocation)

            if fileManager.fileExists(atPath: zipLocation.path) {
                let success = SSZipArchive.unzipFile(atPath: zipLocation.path, toDestination: newLocation.path)

                if success {
                    completion(nil)
                } else {
                    completion(NSError(domain: "Unzip Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to unzip file!"]))
                }
            } else {
                completion(NSError(domain: "Download Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Download failed!"]))
            }
        } catch {
            completion(error)
        }
    }
    task.resume()
}


func applySyncraft (_ version: String, remove: Bool) -> LocalizedStringKey? {
    
    let manager = FileManager.default
    let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    var resourcesInstallerPath: URL = documentsDirectory
    var online: Bool = false
    
    if version == "0.0" {
        return AlertMessages.selectAVersion
    } else if version == "4.13" {
        resourcesInstallerPath = URL(filePath: Bundle.main.bundlePath)
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("LegacyFiles")
    } else {
        online = true
        resourcesInstallerPath = documentsDirectory
            .appendingPathComponent("Cura-SyncraftFiles")
    }
    
    let targetPath = manager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        .appendingPathComponent("Application Support")
        .appendingPathComponent("cura")
        .appendingPathComponent(version)
    
    if !targetPath.hasDirectoryPath {
        return AlertMessages.folderNotFound
    }
    
    if online {
        var displayError: String = ""
        var downloadFail: Bool = false
        let downloadURL = URL(string: "https://github.com/SYNCRAFT-GITHUB/CuraFiles/releases/latest/download/files.zip")!
        downloadAndUnzip(from: downloadURL, to: documentsDirectory) { error in
            if let error = error {
                print("Error: \(error)")
                displayError = error.localizedDescription
                downloadFail.toggle()
            } else {
                print("Download + unzip OK!")
            }
        }
        
        if downloadFail {
            return LocalizedStringKey(displayError)
        }
        
        sleep(6)
        
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
