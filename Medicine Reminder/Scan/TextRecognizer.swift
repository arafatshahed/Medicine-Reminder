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
                return cgImage
            }
            let imagesAndRequests = images.map { (image: $0, request: VNRecognizeTextRequest()) }
            let textPerPage = imagesAndRequests.map { image, request -> String in
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = false
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

