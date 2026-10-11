# Generate the x64 FCL from upstream dataset records and native panel configs.
from pathlib import Path
import json, struct, uuid
root=Path(__file__).resolve().parents[1]/'themes/eole'
inputs=Path(__file__).resolve().parent/'layout-inputs'
def u32(v):return struct.pack('<I',v)
def u64(v):return struct.pack('<Q',v)
def guid(v):return uuid.UUID(v).bytes_le
def string(v):
 b=v.encode('utf8');return u32(len(b))+b
JS='b42c29e2-486b-46cf-aa2c-f66fb1201bad'
def config(j,children=[]):
 b=json.dumps(j,ensure_ascii=False,indent=2).encode('utf8')
 return u32(2)+u32(len(b))+b+u32(3)+u64(len(children))+b''.join(children)
def child(name,cfg,index,panelguid=JS):
 # JSplitter v3 native panel records, verified against a saved x64 layout.
 return guid(panelguid)+bytes([1,1,0])+struct.pack('<4iI',0,0,800,500,index)+bytes(8)+u64(len(cfg))+cfg+bytes([1])+string(name)+string('JSplitter' if panelguid==JS else name)+bytes([0])
children=[]
for i,(p,j) in enumerate(json.loads((inputs/'eole-jsons.json').read_text())):
 name=j['panelId']
 if i==14:name='TrackInfo'
 j['panelId']=str(uuid.uuid5(uuid.NAMESPACE_URL,'eole-x64/'+name))
 j['payload']['isModuleScript']=False
 children.append(child(name,config(j),len(children)))
# Native MilkDrop configuration captured from Columns UI.
children.append(child('MilkDrop',(inputs/'milkdrop-cui-config.bin').read_bytes(),len(children),'204b0345-4df5-4b47-add3-989f811bd9a5'))
children.append(child('Lyrics',(inputs/'lyrics-cui-config.bin').read_bytes(),len(children),'547abb10-d8ac-4c39-9f8b-9c7af989443d'))
j={'edgeStyle':0,'id':'settings','isPseudoTransparent':False,'panelId':str(uuid.uuid5(uuid.NAMESPACE_URL,'eole-x64/root')),'payload':{'isModuleScript':False,'script':"include(fb.ProfilePath + 'themes\\\\eole\\\\js\\\\Eole_x64_layout.js');"},'properties':{'id':'properties','values':{},'version':'1'},'scriptType':1,'version':'1'}
cfg=config(j,children)
layout=u32(0)+u32(0)+u32(1)+guid(JS)+string('Eole x64')+u32(len(cfg))+cfg
data=[]
for g,n,deps,b in json.loads((inputs/'fcl-datasets.json').read_text()):
 if n=='Layout':b=layout
 else:b=bytes.fromhex(b)
 data.append(guid(g)+string(n)+u32(0)+u32(len(b))+b)
fcl=guid('9faadff3-e51a-4a8b-b4a3-d209a36ab301')+u32(2)+u32(1)+u32(1)+guid(JS)+string('JSplitter')+u32(len(data))+b''.join(data)
(root/'columnsUI_eole_x64.fcl').write_bytes(fcl)
(root/'columnsUI_eole.fcl').write_bytes(fcl)

print('Generated',len(children),'panels;',len(fcl),'FCL bytes')
