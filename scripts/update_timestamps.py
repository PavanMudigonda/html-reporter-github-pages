"""Update run-timestamps.json manifest with the current run's creation time.

Environment variables consumed:
  GH_PAGES           – path to the GitHub Pages output directory
  GITHUB_RUN_NUM     – current workflow run number
  _RUN_TS            – ISO-8601 creation timestamp for the current run
  GITHUB_REPOSITORY  – owner/repo (used for GitHub API fallback)
"""
import json, os, pathlib, subprocess

manifest = pathlib.Path(os.environ['GH_PAGES']) / 'run-timestamps.json'
data = json.loads(manifest.read_text()) if manifest.exists() else {}

# Level 1: backfill from per-folder .created_at sentinel files.
for d in sorted(manifest.parent.iterdir()):
    if d.is_dir() and d.name.isdigit() and d.name not in data:
        ca = d / '.created_at'
        if ca.exists():
            try:
                data[d.name] = ca.read_text(encoding='utf-8').strip()
            except Exception:
                pass

# Level 2: for runs still missing a timestamp, query the GitHub Actions API.
# This handles run folders created before .created_at was introduced, and
# folders whose mtime was reset by a force-orphan redeploy.
missing = {
    d.name
    for d in manifest.parent.iterdir()
    if d.is_dir() and d.name.isdigit() and d.name not in data
}
if missing:
    owner_repo = os.environ.get('GITHUB_REPOSITORY', '')
    if owner_repo:
        try:
            result = subprocess.run(
                [
                    'gh', 'api',
                    f'/repos/{owner_repo}/actions/runs',
                    '--paginate',
                    '--jq', '.workflow_runs[] | [(.run_number | tostring), .created_at] | @tsv',
                ],
                capture_output=True, text=True, timeout=60,
            )
            if result.returncode == 0:
                for line in result.stdout.strip().splitlines():
                    parts = line.split('\t')
                    if len(parts) == 2:
                        run_num, ts = parts[0].strip(), parts[1].strip()
                        if run_num in missing and ts:
                            data[run_num] = ts
                            # Also write a .created_at so future runs skip the API call.
                            ca_path = manifest.parent / run_num / '.created_at'
                            try:
                                if not ca_path.exists():
                                    ca_path.write_text(ts + '\n', encoding='utf-8')
                            except OSError:
                                pass
        except Exception:
            pass

# Level 3: record the current run (always authoritative).
if os.environ['GITHUB_RUN_NUM'] not in data:
    data[os.environ['GITHUB_RUN_NUM']] = os.environ['_RUN_TS']

keys = sorted(data.keys(), key=lambda k: (0, int(k)) if k.isdigit() else (1, k))
manifest.write_text(json.dumps({k: data[k] for k in keys}, indent=2) + '\n')
