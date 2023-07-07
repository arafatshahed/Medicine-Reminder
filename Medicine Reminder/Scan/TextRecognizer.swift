//
//  TextRecognizer.swift
//  Medicine Reminder
//
//  Created by BJIT on 13/6/23.
//

import Foundation
import Vision
import VisionKit
import UIKit

final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan
    init(cameraScan:VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    private let queue = DispatchQueue(label: "scan-codes", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    func recognizeText(withCompletionHandler completionHandler:@escaping ([String])-> Void) {
        queue.async {
            let images: [CGImage]  = (0..<self.cameraScan.pageCount).compactMap {
                guard let cgImage = self.cameraScan.imageOfPage(at: $0).cgImage else {
                    return nil
                }
                let grayscaleImage = UIImage(cgImage: cgImage).convertToGrayscale()?.cgImage
                return grayscaleImage
            }
            let imagesAndRequests = images.map { (image: $0, request: VNRecognizeTextRequest()) }
            let textPerPage = imagesAndRequests.map { image, request -> String in
                request.recognitionLevel = .accurate
                request.recognitionLanguages = ["en_US"]
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do{
                    try handler.perform([request])
                    guard let observations = request.results else{return ""}
                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                }
                catch{
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}

extension UIImage {
    func convertToGrayscale() -> UIImage? {
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        
        context.draw(cgImage!, in: imageRect)
        
        guard let grayscaleImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: grayscaleImage)
    }
}

