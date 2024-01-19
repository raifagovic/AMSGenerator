import Foundation
import Cocoa
import CoreGraphics
import CoreServices

// Set the path to the image in the Resources folder
let imagePath = "Resources/ams_form.png"

// Load image using NSImage
guard let image = NSImage(contentsOfFile: imagePath),
      let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    // Handle error loading image
    exit(1)
}

// Create a mutable bitmap context
let width = cgImage.width
let height = cgImage.height

let colorSpace = CGColorSpaceCreateDeviceRGB()
let bytesPerPixel = 4
let bytesPerRow = bytesPerPixel * width
let bitsPerComponent = 8

guard let context = CGContext(data: nil,
                              width: width,
                              height: height,
                              bitsPerComponent: bitsPerComponent,
                              bytesPerRow: bytesPerRow,
                              space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
    // Handle error creating graphics context
    exit(1)
}

// Draw the original image into the context
context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

// Add text to the image
let text = "John Doe"
let textCoordinates = CGPoint(x: 100, y: 200)

// Use NSFont and NSColor for text attributes
text.draw(at: textCoordinates, withAttributes: [
    .font: NSFont.systemFont(ofSize: 12),
    .foregroundColor: NSColor.black
])

// Save the final image to the same Resources folder
let outputURL = URL(fileURLWithPath: "Resources/output.png")
guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, kUTTypePNG, 1, nil) else {
    // Handle error creating image destination
    exit(1)
}

CGImageDestinationAddImage(destination, context.makeImage()!, nil)
CGImageDestinationFinalize(destination)

print("Image saved to \(outputURL.path)")




