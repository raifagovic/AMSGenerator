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
if let name = readLine() {
    // Prompt user for "Adresa:" and get input
    print("Adresa:", terminator: " ")
    if let address = readLine() {
        // Add user input as text to the image
        let nameCoordinates = NSPoint(x: 290, y: 1190) // Adjusted coordinates for name
        let addressCoordinates = NSPoint(x: 250, y: 1100) // Adjusted coordinates for address

        mutableImage.lockFocus()

        // Use NSFont and NSColor for text attributes
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 27), // Adjusted font size to 27
            .foregroundColor: NSColor.black
        ]

        // Draw the name onto the image at the specified coordinates
        let nameText = NSAttributedString(string: name, attributes: textAttributes)
        let nameSize = nameText.size()
        let nameRect = NSRect(origin: nameCoordinates, size: nameSize)
        nameText.draw(with: nameRect)

        // Draw the address onto the image at the specified coordinates
        let addressText = NSAttributedString(string: address, attributes: textAttributes)
        let addressSize = addressText.size()
        let addressRect = NSRect(origin: addressCoordinates, size: addressSize)
        addressText.draw(with: addressRect)

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
        print("Error reading address input.")
    }
} else {
    print("Error reading name input.")
}

















