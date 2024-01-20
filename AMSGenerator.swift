import Foundation
import Cocoa

// Set the path to the image in the Resources folder
let imagePath = "Resources/ams_form.png"

// Load image using NSImage
guard let image = NSImage(contentsOfFile: imagePath) else {
    // Handle error loading image
    exit(1)
}

// Create a mutable copy of the image
let mutableImage = image.copy() as! NSImage

// Add text to the image
let text = "Mujo Mujic"
let textCoordinates = NSPoint(x: 290, y: 1190) // Adjusted coordinates

mutableImage.lockFocus()

// Use NSFont and NSColor for text attributes
let textAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 22),
    .foregroundColor: NSColor.black
]

// Draw the text onto the image at the specified coordinates
let attributedText = NSAttributedString(string: text, attributes: textAttributes)
let textSize = attributedText.size()
let rect = NSRect(origin: textCoordinates, size: textSize)

attributedText.draw(with: rect)

mutableImage.unlockFocus()

// Save the final image to the same Resources folder
let outputURL = URL(fileURLWithPath: "Resources/output.png")
if let data = mutableImage.tiffRepresentation {
    do {
        try data.write(to: outputURL)
        print("Image saved to \(outputURL.path)")
    } catch {
        print("Error saving image: \(error)")
    }
} else {
    print("Error getting tiff representation of the image.")
}













