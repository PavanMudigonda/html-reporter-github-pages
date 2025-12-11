# Fix for "gh: Not Found (HTTP 404)" Error

## Issue
Users reported workflow failures with the error:
```
gh: Not Found (HTTP 404)
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/rest",
  "status": "404"
}
Error: Process completed with exit code 1.
```

This occurred when deploying to external repositories that didn't have GitHub Pages configured.

## Root Cause
Three `gh api` calls in action.yml were missing proper error handling:

1. **Line 231**: Detecting current branch from commit
2. **Line 241**: Getting default branch of repository
3. **Line 385**: Retrieving GitHub Pages URL

When these API calls failed (due to 404, 403, 401, or other errors), they would:
- Output error messages to stderr
- Potentially cause the workflow to fail
- Leave variables with "null" values that could cause downstream issues

## Solution
Added comprehensive error handling for all three calls:

### 1. Error Suppression
```bash
2>/dev/null
```
Suppresses error messages that would confuse users.

### 2. Fallback Values
```bash
|| echo "fallback"
```
Provides sensible defaults when commands fail.

### 3. Null Handling
```bash
if [[ "$VARIABLE" == "null" || -z "$VARIABLE" ]]; then
  VARIABLE="default"
fi
```
Handles cases where jq outputs "null" string instead of failing.

## Example: Before and After

### Before (Line 231)
```bash
USING="$(gh api /repos/.../commits/.../branches-where-head --jq '.[0].name')"
```
**Problem**: If API returns 404, the command fails and workflow stops.

### After (Line 231-235)
```bash
USING="$(gh api /repos/.../commits/.../branches-where-head --jq '.[0].name' 2>/dev/null || echo "main")"
# Handle null or empty response
if [[ "$USING" == "null" || -z "$USING" ]]; then
  USING="main"
fi
```
**Benefit**: API failures gracefully fall back to "main" branch, workflow continues.

## Testing
All error handling patterns were tested with:
- ✅ Invalid JSON responses
- ✅ API 404 errors
- ✅ Command failures
- ✅ Null values in JSON
- ✅ Successful API calls (no regression)

## Impact
This fix prevents workflow failures when:
- External repositories lack GitHub Pages configuration
- GitHub API returns 404, 403, or 401 errors
- API rate limits are hit
- Network issues cause API failures
- Invalid JSON is returned

All error cases now gracefully fall back to sensible defaults, allowing workflows to complete successfully.

## Files Changed
- `action.yml`: Lines 231-235, 241-249, 385-397

## Recommendation for Users
While this fix improves error handling, users deploying to external repositories should:
1. Ensure the external repository exists and is accessible
2. Use a PAT (Personal Access Token) with appropriate scopes
3. Manually enable GitHub Pages in the target repository if needed
4. Check workflow permissions include necessary API access

## Related
- Previous fix: GitHub Pages permission error handling (CHANGELOG_FIX.md)
- GitHub API documentation: https://docs.github.com/en/rest/pages
