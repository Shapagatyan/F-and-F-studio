//
//  DocumentManager.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 26.09.22.
//

import UIKit

class DocumentManager {

    static let shared = DocumentManager()

    private var documentDirectory: URL? {
        let fileManager = FileManager.default
        do {
            return try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - Public methods
extension DocumentManager {


    // MARK: Save image
    public func saveImage(id: String, image: UIImage?) {
        guard let url = documentDirectory, let pngData = image?.pngData() else { return }

        do {
            // Create driectory for puzzle
            let fileManager = FileManager.default
            try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)

            let imageUrl = url.appendingPathComponent("\(id).png")
            try pngData.write(to: imageUrl)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    // MARK: Get image
    public func getImage(id: String) -> UIImage? {
        guard let url = documentDirectory else { return nil }
        let imageUrl = url.appendingPathComponent("\(id).png")
        do {
            let data = try Data(contentsOf: imageUrl)
            return UIImage(data: data)
        } catch {
            debugPrint(error.localizedDescription)
        }

        return nil
    }

}
