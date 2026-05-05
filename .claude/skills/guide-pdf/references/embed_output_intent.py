#!/usr/bin/env python3
"""Embeds an ICC output intent into a PDF (required for WIRmachenDRUCK print upload)."""
import sys
import pikepdf

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
        pdf.save(out_path)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} input.pdf profile.icc output.pdf", file=sys.stderr)
        sys.exit(1)
    embed_output_intent(sys.argv[1], sys.argv[2], sys.argv[3])
    print(f"Output intent embedded → {sys.argv[3]}")
