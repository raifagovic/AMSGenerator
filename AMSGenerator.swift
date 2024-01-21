import Foundation
import Cocoa

// Set the path to the PNG image in the Resources folder
let imagePath = "Resources/ams_form.png"

// Load PNG image using NSImage
guard let image = NSImage(contentsOfFile: imagePath) else {
    // Handle error loading image
    exit(1)
}

// Create a mutable copy of the image
let mutableImage = image.copy() as! NSImage

// Prompt user for "Ime i prezime:" and get input
print("Ime i prezime:", terminator: " ")
if let userInput = readLine() {
    // Add user input as text to the image
    let name = userInput
    let textCoordinates = NSPoint(x: 290, y: 1190) // Adjusted coordinates

    mutableImage.lockFocus()

    // Use NSFont and NSColor for text attributes
    let textAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 27), // Adjusted font size to 27
        .foregroundColor: NSColor.black
    ]

    // Draw the text onto the image at the specified coordinates
    let attributedText = NSAttributedString(string: name, attributes: textAttributes)
    let textSize = attributedText.size()
    let rect = NSRect(origin: textCoordinates, size: textSize)

    attributedText.draw(with: rect)

    mutableImage.unlockFocus()

    // Save the final image in JPEG format to the same Resources folder
    let outputURL = URL(fileURLWithPath: "Resources/output.jpg")
    if let cgImage = mutableImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: .jpeg, properties: [:])
        
        do {
            try jpegData?.write(to: outputURL)
            print("Image saved to \(outputURL.path)")
        } catch {
            print("Error saving image: \(error)")
        }
    } else {
        print("Error getting CGImage representation of the image.")
    }
} else {
    print("Error reading user input.")
}
















