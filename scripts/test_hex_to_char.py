import io
import sys
import pytest

from scripts import hex_to_char

def test_hex_to_char_basic(monkeypatch, capsys):
    # Simulate input as would be piped to the script
    input_data = """
0000: c8 00 00 00 01 00 40 00 bf 3b 94 42 cb 70 ae 3a
0010: f8 74 23 00 5f 23 7c 4d 7a 00 00 00 03 03 40 00
"""
    monkeypatch.setattr(sys, "stdin", io.StringIO(input_data))
    hex_to_char.main()
    out = capsys.readouterr().out
    assert out.startswith("const unsigned char packet[")
    assert "0xc8, 0x00, 0x00, 0x00, 0x01, 0x00, 0x40, 0x00, 0xbf, 0x3b, 0x94, 0x42, 0xcb, 0x70, 0xae, 0x3a," in out
    assert out.strip().endswith("};")

if __name__ == "__main__":
    pytest.main([__file__])

