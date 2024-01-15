import fitz

def get_field_names(pdf_path):
    pdf_document = fitz.open(pdf_path)
    
    field_names = []
    
    for page_number in range(pdf_document.page_count):
        page = pdf_document[page_number]
        for field_index in range(page.form_field_count):
            field = page[page_number].getFormField(field_index)
            field_names.append(field.name)
    
    pdf_document.close()
    return field_names

# Example usage
pdf_path = 'ams_generator.pdf'  # Change to your actual PDF file name
names = get_field_names(pdf_path)
print(names)

