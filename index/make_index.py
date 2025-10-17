import csv
import xml.etree.ElementTree as ET

# Input and output file paths
input_file = "heurist_persons.tsv"
output_file = "FontenayIndex.xml"

# Namespace
tei_ns = "http://www.tei-c.org/ns/1.0"
ET.register_namespace("tei", tei_ns)

# Root element
tei = ET.Element(f"{{{tei_ns}}}TEI")
text = ET.SubElement(tei, f"{{{tei_ns}}}text")
body = ET.SubElement(text, f"{{{tei_ns}}}body")
list_person = ET.SubElement(body, f"{{{tei_ns}}}listPerson")

# Read the tab-separated CSV
with open(input_file, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='\t')
    for row in reader:
        person_id = row["Person H-ID"].strip()
        person_name = row["Person Record Title"].strip()

        # Create <tei:person xml:id="...">
        person_elem = ET.SubElement(list_person, f"{{{tei_ns}}}person", {"xml:id": 'stutzmann_himanis#' + person_id})

        # Create <tei:persName>...</tei:persName>
        pers_name_elem = ET.SubElement(person_elem, f"{{{tei_ns}}}persName")
        pers_name_elem.text = person_name

# Write to XML file (with declaration and pretty print)
tree = ET.ElementTree(tei)
ET.indent(tree, space="  ")
tree.write(output_file, encoding="utf-8", xml_declaration=True)

print(f"✅ XML file created: {output_file}")
