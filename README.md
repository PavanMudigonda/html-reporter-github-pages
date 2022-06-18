# HTML Test Results on GitHub Pages with history action

Example workflow file [html-reporter-github-pages](https://github.com/PavanMudigonda/html-reporter-github-pages/blob/main/.github/workflows/test.yml)

## Inputs

### `test-results`

**Required** The relative path to the test results directory. 

Mandatory

### `gh_pages`

**Required** The relative path to the `gh-pages` branch folder. On first run this folder can be empty.
Also, you need to do a checkout of `gh-pages` branch, even it doesn't exist yet.

Default `gh-pages`

```yaml
- name: Get test results history
  uses: actions/checkout@v3
  if: always()
  continue-on-error: true
  with:
    ref: gh-pages
    path: gh-pages
```

### `results_history`

**Required** The relative path to the folder, that will be published to GitHub Pages.

Default `results-history`

### `subfolder`

The relative path to the project folder, if you have few different projects in the repository. 

Default ``

## Example usage (local action)

```yaml
- name: Test local action
  uses: ./html-reporter-github-pages@main
  if: always()
  id: test-results
  with:
    playwright_results: test-results
    gh_pages: gh-pages
    playwright_history: results-history
```

## Example usage (github action)

```yaml
- name: Test marketplace action
  uses: PavanMudigonda/html-reporter-github-pages@main
  id: test-report
  with:
    playwright_results: test-results
    gh_pages: gh-pages
    playwright_history: results-history
```

## Finally you need to publish on GitHub Pages

```yaml
- name: Deploy report to Github Pages
  if: always()
  uses: peaceiris/actions-gh-pages@v3
  env:
    PERSONAL_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    PUBLISH_BRANCH: gh-pages
    PUBLISH_DIR: results-history
```

## Also you can post the link to the report in the checks section

```yaml
- name: Post the link to the report
  if: always()
  uses: Sibz/github-status-action@v1
  with: 
      authToken: ${{secrets.GITHUB_TOKEN}}
      context: 'Test report'
      state: 'success'
      sha: ${{ github.event.pull_request.head.sha }}
      target_url: PavanMudigonda.github.io/html-reporter-github-pages/${{ github.run_number }}
```

### Sample GH Pages Home Page

<img width="626" alt="image" src="https://user-images.githubusercontent.com/29324338/174328988-d53bc4bd-e189-4179-8a42-2046b8c83a9b.png">

### Sample GH Pages Test Results

<img width="1287" alt="image" src="https://user-images.githubusercontent.com/29324338/174329137-a76d7c84-62b0-4724-aa37-440ea753b740.png">


