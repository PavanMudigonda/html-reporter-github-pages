| **Reporter**        | **Github Pages**   | **Azure Storage Static Website** | **AWS S3 Static Website**                                                                    |
|---------------------|--------------------|-------------------------------|----------------------------------------------------------------------------------------------|
| **Allure HTML**     | [GH Action Link](https://github.com/marketplace/actions/allure-html-reporter-github-pages) | [GH Action Link](https://github.com/marketplace/actions/allure-html-reporter-azure-website)            | [GH Action Link](https://github.com/marketplace/actions/allure-html-reporter-aws-s3-website )      |
| **Any HTML Reports** | [GH Action Link](https://github.com/marketplace/actions/html-reporter-github-pages) | [GH Action Link](https://github.com/marketplace/actions/html-reporter-azure-website)            | [GH Action Link](https://github.com/marketplace/actions/html-reporter-aws-s3-website) |



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
    test_results: test-results
    gh_pages: gh-pages
    results_history: results-history
```

## Example usage (github action)

```yaml
- name: Test marketplace action
  uses: PavanMudigonda/html-reporter-github-pages@v1.0
  id: test-report
  with:
    test_results: test-results
    gh_pages: gh-pages
    results_history: results-history
```

## Finally you need to publish on GitHub Pages

```yaml
      - name: Publish Github Pages
        if: ${{ always() }}
        uses: peaceiris/actions-gh-pages@v3.8.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_branch: gh-pages
          publish_dir: results-history
          keep_files: true 
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


