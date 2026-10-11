"""Validate the x64 payload and create a complete release ZIP + SHA256SUMS."""
from pathlib import Path
import hashlib, json, struct, zipfile, argparse, os

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--version', default='1.0.0')
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
excluded = {'.git', 'dist', '__pycache__', 'validation-profile'}
files = sorted(p for p in root.rglob('*') if p.is_file() and not any(part in excluded for part in p.relative_to(root).parts) and p.name != 'FILE-HASHES.json')
for item in json.loads((root/'components-manifest.json').read_text(encoding='utf-8')):
    data=(root/item['path']).read_bytes()
    assert hashlib.sha256(data).hexdigest() == item['sha256'], item['path']
    pe=struct.unpack_from('<I',data,60)[0]
    assert data[pe:pe+4] == b'PE\0\0' and struct.unpack_from('<H',data,pe+4)[0] == 0x8664, item['path']
assert len(list((root/'milkdrop2/presets').rglob('*.milk'))) == 552
for p in files:
    data=p.read_bytes()
    # Publication must not include local profile paths or authentication material.
    username = os.environ.get('USERNAME', '')
    if username:
        for prefix in ('C:/Users/', 'C:\\Users\\'):
            personal = prefix + username + ('/' if '/' in prefix else '\\')
            assert personal.encode().lower() not in data.lower(), p
            assert personal.encode('utf-16-le').lower() not in data.lower(), p
hashes=[{'path':p.relative_to(root).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files]
(root/'FILE-HASHES.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
files.append(root/'FILE-HASHES.json')
dist=root/'dist'; dist.mkdir(exist_ok=True)
archive=dist/f'Eole-foobar-theme-x64-{args.version}-full.zip'
with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as out:
    for p in sorted(files):
        info=zipfile.ZipInfo('Eole-foobar-theme-x64/'+p.relative_to(root).as_posix(),date_time=(2026,10,11,0,0,0))
        info.compress_type=zipfile.ZIP_DEFLATED
        out.writestr(info,p.read_bytes())
digest=hashlib.sha256(archive.read_bytes()).hexdigest()
(dist/'SHA256SUMS.txt').write_text(f'{digest}  {archive.name}\n',encoding='utf-8')
with zipfile.ZipFile(archive) as check: assert check.testzip() is None
print('Validated',len(files),'files;',archive.stat().st_size,'bytes;',digest)
