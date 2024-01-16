import os
import fitz

def get_field_names(pdf_path):
    script_directory = os.path.dirname(os.path.abspath(__file__))
    pdf_full_path = os.path.join(script_directory, pdf_path)

    pdf_document = fitz.open(pdf_full_path)
    field_names = []

    for page_number in range(pdf_document.page_count):
        page = pdf_document[page_number]
        for annot_index in range(page.AnnotCount):
            annotation = page.getAnnot(annot_index)
            if annotation.fieldName:
                field_names.append(annotation.fieldName)

    pdf_document.close()
    return field_names

if __name__ == "__main__":
    # Check if a command-line argument (PDF file path) is provided
    if len(sys.argv) != 2:
        print("Usage: python your_script.py <pdf_path>")
        sys.exit(1)

    # Get the PDF file path from the command-line argument
    pdf_path = sys.argv[1]

    # Example usage
    names = get_field_names(pdf_path)
    print(names)


