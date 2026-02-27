"""Update run-timestamps.json manifest with the current run's creation time.

Environment variables consumed:
  GH_PAGES        – path to the GitHub Pages output directory
  GITHUB_RUN_NUM  – current workflow run number
  _RUN_TS         – ISO-8601 creation timestamp for the current run
"""
import json, os, pathlib

manifest = pathlib.Path(os.environ['GH_PAGES']) / 'run-timestamps.json'
data = json.loads(manifest.read_text()) if manifest.exists() else {}

for d in sorted(manifest.parent.iterdir()):
    if d.is_dir() and d.name.isdigit() and d.name not in data:
        ca = d / '.created_at'
        if ca.exists():
            try:
                data[d.name] = ca.read_text(encoding='utf-8').strip()
            except Exception:
                pass

if os.environ['GITHUB_RUN_NUM'] not in data:
    data[os.environ['GITHUB_RUN_NUM']] = os.environ['_RUN_TS']

keys = sorted(data.keys(), key=lambda k: (0, int(k)) if k.isdigit() else (1, k))
manifest.write_text(json.dumps({k: data[k] for k in keys}, indent=2) + '\n')
