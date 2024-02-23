import Foundation
import SwiftUI
import ZipArchive
import Network


func downloadAndUnzip(from url: URL, to destinationURL: URL, completion: @escaping (Error?) -> Void) {
    let fileManager = FileManager.default

    do {
        try fileManager.removeItem(at: destinationURL)
    } catch {
        // Ignore errors if the folder doesn't exist
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
            try fileManager.moveItem(at: tempLocalUrl, to: destinationURL)

            if fileManager.fileExists(atPath: destinationURL.path) {
                let success = SSZipArchive.unzipFile(atPath: destinationURL.path, toDestination: destinationURL.deletingLastPathComponent().path)

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
    
    if version == "0.0" {
        return AlertMessages.selectAVersion
    }
    
    let manager = FileManager.default
    var fileReference = "RemoteFiles"
    
    switch (version) {
    case "5.5":
        fileReference = "RemoteFiles";
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
    
    let zipPath = URL(filePath: Bundle.main.bundlePath)
        .appendingPathComponent("Contents")
        .appendingPathComponent("Resources")
        .appendingPathComponent(fileReference)
        .appendingPathComponent("files.zip")
    
    let targetPath = manager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        .appendingPathComponent("Application Support")
        .appendingPathComponent("cura")
        .appendingPathComponent(version)
    
    var downloadFail: Bool = false
    let downloadURL = URL(string: "https://github.com/SYNCRAFT-GITHUB/CuraFiles/releases/latest/download/files.zip")!
    downloadAndUnzip(from: downloadURL, to: zipPath) { error in
        if let error = error {
            print("Error: \(error)")
            downloadFail.toggle()
        } else {
            print("Download + unzip OK!")
        }
    }
    
    sleep(8)
    
    if downloadFail {
        return AlertMessages.internet
    }
    
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
