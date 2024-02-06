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
            let spacing: CGFloat = (index == 2 || index == 4) ? 45 : 25.5
            
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

// Function to draw formatted month and year on the image
func drawFormattedMonthYear(_ monthYearInput: String, at coordinates: NSPoint, with attributes: [NSAttributedString.Key: Any]) {
    var currentX = coordinates.x
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.yyyy."
    
    // Parse the month and year input
    let components = monthYearInput.components(separatedBy: ".")
    if components.count == 2, let month = Int(components[0]), let year = Int(components[1]) {
        let formattedMonthYear = String(format: "%02d %02d", month, year % 100)
        
        for (index, digit) in formattedMonthYear.enumerated() {
            let spacing: CGFloat = (index == 2) ? 52 : 25.5
            
            if index == 0 {
                currentX += 0
            } else {
                currentX += spacing
            }
            
            let digitText = NSAttributedString(string: String(digit), attributes: attributes)
            let digitSize = digitText.size()
            let digitRect = NSRect(origin: NSPoint(x: currentX, y: coordinates.y), size: digitSize)
            digitText.draw(with: digitRect)
            
            currentX += digitSize.width
        }
    }
}

func drawFormattedDateNormal(_ dateInput: String, at coordinates: NSPoint, with attributes: [NSAttributedString.Key: Any]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy."
    
    if let date = dateFormatter.date(from: dateInput) {
        let formattedDate = dateFormatter.string(from: date)
        
        let dateText = NSAttributedString(string: formattedDate, attributes: attributes)
        let dateSize = dateText.size()
        let dateRect = NSRect(origin: coordinates, size: dateSize)
        dateText.draw(with: dateRect)
    }
}

// Command-line arguments
let arguments = CommandLine.arguments

// Flags and their default values
var name: String = ""
var address: String = ""
var identificationNumber: String = ""
var dateInput: String = ""
var monthYearFlag: String = ""
var payerData: [(name: String, address: String, country: String, amount: Double, deduction: Int)] = []

// Parse command-line arguments
for (index, argument) in arguments.enumerated() {
    switch argument {
    case "-n":
        // Flag for name
        if index + 1 < arguments.count {
            name = arguments[index + 1]
        }
    case "-a":
        // Flag for address
        if index + 1 < arguments.count {
            address = arguments[index + 1]
        }
    case "-i":
        // Flag for identification number
        if index + 1 < arguments.count {
            identificationNumber = arguments[index + 1]
        }
    case "-d":
        // Flag for date
        if index + 1 < arguments.count {
            dateInput = arguments[index + 1]
        }
    case "-m":
        // Flag for month and year
        if index + 1 < arguments.count {
            monthYearFlag = arguments[index + 1].trimmingCharacters(in: .punctuationCharacters)
        }
        
    case "-p":
        // Flag for payer name
        if index + 1 < arguments.count {
            let payerName = arguments[index + 1]
            let payerAddress = arguments[index + 2] // Assuming the next argument is address
            let payerCountry = arguments[index + 3] // Assuming the next argument is country
            let amountIndex = arguments.firstIndex(of: "-amount\(index + 1)") // Get index of amount flag
            let deductionIndex = arguments.firstIndex(of: "-deduction\(index + 1)") // Get index of deduction flag
            
            if let amountIndex = amountIndex, let deductionIndex = deductionIndex, amountIndex + 1 < arguments.count, deductionIndex + 1 < arguments.count {
                if let amount = Double(arguments[amountIndex + 1]), let deduction = Int(arguments[deductionIndex + 1]) {
                    payerData.append((name: payerName, address: payerAddress, country: payerCountry, amount: amount, deduction: deduction))
                }
            }
        }
        //    case "-p":
        //        // Flag for payer name
        //        if index + 1 < arguments.count {
        //            payerName = arguments[index + 1]
        //        }
        //    case "-pa":
        //        // Flag for payer address
        //        if index + 1 < arguments.count {
        //            payerAddress = arguments[index + 1]
        //        }
        //    case "-pc":
        //        // Flag for payer country
        //        if index + 1 < arguments.count {
        //            payerCountry = arguments[index + 1]
        //        }
        //    case "-amount":
        //        // Flag for payment amount
        //        if index + 1 < arguments.count, let amountValue = Double(arguments[index + 1]) {
        //            paymentAmount = amountValue - Double(deduction)
        //        } else {
        //            print("Invalid amount format.")
        //            exit(1)
        //        }
        //    case "-deduction":
        //        // Flag for deduction
        //        if index + 1 < arguments.count, let deductionValue = Int(arguments[index + 1]) {
        //            deduction = deductionValue
        //        } else {
        //            print("Invalid deduction format.")
        //            exit(1)
        //        }
    default:
        break
    }
}

// Default to today's date if -d flag is not provided
if dateInput.isEmpty {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy."
    dateInput = dateFormatter.string(from: currentDate)
}

// Default value for monthYearFlag if not provided
if monthYearFlag.isEmpty {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.yyyy."
    monthYearFlag = dateFormatter.string(from: currentDate)
}

// Calculate deduction value
let calculatedDeduction = Double(deduction) / 100 * paymentAmount

// Calculate amount of income (amount - calculatedDeduction)
let amountOfIncome = paymentAmount - calculatedDeduction

// Calculate health insurance value (4% of the amountOfIncome)
let healthInsurance = amountOfIncome * 0.04

// Calculate taxBase
let taxBase = amountOfIncome - healthInsurance

// Calculate taxAmount
let taxAmount = taxBase * 0.1

let taxCreditPaidAbroad: Int = 0

// Calculate taxDifferenceForPayment
let taxDifferenceForPayment = taxAmount - Double(taxCreditPaidAbroad)

// Add user input as text to the image
// (Use amountOfIncome instead of paymentAmount for drawing)
let nameCoordinates = NSPoint(x: 120, y: 1170)
let addressCoordinates = NSPoint(x: 120, y: 1090)
let identificationNumberCoordinates = NSPoint(x: 1010, y: 1180)
let dateCoordinates = NSPoint(x: 1100, y: 1090)
let monthYearCoordinates = NSPoint(x: 1805, y: 1165)
let payerNameCoordinates = NSPoint(x: 120, y: 925)
let payerAddressCoordinates = NSPoint(x: 945, y: 925)
let payerCountryCoordinates = NSPoint(x: 1780, y: 925)
let amountOfIncomeCoordinates = NSPoint(x: 285, y: 690)
let deductionCoordinates = NSPoint(x: 0, y: 0)
let healthInsuranceCoordinates = NSPoint(x: 700, y: 690)
let taxBaseCoordinates = NSPoint(x: 1020, y: 690)
let taxAmountCoordinates = NSPoint(x: 1360, y: 690)
let taxCreditPaidAbroadCoordinates = NSPoint(x: 1710, y: 690)
let taxDifferenceForPaymentCoordinates = NSPoint(x: 2025, y: 690)
let normalDateCoordinates = NSPoint(x: 1920, y: 135)
let spacingBetweenDigits: CGFloat = 25.5

// Generate output image for each payer
for (index, payer) in payerData.enumerated() {
    let mutableImage = image.copy() as! NSImage // Create a mutable copy of the image for each payer
    
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
        currentX += digitSize.width + spacingBetweenDigits
    }
    
    // Draw the formatted date onto the image at the specified coordinates
    drawFormattedDate(dateInput, at: dateCoordinates, with: textAttributes)
    
    // Draw the formatted month and year onto the image at the specified coordinates
    drawFormattedMonthYear(monthYearFlag, at: monthYearCoordinates, with: textAttributes)
    
    // Draw the normal formatted date onto the image at the specified coordinates
    drawFormattedDateNormal(dateInput, at: normalDateCoordinates, with: textAttributes)
    
    // Draw the payer name onto the image at the specified coordinates
    let payerNameText = NSAttributedString(string: payerName, attributes: textAttributes)
    let payerNameSize = payerNameText.size()
    let payerNameRect = NSRect(origin: payerNameCoordinates, size: payerNameSize)
    payerNameText.draw(with: payerNameRect)
    
    // Draw the payer address onto the image at the specified coordinates
    let payerAddressText = NSAttributedString(string: payerAddress, attributes: textAttributes)
    let payerAddressSize = payerAddressText.size()
    let payerAddressRect = NSRect(origin: payerAddressCoordinates, size: payerAddressSize)
    payerAddressText.draw(with: payerAddressRect)
    
    // Draw the payer country onto the image at the specified coordinates
    let payerCountryText = NSAttributedString(string: payerCountry, attributes: textAttributes)
    let payerCountrySize = payerCountryText.size()
    let payerCountryRect = NSRect(origin: payerCountryCoordinates, size: payerCountrySize)
    payerCountryText.draw(with: payerCountryRect)
    
    // Format amountOfIncome to display with comma as the decimal separator
    let formattedAmountOfIncome = String(format: "%.2f", amountOfIncome).replacingOccurrences(of: ".", with: ",")
    
    // Draw the payment amount onto the image at the specified coordinates
    let amountOfIncomeText = NSAttributedString(string: formattedAmountOfIncome, attributes: textAttributes)
    let amountOfIncomeSize = amountOfIncomeText.size()
    let amountOfIncomeRect = NSRect(origin: amountOfIncomeCoordinates, size: amountOfIncomeSize)
    amountOfIncomeText.draw(with: amountOfIncomeRect)
    
    // Format healthInsurance to display with comma as the decimal separator
    let formattedHealthInsurance = String(format: "%.2f", healthInsurance).replacingOccurrences(of: ".", with: ",")
    
    // Draw the health insurance value onto the image at the specified coordinates
    let healthInsuranceText = NSAttributedString(string: formattedHealthInsurance, attributes: textAttributes)
    let healthInsuranceSize = healthInsuranceText.size()
    let healthInsuranceRect = NSRect(origin: healthInsuranceCoordinates, size: healthInsuranceSize)
    healthInsuranceText.draw(with: healthInsuranceRect)
    
    // Format taxBase to display with comma as the decimal separator
    let formattedTaxBase = String(format: "%.2f", taxBase).replacingOccurrences(of: ".", with: ",")
    
    // Draw the taxBase onto the image at the specified coordinates
    let taxBaseText = NSAttributedString(string: formattedTaxBase, attributes: textAttributes)
    let taxBaseSize = taxBaseText.size()
    let taxBaseRect = NSRect(origin: taxBaseCoordinates, size: taxBaseSize)
    taxBaseText.draw(with: taxBaseRect)
    
    // Format taxAmount to display with comma as the decimal separator
    let formattedTaxAmount = String(format: "%.2f", taxAmount).replacingOccurrences(of: ".", with: ",")
    
    // Draw the tax amount onto the image at the specified coordinates
    let taxAmountText = NSAttributedString(string: formattedTaxAmount, attributes: textAttributes)
    let taxAmountSize = taxAmountText.size()
    let taxAmountRect = NSRect(origin: taxAmountCoordinates, size: taxAmountSize)
    taxAmountText.draw(with: taxAmountRect)
    
    // Format formattedTaxCreditPaidAbroad to display with comma as the decimal separator
    let formattedTaxCreditPaidAbroad = String(format: "%.2f", Double(taxCreditPaidAbroad)).replacingOccurrences(of: ".", with: ",")
    
    // Draw the tax credit paid abroad onto the image at the specified coordinates
    let taxCreditPaidAbroadText = NSAttributedString(string: formattedTaxCreditPaidAbroad, attributes: textAttributes)
    let taxCreditPaidAbroadSize = taxCreditPaidAbroadText.size()
    let taxCreditPaidAbroadRect = NSRect(origin: taxCreditPaidAbroadCoordinates, size: taxCreditPaidAbroadSize)
    taxCreditPaidAbroadText.draw(with: taxCreditPaidAbroadRect)
    
    // Format taxDifferenceForPayment to display with comma as the decimal separator
    let formattedTaxDifferenceForPayment = String(format: "%.2f", taxDifferenceForPayment).replacingOccurrences(of: ".", with: ",")
    
    // Draw the tax difference for payment onto the image at the specified coordinates
    let taxDifferenceForPaymentText = NSAttributedString(string: formattedTaxDifferenceForPayment, attributes: textAttributes)
    let taxDifferenceForPaymentSize = taxDifferenceForPaymentText.size()
    let taxDifferenceForPaymentRect = NSRect(origin: taxDifferenceForPaymentCoordinates, size: taxDifferenceForPaymentSize)
    taxDifferenceForPaymentText.draw(with: taxDifferenceForPaymentRect)
    
    mutableImage.unlockFocus()
    
    // Save the final image in JPEG format with a unique filename for each payer
    let outputFileName = "Resources/output\(index + 2).jpg" // Output filename with unique identifier
    let outputURL = URL(fileURLWithPath: outputFileName)
    
    if let cgImage = mutableImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: .jpeg, properties: [:])
        
        do {
            try jpegData?.write(to: outputURL)
            print("Image for payer \(index + 2) saved to \(outputFileName)")
        } catch {
            print("Error saving image for payer \(index + 2): \(error)")
        }
    } else {
        print("Error getting CGImage representation of the image for payer \(index + 2).")
    }
    
    
