import csv
import xml.etree.ElementTree as ET

input_file = "heurist_persons.tsv"
output_file = "FontenayIndex.xml"

tei_ns = "http://www.tei-c.org/ns/1.0"
ET.register_namespace("tei", tei_ns)

tei = ET.Element(f"{{{tei_ns}}}TEI")
text = ET.SubElement(tei, f"{{{tei_ns}}}text")
body = ET.SubElement(text, f"{{{tei_ns}}}body")
list_person = ET.SubElement(body, f"{{{tei_ns}}}listPerson")

with open(input_file, newline='', encoding='utf-8-sig') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='\t')
    for row in reader:
        person_id = row["Person H-ID"].strip()
        main_name = row["Person Record Title"].strip()
        alt_names = row["Alternate name(s) / title(s)"].strip()
        desc = row["Short description"].strip()
        note = row["Note"].strip()

        person_elem = ET.SubElement(list_person, f"{{{tei_ns}}}person", {"xml:id": person_id})

        pers_name_elem = ET.SubElement(person_elem, f"{{{tei_ns}}}persName")
        pers_name_elem.text = main_name

        if alt_names:
            for alt_name in alt_names.split('|'):
                alt_name = alt_name.strip()
                if alt_name:
                    pers_name_elem = ET.SubElement(person_elem, f"{{{tei_ns}}}persName")
                    pers_name_elem.text = alt_name
        if desc:
            note_elem = ET.SubElement(person_elem, f"{{{tei_ns}}}note")
            note_elem.text = desc
        if note:
            note_elem = ET.SubElement(person_elem, f"{{{tei_ns}}}note")
            note_elem.text = note


tree = ET.ElementTree(tei)
ET.indent(tree, space="  ")
tree.write(output_file, encoding="utf-8", xml_declaration=True)

print(f"✅ XML file created: {output_file}")
