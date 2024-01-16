import os
import fitz
import sys
import re

def get_field_names(pdf_path):
    script_directory = os.path.dirname(os.path.abspath(__file__))
    pdf_full_path = os.path.join(script_directory, pdf_path)

    pdf_document = fitz.open(pdf_full_path)
    field_names = set()

    for page_number in range(pdf_document.page_count):
        page = pdf_document[page_number]

        # Extract and print the raw text from the page
        page_text = page.get_text("text")
        print("Page {} raw text:\n{}".format(page_number + 1, page_text))

        # Use regex to find potential form field names
        potential_field_names = [match.group(1) for match in re.finditer(r'/T\s*\((.*?)\)', page_text)]

        for field_name in potential_field_names:
            field_names.add(field_name)

    pdf_document.close()
    return list(field_names)

if __name__ == "__main__":
    # Check if a command-line argument (PDF file path) is provided
    if len(sys.argv) != 2:
        print("Usage: python your_script.py <pdf_path>")
        sys.exit(1)

    # Get the PDF file path from the command-line argument
    pdf_path = sys.argv[1]

    # Example usage
    names = get_field_names(pdf_path)
    print("Extracted field names:", names)








