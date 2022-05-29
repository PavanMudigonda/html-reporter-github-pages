# Playwright HTML Test Results on GitHub Pages with history action


Example workflow file [playwright-github-pages]()

## Inputs

### `test-results`

**Required** The relative path to the Allure results directory. 

Default `test-results`

### `gh_pages`

**Required** The relative path to the `gh-pages` branch folder. On first run this folder can be empty.
Also, you need to do a checkout of `gh-pages` branch, even it doesn't exist yet.

Default `gh-pages`

```yaml
- name: Get Allure history
  uses: actions/checkout@v2
  if: always()
  continue-on-error: true
  with:
    ref: gh-pages
    path: gh-pages
```

### `allure_history`

**Required** The relative path to the folder, that will be published to GitHub Pages.

Default `allure-history`

### `subfolder`

The relative path to the project folder, if you have few different projects in the repository. 
This relative path also will be added to GitHub Pages link. Example project [allure-examples](https://github.com/simple-elf/allure-examples).

Default ``

## Example usage (local action)

```yaml
- name: Test local action
  uses: ./playwright-github-pages@main
  if: always()
  id: test-results
  with:
    test_results: test-results
    gh_pages: gh-pages
    allure_history: test-results-history
```

## Example usage (github action)

```yaml
- name: Test marketplace action
  uses: PavanMudigonda/playwright-github-pages@v0.1
  id: test-report
  with:
    test_results: test-results
    gh_pages: gh-pages
    test_results_history: test-results-history
```

## Finally you need to publish on GitHub Pages

```yaml
- name: Deploy report to Github Pages
  if: always()
  uses: peaceiris/actions-gh-pages@v2
  env:
    PERSONAL_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    PUBLISH_BRANCH: gh-pages
    PUBLISH_DIR: test-results
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
      target_url: PavanMudigonda.github.io/playwright-github-pages/${{ github.run_number }}
```
