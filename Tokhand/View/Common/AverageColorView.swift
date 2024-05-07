//
//  AverageColorView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation
import SwiftUI
import UIKit

struct AverageColorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Capture the rendered view as UIImage
        guard let image = uiView.asImage() else {
            print("Failed to convert UIView to UIImage")
            return
        }
        
        // Get the average color from the UIImage
        let averageColor = image.averageColor
        
        // Do something with the average color, such as updating UI or performing an action
        print("Average color: \(averageColor)")
    }
}

extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        // Create a Core Image context
        let context = CIContext(options: nil)
        
        // Define the parameters for the CIColorMonochrome filter
        let filterParams: [String: Any] = [
            kCIInputImageKey: inputImage,
            kCIInputIntensityKey: 1.0
        ]
        
        // Apply the filter to the image
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: filterParams),
              let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        // Get the average color from the output image
        let uiColor = UIColor(cgColor: cgImage.averageColor ?? Color.clear.cgColor!)
        return uiColor
    }
}

extension CGImage {
    var averageColor: CGColor? {
        let width = self.width
        let height = self.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue)
        else { return nil }
        
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = context.data else { return nil }
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        var count = 0
        
        let buffer = UnsafeBufferPointer<UInt8>(start: pixelData.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel), count: width * height * bytesPerPixel)
        
        for pixelIndex in stride(from: 0, to: buffer.count, by: bytesPerPixel) {
            let red = Int(buffer[pixelIndex])
            let green = Int(buffer[pixelIndex + 1])
            let blue = Int(buffer[pixelIndex + 2])
            
            totalRed += red
            totalGreen += green
            totalBlue += blue
            
            count += 1
        }
        
        let averageRed = totalRed / count
        let averageGreen = totalGreen / count
        let averageBlue = totalBlue / count
        
        return CGColor(srgbRed: CGFloat(averageRed) / 255.0,
                       green: CGFloat(averageGreen) / 255.0,
                       blue: CGFloat(averageBlue) / 255.0,
                       alpha: 1.0)
    }
}

