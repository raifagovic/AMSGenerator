import Foundation
import Cocoa


//import Foundation

// Function to read user information from configuration file
func readUserInfo() -> (name: String, address: String, identificationNumber: String) {
    let fileManager = FileManager.default
    let configURL = URL(fileURLWithPath: "config.json")
    
    // Check if configuration file exists
    guard fileManager.fileExists(atPath: configURL.path) else {
        return ("", "", "")
    }
    
    do {
        let data = try Data(contentsOf: configURL)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        if let user = json?["user"] as? [String: Any],
           let name = user["name"] as? String,
           let address = user["address"] as? String,
           let identificationNumber = user["identificationNumber"] as? String {
            return (name, address, identificationNumber)
        }
    } catch {
        print("Error reading configuration file:", error)
    }
    
    return ("", "", "")
}

// Function to write user information to configuration file
func writeUserInfo(name: String, address: String, identificationNumber: String) {
    let fileManager = FileManager.default
    let configURL = URL(fileURLWithPath: "config.json")
    
    // Create user dictionary
    let user: [String: Any] = [
        "name": name,
        "address": address,
        "identificationNumber": identificationNumber
    ]
    
    // Create configuration dictionary
    let config: [String: Any] = [
        "user": user
    ]
    
    // Serialize configuration dictionary to JSON data
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: config, options: .prettyPrinted)
        // Write JSON data to configuration file
        try jsonData.write(to: configURL)
        print("User information saved to configuration file.")
    } catch {
        print("Error writing configuration file:", error)
    }
}

// Read user information from configuration file
var (savedName, savedAddress, savedIdentificationNumber) = readUserInfo()

// Parse command-line arguments
let commandLineArgs = CommandLine.arguments

for (index, argument) in commandLineArgs.enumerated() {
    switch argument {
    case "-n":
        // Flag for name
        if index + 1 < commandLineArgs.count {
            savedName = commandLineArgs[index + 1]
        }
    case "-a":
        // Flag for address
        if index + 1 < commandLineArgs.count {
            savedAddress = commandLineArgs[index + 1]
        }
    case "-i":
        // Flag for identification number
        if index + 1 < commandLineArgs.count {
            savedIdentificationNumber = commandLineArgs[index + 1]
        }
    default:
        break
    }
}

// Check if user information is incomplete and prompt for input if needed
if savedName.isEmpty || savedAddress.isEmpty || savedIdentificationNumber.isEmpty {
    print("Please enter your information:")
    
    // Prompt for name if not saved
    if savedName.isEmpty {
        print("Name:")
        if let input = readLine() {
            savedName = input
        }
    }
    
    // Prompt for address if not saved
    if savedAddress.isEmpty {
        print("Address:")
        if let input = readLine() {
            savedAddress = input
        }
    }
    
    // Prompt for identification number if not saved
    if savedIdentificationNumber.isEmpty {
        print("Identification Number:")
        if let input = readLine() {
            savedIdentificationNumber = input
        }
    }
    
    // Write user information to configuration file
    writeUserInfo(name: savedName, address: savedAddress, identificationNumber: savedIdentificationNumber)
} else {
    // If user information is complete, write it to configuration file
    writeUserInfo(name: savedName, address: savedAddress, identificationNumber: savedIdentificationNumber)
}


// Set the path to the PNG image in the Resources folder
let imagePath = "Resources/ams_form.png"

// Load PNG image using NSImage
guard let image = NSImage(contentsOfFile: imagePath) else {
    // Handle error loading image
    exit(1)
}

// Create a mutable copy of the image
let mutableImage = image.copy() as! NSImage

let currentPage: Int = 1
let totalPages: Int = 1

// Function to draw formatted date on the image
func drawFormattedDate(_ dateInput: String, at coordinates: NSPoint, with attributes: [NSAttributedString.Key: Any]) {
    var currentX = coordinates.x

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy."

    if let date = dateFormatter.date(from: dateInput) {
        dateFormatter.dateFormat = "ddMMyy"
        let formattedDate = dateFormatter.string(from: date)

        for (index, digit) in formattedDate.enumerated() {
            let spacing: CGFloat = (index == 2 || index == 4) ? 49 : 24.5

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

func drawFormattedMonthYear(_ monthYearFlag: String, at coordinates: NSPoint, with attributes: [NSAttributedString.Key: Any]) {
    var currentX = coordinates.x
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.yyyy."
    
    if let date = dateFormatter.date(from: monthYearFlag) {
        dateFormatter.dateFormat = "MMyy"
        let formattedMonthYear = dateFormatter.string(from: date)
        
        for (index, digit) in formattedMonthYear.enumerated() {
            let spacing: CGFloat = (index == 2) ? 84 : 25.5
            
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

// Command-line arguments
let arguments = CommandLine.arguments

// Flags and their default values
var name: String = ""
var address: String = ""
var identificationNumber: String = ""
var dateInput: String = ""
var monthYearFlag: String = ""
var payerName: String = ""
var payerAddress: String = ""
var payerCountry: String = ""
var paymentAmount: Double = 0.0
var deduction: Int = 0

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
            payerName = arguments[index + 1]
        }
    case "-pa":
        // Flag for payer address
        if index + 1 < arguments.count {
            payerAddress = arguments[index + 1]
        }
    case "-pc":
        // Flag for payer country
        if index + 1 < arguments.count {
            payerCountry = arguments[index + 1]
        }
    case "-amount":
        // Flag for payment amount
        if index + 1 < arguments.count, let amountValue = Double(arguments[index + 1]) {
            paymentAmount = amountValue - Double(deduction)
        } else {
            print("Invalid amount format.")
            exit(1)
        }
    case "-deduction":
        // Flag for deduction
        if index + 1 < arguments.count, let deductionValue = Int(arguments[index + 1]) {
            deduction = deductionValue
        } else {
            print("Invalid deduction format.")
            exit(1)
        }
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

let calculatedDeduction = Double(deduction) / 100 * paymentAmount
let totalCalculatedDeduction = calculatedDeduction

let amountOfIncome = paymentAmount - calculatedDeduction
let totalAmountOfIncome = amountOfIncome

let healthInsurance = amountOfIncome * 0.04
let totalHealthInsurance = healthInsurance

let taxBase = amountOfIncome - healthInsurance
let totalTaxBase = taxBase

let taxAmount = taxBase * 0.1
let totalTaxAmount = taxAmount

let taxCreditPaidAbroad: Double = 0.0
let totalTaxCreditPaidAbroad = taxCreditPaidAbroad

let taxDifferenceForPayment = taxAmount - Double(taxCreditPaidAbroad)
let totalTaxDifferenceForPayment = taxDifferenceForPayment

let deductionCoordinates = NSPoint(x: 0, y: 0)
let spacingBetweenDigits: CGFloat = 25.5

mutableImage.lockFocus()

// Use NSFont and NSColor for text attributes
let textAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 27), // Adjusted font size to 27
    .foregroundColor: NSColor.black
]

// Draw the current page
let currentPageText = NSAttributedString(string: "\(currentPage)", attributes: [.font: NSFont.systemFont(ofSize: 27), .foregroundColor: NSColor.black])
let currentPageSize = currentPageText.size()
let currentPageRect = NSRect(origin: NSPoint(x: 1685, y: 1485), size: currentPageSize)
currentPageText.draw(with: currentPageRect)

// Draw the total number of pages
let totalPagesText = NSAttributedString(string: "\(totalPages)", attributes: [.font: NSFont.systemFont(ofSize: 27), .foregroundColor: NSColor.black])
let totalPagesSize = totalPagesText.size()
let totalPagesRect = NSRect(origin: NSPoint(x: 1685, y: 1416), size: totalPagesSize)
totalPagesText.draw(with: totalPagesRect)

// Draw the name
let nameText = NSAttributedString(string: name, attributes: textAttributes)
let nameSize = nameText.size()
let nameRect = NSRect(origin: NSPoint(x: 120, y: 1170), size: nameSize)
nameText.draw(with: nameRect)

// Draw the address using savedAddress
let addressText = NSAttributedString(string: savedAddress, attributes: textAttributes)
let addressSize = addressText.size()
let addressRect = NSRect(origin: NSPoint(x: 120, y: 1090), size: addressSize)
addressText.draw(with: addressRect)

// Draw the identification number using savedIdentificationNumber
let identificationNumberCoordinates = NSPoint(x: 1010, y: 1180)
var currentX = identificationNumberCoordinates.x

for digit in savedIdentificationNumber {
    let digitText = NSAttributedString(string: String(digit), attributes: textAttributes)
    let digitSize = digitText.size()
    let digitRect = NSRect(origin: NSPoint(x: currentX, y: identificationNumberCoordinates.y), size: digitSize)
    digitText.draw(with: digitRect)

    // Move to the next position with spacingBetweenDigits
    currentX += digitSize.width + spacingBetweenDigits
}

// Draw the formatted date
let dateCoordinates = NSPoint(x: 1100, y: 1090)
drawFormattedDate(dateInput, at: dateCoordinates, with: textAttributes)

// Draw the formatted month and year
let monthYearCoordinates = NSPoint(x: 1805, y: 1165)
drawFormattedMonthYear(monthYearFlag, at: monthYearCoordinates, with: textAttributes)

// Draw the payer name
let payerNameText = NSAttributedString(string: payerName, attributes: textAttributes)
let payerNameSize = payerNameText.size()
let payerNameRect = NSRect(origin: NSPoint(x: 120, y: 925), size: payerNameSize)
payerNameText.draw(with: payerNameRect)

// Draw the payer address
let payerAddressText = NSAttributedString(string: payerAddress, attributes: textAttributes)
let payerAddressSize = payerAddressText.size()
let payerAddressRect = NSRect(origin: NSPoint(x: 945, y: 925), size: payerAddressSize)
payerAddressText.draw(with: payerAddressRect)

// Draw the payer country
let payerCountryText = NSAttributedString(string: payerCountry, attributes: textAttributes)
let payerCountrySize = payerCountryText.size()
let payerCountryRect = NSRect(origin: NSPoint(x: 1780, y: 925), size: payerCountrySize)
payerCountryText.draw(with: payerCountryRect)

// Draw the payment amount onto the image at the specified coordinates
let formattedAmountOfIncome = String(format: "%.2f", amountOfIncome).replacingOccurrences(of: ".", with: ",")
let amountOfIncomeText = NSAttributedString(string: formattedAmountOfIncome, attributes: textAttributes)
let amountOfIncomeSize = amountOfIncomeText.size()
let amountOfIncomeRect = NSRect(origin: NSPoint(x: 285, y: 690), size: amountOfIncomeSize)
amountOfIncomeText.draw(with: amountOfIncomeRect)

// Draw the health insurance
let formattedHealthInsurance = String(format: "%.2f", healthInsurance).replacingOccurrences(of: ".", with: ",")
let healthInsuranceText = NSAttributedString(string: formattedHealthInsurance, attributes: textAttributes)
let healthInsuranceSize = healthInsuranceText.size()
let healthInsuranceRect = NSRect(origin: NSPoint(x: 700, y: 690), size: healthInsuranceSize)
healthInsuranceText.draw(with: healthInsuranceRect)

// Draw the tax base
let formattedTaxBase = String(format: "%.2f", taxBase).replacingOccurrences(of: ".", with: ",")
let taxBaseText = NSAttributedString(string: formattedTaxBase, attributes: textAttributes)
let taxBaseSize = taxBaseText.size()
let taxBaseRect = NSRect(origin: NSPoint(x: 1020, y: 690), size: taxBaseSize)
taxBaseText.draw(with: taxBaseRect)

// Draw the tax amount
let formattedTaxAmount = String(format: "%.2f", taxAmount).replacingOccurrences(of: ".", with: ",")
let taxAmountText = NSAttributedString(string: formattedTaxAmount, attributes: textAttributes)
let taxAmountSize = taxAmountText.size()
let taxAmountRect = NSRect(origin: NSPoint(x: 1360, y: 690), size: taxAmountSize)
taxAmountText.draw(with: taxAmountRect)

// Draw the tax credit paid abroad
let formattedTaxCreditPaidAbroad = String(format: "%.2f", Double(taxCreditPaidAbroad)).replacingOccurrences(of: ".", with: ",")
let taxCreditPaidAbroadText = NSAttributedString(string: formattedTaxCreditPaidAbroad, attributes: textAttributes)
let taxCreditPaidAbroadSize = taxCreditPaidAbroadText.size()
let taxCreditPaidAbroadRect = NSRect(origin: NSPoint(x: 1710, y: 690), size: taxCreditPaidAbroadSize)
taxCreditPaidAbroadText.draw(with: taxCreditPaidAbroadRect)

// Draw the tax difference for payment
let formattedTaxDifferenceForPayment = String(format: "%.2f", taxDifferenceForPayment).replacingOccurrences(of: ".", with: ",")
let taxDifferenceForPaymentText = NSAttributedString(string: formattedTaxDifferenceForPayment, attributes: textAttributes)
let taxDifferenceForPaymentSize = taxDifferenceForPaymentText.size()
let taxDifferenceForPaymentRect = NSRect(origin: NSPoint(x: 2025, y: 690), size: taxDifferenceForPaymentSize)
taxDifferenceForPaymentText.draw(with: taxDifferenceForPaymentRect)

// Draw the total health insurance
let formattedTotalHealthInsurance = String(format: "%.2f", totalHealthInsurance).replacingOccurrences(of: ".", with: ",")
let totalHealthInsuranceText = NSAttributedString(string: formattedTotalHealthInsurance, attributes: textAttributes)
let totalHealthInsuranceSize = totalHealthInsuranceText.size()
let totalHealthInsuranceRect = NSRect(origin: NSPoint(x: 700, y: 344), size: totalHealthInsuranceSize)
totalHealthInsuranceText.draw(with: totalHealthInsuranceRect)

// Draw the total tax base
let formattedTotalTaxBase = String(format: "%.2f", totalTaxBase).replacingOccurrences(of: ".", with: ",")
let totalTaxBaseText = NSAttributedString(string: formattedTotalTaxBase, attributes: textAttributes)
let totalTaxBaseSize = totalTaxBaseText.size()
let totalTaxBaseRect = NSRect(origin: NSPoint(x: 1020, y: 344), size: totalTaxBaseSize)
totalTaxBaseText.draw(with: totalTaxBaseRect)

// Draw the total tax amount
let formattedTotalTaxAmount = String(format: "%.2f", totalTaxAmount).replacingOccurrences(of: ".", with: ",")
let totalTaxAmountText = NSAttributedString(string: formattedTotalTaxAmount, attributes: textAttributes)
let totalTaxAmountSize = totalTaxAmountText.size()
let totalTaxAmountRect = NSRect(origin: NSPoint(x: 1360, y: 344), size: totalTaxAmountSize)
totalTaxAmountText.draw(with: totalTaxAmountRect)

// Draw the total tax credit paid abroad
let formattedTotalTaxCreditPaidAbroad = String(format: "%.2f", Double(totalTaxCreditPaidAbroad)).replacingOccurrences(of: ".", with: ",")
let totalTaxCreditPaidAbroadText = NSAttributedString(string: formattedTotalTaxCreditPaidAbroad, attributes: textAttributes)
let totalTaxCreditPaidAbroadSize = totalTaxCreditPaidAbroadText.size()
let totalTaxCreditPaidAbroadRect = NSRect(origin: NSPoint(x: 1710, y: 344), size: totalTaxCreditPaidAbroadSize)
totalTaxCreditPaidAbroadText.draw(with: totalTaxCreditPaidAbroadRect)

// Draw the total tax difference for payment
let formattedTotalTaxDifferenceForPayment = String(format: "%.2f", totalTaxDifferenceForPayment).replacingOccurrences(of: ".", with: ",")
let totalTaxDifferenceForPaymentText = NSAttributedString(string: formattedTotalTaxDifferenceForPayment, attributes: textAttributes)
let totalTaxDifferenceForPaymentSize = totalTaxDifferenceForPaymentText.size()
let totalTaxDifferenceForPaymentRect = NSRect(origin: NSPoint(x: 2025, y: 344), size: totalTaxDifferenceForPaymentSize)
totalTaxDifferenceForPaymentText.draw(with: totalTaxDifferenceForPaymentRect)

mutableImage.unlockFocus()

// Save the final image
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
