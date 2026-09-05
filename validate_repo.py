from pathlib import Path
import re

root = Path(__file__).parent
script = (root / "EL2B_ALL_GEAR.lua").read_text(encoding="utf-8")
readme = (root / "README.md").read_text(encoding="utf-8")
version = (root / "EL2B_VERSION.txt").read_text(encoding="utf-8").strip()

assert version == "2.3.0", version
assert 'CURRENT_VERSION = "2.3.0"' in script
assert 'local loadingDuration = 30' in script
assert 'local skipUnlockAt = 20' in script
assert 'elapsed >= skipUnlockAt' in script
assert 'loadingProgress:Cancel()' in script
assert 'loadingSpin:Cancel()' in script
assert 'local clipboardFunctions = {setclipboard, toclipboard, set_clipboard}' in script
assert "30 secondes" in readme and "20 premières secondes" in readme

# Basic delimiter balance after removing comments and quoted strings.
code = re.sub(r'--[^\n]*', '', script)
code = re.sub(r'("(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\')', '', code)
for opening, closing in [("(", ")"), ("{", "}"), ("[", "]")]:
    assert code.count(opening) == code.count(closing), (opening, code.count(opening), closing, code.count(closing))

print("Static validation passed: EL2B_ALL_GEAR.lua v2.3.0")
