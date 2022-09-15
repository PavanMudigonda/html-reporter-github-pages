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

## COMPOSITE WORKFLOW ADDED AS DOCKER ACTION IS NOT WORKING FOR WINDOWS RUNNERS

## Inputs

This Action defines the following formal inputs.

| Name | Required | Default | Description
|-|-|-|-|
| **`test_results`** | true | none | provide name of the folder that has got the index.html and other static files to deploy on GH Pages. Example if my folder that has got all my test results is html-report then i would enter "html-report" as input value.
| **`subfolder`** | false | none | Provide the subfolder in case if your files that have index.html and other static content in present in subfolder. say i have a folder called "archive" and under that i have subfolder "html-report" in that case i would enter 'archive' for variable 'test_results' and 'html-report' under 'subfolder'
| **`gh_pages`** | false | gh_pages | name of the branch where you would like to push your static content to be published. Ideally it should be called gh_pages so default it to same but you have choice to modify it.
| **`keep_reports`** | false | 20 |  Number of reports you would like to retain. There is a 5GB limit on Git Repo. Defaulted to 20 reports but if you but ideally you should do math to calculate how many reports you could store. if your report size is say 50 MB then you could store up to a 100 reports.
|**`github_repo`** | false | ${{ github.repository }} | repo name that you would like to push gh-pages branch to. we default it to your curent repo where workflow is being run. If you would like to push to another repo please enter in format "XXXXXXXXX/project-awesome" in this format.
|**`report_url`** | false | None | Enter the URL of your GitHub Pages Site. 

## Outputs

This Action defines the following formal outputs.

| Name | How to use(value) | Description|Comments
|-|-|-|-|
| **`GH_PAGES_URL`**  | ${{ env.GH_PAGES_URL }} | GitHub Pages URL|you can use this to pass to subsequent patterns

## Example workflow - same repo

      - name: GH Pages Push
        uses: PavanMudigonda/html-reporter-github-pages/composite@v1.1
        with:
          test_results: test-results
          keep_reports: 20


## Example workflow - different repo

      - name: GH Pages Push
        uses: PavanMudigonda/html-reporter-github-pages/composite@v1.1
        with:
          test_results: test-results
          keep_reports: 20
          external_repository: XXXXXXXX/another-awesome-repo




### Sample GH Pages Home Page

<img width="626" alt="image" src="https://user-images.githubusercontent.com/29324338/174328988-d53bc4bd-e189-4179-8a42-2046b8c83a9b.png">

### Sample GH Pages Test Results

<img width="1287" alt="image" src="https://user-images.githubusercontent.com/29324338/174329137-a76d7c84-62b0-4724-aa37-440ea753b740.png">


