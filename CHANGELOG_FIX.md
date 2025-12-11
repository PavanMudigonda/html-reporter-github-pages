# Fix for GitHub Pages 403 Permission Warning

## Problem
Users were seeing confusing 403 permission warnings when using the action, even when:
- The GitHub Pages deployment was successful
- The `pages: write` permission was granted in the workflow
- The GitHub Pages site was working correctly

Example warning message:
```
Warning: API call to update GitHub Pages site failed (403 - Insufficient permissions).
Warning: This is expected when using GITHUB_TOKEN without 'pages: write' permission.
Warning: Your GitHub Pages deployment was successful, but settings were not updated via API.
```

## Root Cause
The `peaceiris/actions-gh-pages@v4.0.0` action (used internally by this action) deploys using GitHub's newer "GitHub Actions" deployment method. This is identified by `build_type: "workflow"` in the GitHub Pages API.

When GitHub Pages is configured with the GitHub Actions deployment method, attempting to update the source branch settings via the legacy API endpoint returns a 403 error because:
- GitHub Actions deployments don't use source branch configuration
- The API endpoint for updating source branch is only applicable to legacy "Deploy from a branch" setups

## Solution
The action now intelligently detects the GitHub Pages deployment method and adjusts its behavior:

1. **Check deployment method**: After deployment, query the GitHub Pages API to get the `build_type`
2. **Smart handling**:
   - If `build_type` is `"workflow"` (GitHub Actions deployment): Skip source branch update and show informative notices
   - If `build_type` is `"legacy"` or missing (branch-based deployment): Attempt to update source branch settings as before
3. **Better messages**: Clear, informative notices instead of alarming warnings when everything is working correctly

## Changes Made

### action.yml
- Added build_type detection in all four GitHub Pages configuration steps:
  - Same repository without subfolder
  - Same repository with subfolder
  - External repository without subfolder
  - External repository with subfolder
- Use `awk` to reliably parse multiline JSON from GitHub API
- Improved warning/notice messages to be clearer and less alarming

### README.md
- Updated the permissions section to reflect the improved behavior
- Clarified when `pages: write` permission is needed and when it's optional

## User Impact

### Before
Users saw confusing 403 warnings even when their deployment was successful:
```
site already present
updating gh page info
Warning: API call to update GitHub Pages site failed (403 - Insufficient permissions).
Warning: This is expected when using GITHUB_TOKEN without 'pages: write' permission.
Warning: Your GitHub Pages deployment was successful, but settings were not updated via API.
Notice: To enable automatic GitHub Pages configuration updates, add 'pages: write' permission to your workflow.
```

### After
Users see clear, informative notices when using GitHub Actions deployment:
```
GitHub Pages already configured
✅ GitHub Pages is using 'GitHub Actions' deployment method
✅ Source branch configuration is not applicable for Actions deployments
✅ Your deployment was successful via peaceiris/actions-gh-pages
✅ Your GitHub Pages URL: https://user.github.io/repo
```

## Migration Guide

**No action required!** This fix is backward compatible:
- Existing workflows continue to work without changes
- The action automatically detects the deployment method
- Both GitHub Actions and legacy branch-based deployments are supported

## Technical Details

### Deployment Method Detection
```bash
# Extract build_type from GitHub Pages API response
BUILD_TYPE=$(awk -F'"' '/"build_type"/ {print $4}' gh-pages.txt || echo "")

if [ "$BUILD_TYPE" = "workflow" ]; then
  # GitHub Actions deployment - skip source branch update
  echo "::notice::GitHub Pages is using 'GitHub Actions' deployment method"
else
  # Legacy branch-based deployment - attempt source branch update
  gh api --method PUT /repos/${repo}/pages -f "source[branch]=${branch}"
fi
```

### Why awk?
The `awk` command reliably parses multiline JSON responses from the GitHub API. Previous attempts using `grep -o` with pipes failed on multiline JSON because the pattern couldn't match across line breaks.

## Testing

All scenarios have been tested:
1. ✅ GitHub Actions deployment (workflow) - No 403 warnings
2. ✅ Legacy branch deployment - Correctly attempts source branch update
3. ✅ GitHub Pages not configured (404) - Correctly attempts to create site
4. ✅ YAML syntax validation passes
5. ✅ No security vulnerabilities introduced

## References
- GitHub Pages API: https://docs.github.com/en/rest/pages
- peaceiris/actions-gh-pages: https://github.com/peaceiris/actions-gh-pages
- GitHub Actions deployment method: https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow
