#!/usr/bin/env python3
"""Embeds an ICC output intent + PDF/X-4 XMP metadata into a PDF (required for WIRmachenDRUCK print upload)."""
import sys
import pikepdf

PDFX4_XMP = """<?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/">
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about=""
        xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
        xmlns:pdfx="http://ns.adobe.com/pdfx/1.3/"
        xmlns:pdfxid="http://www.npes.org/pdfx/ns/id/"
        xmlns:xmp="http://ns.adobe.com/xap/1.0/">
      <pdf:Trapped>False</pdf:Trapped>
      <pdfx:GTS_PDFXVersion>PDF/X-4</pdfx:GTS_PDFXVersion>
      <pdfxid:GTS_PDFXVersion>PDF/X-4</pdfxid:GTS_PDFXVersion>
    </rdf:Description>
  </rdf:RDF>
</x:xmpmeta>
<?xpacket end="w"?>"""

def embed_output_intent(pdf_path: str, icc_path: str, out_path: str) -> None:
    with open(icc_path, "rb") as f:
        icc_data = f.read()

    with pikepdf.open(pdf_path) as pdf:
        icc_stream = pdf.make_stream(icc_data)
        icc_stream["/N"] = 4  # CMYK
        icc_stream["/Alternate"] = pikepdf.Name("/DeviceCMYK")

        output_intent = pikepdf.Dictionary(
            Type=pikepdf.Name("/OutputIntent"),
            S=pikepdf.Name("/GTS_PDFX"),
            OutputConditionIdentifier=pikepdf.String("ISO Coated v2 300% (ECI)"),
            Info=pikepdf.String("ISO Coated v2 300% (ECI)"),
            DestOutputProfile=pdf.make_indirect(icc_stream),
        )

        pdf.Root["/OutputIntents"] = pikepdf.Array([pdf.make_indirect(output_intent)])

        # PDF/X-4 requires Trapped key in Info dict
        pdf.docinfo["/Trapped"] = pikepdf.Name("/False")

        # PDF/X-4 conformance is declared in XMP metadata (what Acrobat reads)
        metadata_stream = pdf.make_stream(PDFX4_XMP.encode("utf-8"))
        metadata_stream["/Type"] = pikepdf.Name("/Metadata")
        metadata_stream["/Subtype"] = pikepdf.Name("/XML")
        pdf.Root["/Metadata"] = pdf.make_indirect(metadata_stream)

        pdf.save(out_path)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} input.pdf profile.icc output.pdf", file=sys.stderr)
        sys.exit(1)
    embed_output_intent(sys.argv[1], sys.argv[2], sys.argv[3])
    print(f"Output intent embedded → {sys.argv[3]}")
