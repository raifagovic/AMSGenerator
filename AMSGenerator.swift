import Foundation
import CoreGraphics
import CoreServices

// Set the path to the image in the Resources folder
let imagePath = "Resources/ams_form.png"

// Create a mutable bitmap context from the image
let inputURL = URL(fileURLWithPath: imagePath)
guard let imageSource = CGImageSourceCreateWithURL(inputURL as CFURL, nil),
      let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
    // Handle error loading image
    exit(1)
}

let width = cgImage.width
let height = cgImage.height

let colorSpace = CGColorSpaceCreateDeviceRGB()
let bytesPerPixel = 4
let bitsPerComponent = 8

guard let context = CGContext(data: nil,
                              width: width,
                              height: height,
                              bitsPerComponent: bitsPerComponent,
                              bytesPerRow: bytesPerPixel * width,
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

// Use Core Text for text drawing
let textFont = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
let textString = NSAttributedString(string: text, attributes: [.font: textFont, .foregroundColor: CGColor.black] as [NSAttributedString.Key : Any])
let textLine = CTLineCreateWithAttributedString(textString)
context.textPosition = textCoordinates
CTLineDraw(textLine, context)

// Save the final image to the same Resources folder
let outputURL = URL(fileURLWithPath: "Resources/output.png")
guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, kUTTypePNG, 1, nil) else {
    // Handle error creating image destination
    exit(1)
}

CGImageDestinationAddImage(destination, context.makeImage()!, nil)
CGImageDestinationFinalize(destination)

print("Image saved to \(outputURL.path)")










