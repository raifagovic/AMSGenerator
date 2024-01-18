import Foundation
import CoreGraphics
import CoreImage
import CoreText

// Function to add text to an image
func addTextToImage(image: NSImage, text: String, coordinates: CGPoint) -> NSImage {
    let imageRect = NSRect(origin: .zero, size: image.size)

    let bitmap = NSBitmapImageRep(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)

    // Draw the original image
    image.draw(in: imageRect)

    // Draw text on the image
    let textAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 12),
        .foregroundColor: NSColor.black
    ]

    let attributedText = NSAttributedString(string: text, attributes: textAttributes)
    attributedText.draw(at: coordinates)

    NSGraphicsContext.restoreGraphicsState()

    let resultImage = NSImage(size: image.size)
    resultImage.addRepresentation(bitmap)

    return resultImage
}

// Function to export an image as a PDF
func exportImageAsPDF(image: NSImage, outputPath: String) {
    let pdfData = image.pdf()

    do {
        try pdfData.write(to: URL(fileURLWithPath: outputPath))
        print("PDF exported successfully.")
    } catch {
        print("Error exporting PDF: \(error.localizedDescription)")
    }
}

// Example usage
let imagePath = "path/to/your/image.png"
let outputPDFPath = "path/to/your/output.pdf"
let image = NSImage(contentsOfFile: imagePath)!

let newText = "Hello, Swift!"
let textCoordinates = CGPoint(x: 100, y: 100)

let imageWithText = addTextToImage(image: image, text: newText, coordinates: textCoordinates)
exportImageAsPDF(image: imageWithText, outputPath: outputPDFPath)

