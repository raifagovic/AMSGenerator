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

// Function to draw formatted date on the image
func drawFormattedDate(_ dateInput: String, at coordinates: NSPoint, with attributes: [NSAttributedString.Key: Any]) {
    var currentX = coordinates.x

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy."

    if let date = dateFormatter.date(from: dateInput) {
        dateFormatter.dateFormat = "ddMMyy"
        let formattedDate = dateFormatter.string(from: date)

        for (index, digit) in formattedDate.enumerated() {
            let spacing: CGFloat = (index == 2 || index == 4) ? 48 : 25.5

            if index == 0 {
                currentX += 0 // If the first digit, no initial spacing
            } else {
                currentX += spacing
            }

            let digitText = NSAttributedString(string: String(digit), attributes: attributes)
            let digitSize = digitText.size()
            let digitRect = NSRect(origin: NSPoint(x: currentX, y: coordinates.y), size: digitSize)
            digitText.draw(with: digitRect)

            // Move to the next position with the calculated spacing
            currentX += digitSize.width
        }
    }
}

// Prompt user for "Ime i prezime:" and get input
print("Ime i prezime:", terminator: " ")
if let name = readLine() {
    // Prompt user for "Adresa:" and get input
    print("Adresa:", terminator: " ")
    if let address = readLine() {
        // Prompt user for 13-digit identification number and get input
        print("Identification Number (13 digits):", terminator: " ")
        if let identificationNumber = readLine(), identificationNumber.count == 13 {
            // Prompt user for "Datum:" and get input
            print("Datum (dd.mm.yyyy.):", terminator: " ")
            if let dateInput = readLine() {
                // Add user input as text to the image
                let nameCoordinates = NSPoint(x: 120, y: 1170) // Adjusted coordinates for name
                let addressCoordinates = NSPoint(x: 120, y: 1090) // Adjusted coordinates for address
                let identificationNumberCoordinates = NSPoint(x: 1010, y: 1180) // Updated coordinates for identification number
                let dateCoordinates = NSPoint(x: 1100, y: 1090) // Updated coordinates for date

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

                // Draw the identification number onto the image at the specified coordinates
                var currentX = identificationNumberCoordinates.x

                for digit in identificationNumber {
                    let digitText = NSAttributedString(string: String(digit), attributes: textAttributes)
                    let digitSize = digitText.size()
                    let digitRect = NSRect(origin: NSPoint(x: currentX, y: identificationNumberCoordinates.y), size: digitSize)
                    digitText.draw(with: digitRect)

                    // Move to the next position with spacingBetweenDigits
                    currentX += digitSize.width + 25.5
                }

                // Draw the formatted date onto the image at the specified coordinates
                drawFormattedDate(dateInput, at: dateCoordinates, with: textAttributes)

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
                print("Error reading date input.")
            }
        } else {
            print("Error: Please enter a 13-digit identification number.")
        }
    } else {
        print("Error reading address input.")
    }
} else {
    print("Error reading name input.")
}



































