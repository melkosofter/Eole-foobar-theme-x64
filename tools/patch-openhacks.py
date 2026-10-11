"""Reproduce the Eole Columns UI patch on the exact upstream 0.1.5 x64 DLL."""
import argparse, hashlib
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('input', type=Path, help='Unmodified OpenHacks 0.1.5 x64 DLL')
parser.add_argument('output', type=Path, help='Destination DLL (must differ from input)')
args = parser.parse_args()
if args.input.resolve() == args.output.resolve():
    parser.error('Use a separate output file to preserve the original DLL')
data = args.input.read_bytes()
expected = '017a3a601d886518b0fa945b016d031c5df267bc91ba417e16dea45bec79d9c4'
if hashlib.sha256(data).hexdigest() != expected:
    parser.error('Unexpected upstream DLL hash; refusing to patch a different version')
old = '{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}'.encode('utf-16-le')
new = '{E7076D1C-A7BF-4f39-B771-BCBE88F2A2A8}'.encode('utf-16-le')
assert len(old) == len(new) and data.count(old) == 1
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_bytes(data.replace(old, new))
print('Patched one window class constant; SHA-256:', hashlib.sha256(args.output.read_bytes()).hexdigest())
