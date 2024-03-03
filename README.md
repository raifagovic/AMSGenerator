<p align="center">
  <img src="ams_form_example.jpg"/>
</p>

# AMS Generator

This script generates an invoice with provided information and saves it as an image file.

## Usage

To use this script, follow the steps below:

1. Ensure you have the necessary dependencies installed. This script requires macOS and the Cocoa framework.

2. Clone or download the repository containing the script.

3. Open Terminal on your macOS system.

4. Navigate to the directory containing the script.

5. Run the script with the following command:

```bash
$ swift AMS.swift [flags]
```

Replace [flags] with the desired command-line flags and their values. The available flags are:

* '-n [name]': Specifies the name of the invoice recipient.
* '-a [address]': Specifies the address of the invoice recipient.
* '-i [identificationNumber]': Specifies the identification number of the invoice recipient.
* '-d [date]': Specifies the date of the invoice in the format "dd.MM.yyyy".
* '-m [monthYear]': Specifies the month and year of the invoice in the format "MM.yyyy".
* '-p [payerName]': Specifies the name of the payer.
* '-pa [payerAddress]': Specifies the address of the payer.
* '-pc [payerCountry]': Specifies the country of the payer.
* '-amount [amount]': Specifies the payment amount.
* '-deduction [deduction]': Specifies the deduction amount.


## Author
[Raif Agović](https://twitter.com/raifagovic)

## License
AMS Generator is licensed under the MIT license. Check the [LICENSE](https://github.com/raifagovic/ams-generator/blob/main/LICENSE) file for details.
