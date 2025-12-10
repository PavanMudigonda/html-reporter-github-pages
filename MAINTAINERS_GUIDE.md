# Quick Reference Guide for Maintainers

This guide provides quick answers for common maintenance tasks and questions.

## 📁 Repository Structure

```
html-reporter-github-pages/
├── action.yml                 # Main GitHub Action definition (composite action)
├── README.md                  # User-facing documentation
├── scripts/
│   ├── index-html-generator.py              # Main script (handles both orders)
│   └── index-html-generator-descending-order.py  # Wrapper (backward compat)
├── REVIEW_FEEDBACK.md         # Comprehensive code review (390 lines)
├── IMPROVEMENTS_IMPLEMENTED.md # Change tracking (195 lines)
└── SUMMARY.md                 # Executive summary (225 lines)
```

---

## 🔧 Common Tasks

### Adding a New Input Parameter

1. **Add to action.yml inputs section:**
```yaml
inputs:
  new_parameter:
    description: 'Description here'
    required: false
    default: 'default_value'
```

2. **Add validation in the first step:**
```yaml
- name: Validate inputs
  shell: bash
  run: |
    # ... existing validations ...
    
    # Add new validation
    if [[ "${{ inputs.new_parameter }}" != "valid1" && "${{ inputs.new_parameter }}" != "valid2" ]]; then
      echo "::error::new_parameter must be 'valid1' or 'valid2'"
      exit 1
    fi
```

3. **Use in the main script step:**
```yaml
run: |
  export NEW_PARAMETER="${{ inputs.new_parameter }}"
  # Use $NEW_PARAMETER in bash
```

4. **Document in README.md inputs table**

---

### Modifying Sort Order Logic

**DO:** Modify `scripts/index-html-generator.py`
```python
# Lines 321-322
reverse_order = getattr(opts, 'reverse', False)
sorted_entries = sorted(path_top_dir.glob(glob_patt), 
                       key=lambda p: (p.is_file(), p.name), 
                       reverse=reverse_order)
```

**DON'T:** Modify `index-html-generator-descending-order.py` (it's just a wrapper)

---

### Updating Python Index Generator

The main script accepts these arguments:
```bash
python3 index-html-generator.py [top_dir] \
  --order {ascending,descending} \
  --filter "*.html" \
  --output-file "index.html" \
  --recursive \
  --include-hidden \
  --verbose
```

To add a new feature:
1. Add argument to parser (line ~486)
2. Use in `process_dir()` function via `opts.your_option`
3. Update help text
4. Test both ascending and descending modes

---

### Testing Changes Locally

```bash
# Test input validation
cd /path/to/repo
./action.yml  # Run with various invalid inputs

# Test Python script
cd scripts
python3 index-html-generator.py /tmp/test --order ascending
python3 index-html-generator.py /tmp/test --order descending

# Test backward compatibility
python3 index-html-generator-descending-order.py /tmp/test

# Validate YAML
python3 -c "import yaml; yaml.safe_load(open('action.yml'))"

# Run shellcheck (if installed)
shellcheck <(grep -A 1000 'shell: bash' action.yml | sed '/^  /!d')
```

---

## 🐛 Known Issues & Workarounds

### Issue: Large Bash Script in action.yml
**Status:** Documented in REVIEW_FEEDBACK.md  
**Lines:** 224-516 (293 lines)  
**Workaround:** None currently  
**Future Fix:** Extract to separate scripts (Phase 2)

### Issue: Duplicate GitHub Pages Site Steps
**Status:** Documented in REVIEW_FEEDBACK.md  
**Lines:** 617-835 (4 similar steps)  
**Workaround:** None currently  
**Future Fix:** Consolidate to 2 steps (Phase 2)

---

## 🔍 Debugging User Issues

### "ORDER parameter not working"
- ✅ **FIXED** in commit a9f1b8f
- Verify user is using updated version
- Check that `--order ${ORDER}` is passed to Python script

### "Invalid input" errors
- ✅ **ADDED** in commit b2f9023
- These are expected for invalid configurations
- Point user to error message for guidance

### "Permission denied" on GitHub Pages
- Not an action bug - user needs PAT token
- Check token has `repo` and `pages` scopes
- Verify repository has GitHub Pages enabled

### Reports not updating
- Check GitHub Pages build status
- Verify branch being deployed matches `gh_pages` input
- Check `keep_reports` isn't set too low

---

## 📝 Code Style Guidelines

### Bash Scripts
```bash
# DO: Quote all variable expansions
cd "${GH_PAGES}"
mkdir -p "${SUBFOLDER}"

# DON'T: Unquoted variables
cd $GH_PAGES  # ❌ Word splitting risk

# DO: Use [[ ]] for conditionals
if [[ "${VAR}" == "value" ]]; then

# DO: Check command success
if ! cp source dest; then
  echo "::error::Copy failed"
  exit 1
fi

# DON'T: Hide errors with || true
cp source dest || true  # ❌ Silently fails
```

### YAML
```yaml
# DO: Use explicit conditionals
if: ${{ inputs.param == 'value' }}

# DO: Quote complex expressions
with:
  param: ${{ inputs.value != '' && inputs.value || 'default' }}
```

### Python
```python
# DO: Follow existing style
# - Use argparse for CLI
# - Use pathlib.Path for paths
# - Handle errors gracefully

# DO: Add type hints for new functions
def process_dir(top_dir: str, opts: argparse.Namespace) -> None:
```

---

## 🚀 Release Process

1. **Test changes thoroughly**
   - Run validation tests
   - Test in real workflow
   - Verify backward compatibility

2. **Update version references**
   - Update examples in README.md
   - Update branding version if major changes

3. **Create git tag**
   ```bash
   git tag -a v1.6 -m "Version 1.6: Phase 1 improvements"
   git push origin v1.6
   ```

4. **Update GitHub Release**
   - Create release from tag
   - Copy IMPROVEMENTS_IMPLEMENTED.md as release notes
   - Highlight breaking changes (if any)

5. **Update marketplace**
   - GitHub automatically updates from latest tag
   - Verify listing shows correct version

---

## 📚 Important Files Reference

### action.yml
- **Lines 85-133:** Input validation (Phase 1)
- **Lines 140-156:** Branch management (same repo)
- **Lines 207-223:** Branch management (external repo)
- **Lines 224-516:** Main logic (needs refactoring in Phase 2)
- **Lines 325-326:** Script selection (fixed in Phase 1)
- **Lines 449:** Generate index HTML function
- **Lines 568-591:** Deployment steps (consolidated in Phase 1)

### scripts/index-html-generator.py
- **Lines 13-419:** Main processing function
- **Lines 321-322:** Sort order logic
- **Lines 486-492:** Command-line argument parsing
- **Lines 493-494:** Order parameter handling

### Documentation
- **REVIEW_FEEDBACK.md:** Read this for full context of issues
- **IMPROVEMENTS_IMPLEMENTED.md:** See what was fixed in Phase 1
- **SUMMARY.md:** Executive summary for stakeholders

---

## 🎓 Learning Resources

### GitHub Actions
- [Composite Actions](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)
- [Action Metadata](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions)
- [GitHub Pages](https://docs.github.com/en/pages)

### Testing
- [Act](https://github.com/nektos/act) - Run actions locally
- [GitHub Actions Testing](https://github.com/marketplace/actions/github-action-testing)

### Tools
- [yamllint](https://github.com/adrienverge/yamllint) - YAML linting
- [shellcheck](https://www.shellcheck.net/) - Bash linting
- [actionlint](https://github.com/rhysd/actionlint) - Actions linting

---

## 💡 Tips & Best Practices

### When Adding Features
1. ✅ Add input validation first
2. ✅ Update README.md documentation
3. ✅ Add tests (when test infrastructure exists)
4. ✅ Maintain backward compatibility
5. ✅ Update CHANGELOG.md (when created)

### When Fixing Bugs
1. ✅ Add test that reproduces bug
2. ✅ Fix with minimal changes
3. ✅ Verify fix doesn't break other features
4. ✅ Document in commit message
5. ✅ Consider if validation could prevent bug

### When Refactoring
1. ✅ Do it incrementally
2. ✅ Test after each change
3. ✅ Keep commits atomic
4. ✅ Maintain backward compatibility
5. ✅ Update documentation

---

## 🆘 Getting Help

### For Users
- Check [README.md](README.md) for usage examples
- Review issues in GitHub Issues
- Check GitHub Pages build status

### For Maintainers
- Read [REVIEW_FEEDBACK.md](REVIEW_FEEDBACK.md) for context
- Check [IMPROVEMENTS_IMPLEMENTED.md](IMPROVEMENTS_IMPLEMENTED.md) for changes
- Review Phase 2+ roadmap in REVIEW_FEEDBACK.md

### For Contributors
- Follow code style guidelines above
- Test changes thoroughly
- Update documentation
- Keep changes minimal and focused

---

*Last Updated: 2025-12-10*  
*Maintainer: GitHub Copilot*  
*Status: Phase 1 Complete*
