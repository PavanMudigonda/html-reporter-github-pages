# PavanMudigonda/html-reporter-github-pages@v1.5

## Enhanced GitHub Pages HTML Reporter

**Major improvements in v1.5:**
- ✅ **Enhanced Branch Management**: Better orphan branch creation with proper stashing
- ✅ **Robust External Repository Support**: Improved handling of external repositories with fallback mechanisms  
- ✅ **Better GitHub CLI Integration**: Uses `sersoft-gmbh/setup-gh-cli-action@v2.0.1` for reliable CLI setup
- ✅ **Improved Error Handling**: Enhanced API calls with `--silent` flag and better error messages
- ✅ **Advanced Configuration**: New `use_actions_summary` input for controlling job summary outputs
- ✅ **Enhanced Environment Files**: More comprehensive environment.properties with Git metadata
- ✅ **Java 17 Support**: Updated from Java 11 to Java 17 for better Allure report generation
- ✅ **Force Orphan Protection**: Added `force_orphan: false` to prevent accidental history loss
- ✅ **Better Script Management**: Scripts now bundled with action instead of downloading at runtime

**If you like my Github Action, please STAR ⭐ it**

## Example workflow - same repo

      - name: ANY REPORT - GH Pages Push - SAME REPO
        uses: PavanMudigonda/html-reporter-github-pages@v1.5
        with:
          test_results: test-results
          keep_reports: 20
          gh_pages: gh_pages # BRANCH NAME you like
          subfolder: docs  # Level 1 Folder Structure you like
          tool_name: cucumber # Level 2 Folder Structure you like
          workflow_name: ${{ github.workflow }} # Level 3 Folder Structure you like
          env: QA # Level 4 Folder Structure you like
          use_actions_summary: true # Control job summary output
          token: ${{ secrets.GH_PAT }} # Please note we need GitHub Personal Access Token to perform gh pages deploy


## Example workflow - different repo


      - name: ANY REPORT - GH Pages Push - ANOTHER REPO
        uses: PavanMudigonda/html-reporter-github-pages@v1.5
        with:
          test_results: test-results
          keep_reports: 20
          gh_pages: gh_pages # BRANCH NAME you like
          subfolder: docs  # Level 1 Folder Structure you like
          tool_name: cucumber # Level 2 Folder Structure you like
          workflow_name: ${{ github.workflow }} # Level 3 Folder Structure you like
          env: QA # Level 4 Folder Structure you like
          external_repository: PavanMudigonda/another-awesome-repo
          use_actions_summary: true # Control job summary output
          token: ${{ secrets.GH_PAT }} # Please note we need GitHub Personal Access Token to perform gh pages deploy and to commit to another repo
          

## ALLURE REPORT EXAMPLE - Same Repo

      - name: ALLURE REPORT - GH Pages Push - SAME REPO
        uses: PavanMudigonda/html-reporter-github-pages@v1.5
        with:
          test_results: allure-results
          allure_report_generate_flag: true
          keep_reports: 20
          gh_pages: gh_pages # BRANCH NAME you like
          subfolder: docs  # Level 1 Folder Structure you like
          tool_name: allure # Level 2 Folder Structure you like
          workflow_name: ${{ github.workflow }} # Level 3 Folder Structure you like
          token: ${{ secrets.GH_PAT }} # Please note we need GitHub Personal Access Token to perform gh pages deploy

## Demo https://pavanmudigonda.github.io/html-reporter-github-pages/

<img width="1397" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/ca3af1f9-9134-4bb3-895c-b7ee4f6009b7">
<img width="1359" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/a525e133-9cd4-483f-aafb-3890121d7840">
<img width="1389" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/b48061c7-de68-4526-81d2-45cd031f8380">
<img width="1413" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/36a20555-a154-4856-a117-6eff9c92d89c">
<img width="1391" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/a577a6fd-71f0-47df-8754-90c1c7a2d698">
<img width="1412" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/2213758d-9b1f-4792-8bbd-5456eed87b5e">
<img width="1365" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/ea45736f-373f-4875-bcf7-bf6197b1e579">
<img width="1195" alt="image" src="https://github.com/PavanMudigonda/html-reporter-github-pages/assets/29324338/71e7c6d3-d695-4e34-aba1-36d7b05f0922">

## Inputs

This Action defines the following formal inputs.

| Name | Required | Default | Description
|-|-|-|-|
| **`test_results`** | true | none | provide name of the folder that has got the index.html and other static files to deploy on GH Pages. Example if my folder that has got all my test results is html-report then i would enter "html-report" as input value. If you are working with Allure and if you would like to have this action generate Allure Report out of the RAW Results, Then make sure you provide Allure RAW Results Path instead, this way we can track history of allure test results better.
| **`gh_pages`** | false | gh-pages | name of the branch where you would like to push your static content to be published. Ideally it should be called gh-pages so default it to same but you have choice to modify it.
| **`keep_reports`** | false | 20 |  Number of reports you would like to retain. There is a 5GB limit on Git Repo. Defaulted to 20 reports but if you but ideally you should do math to calculate how many reports you could store. if your report size is say 50 MB then you could store up to a 100 reports.
|**`github_repo`** | false | ${{ github.repository }} | repo name that you would like to push gh-pages branch to. we default it to your curent repo where workflow is being run. If you would like to push to another repo please enter that repo name in `external_repository` described below.
|**`external_repository`** | false | ${{ github.repository }} | repo name that you would like to push gh-pages branch to. we default it to your curent repo where workflow is being run. If you would like to push to another repo please enter in format "PavanMudigonda/project-awesome" in this format.
|**`report_url`** | false | None | Enter the URL of your GitHub Pages Site if its different from standards url.
| **`subfolder`** | false | none | Provide the subfolder you like results stored in say "docs" directory. for example docs/41, docs/21 in this fashion. This is Level 1 Folder Structure
|**`tool_name`** | false | None | This is for level 2 Folder Structure. you can overwrite with some other value. we don't care.
|**`workflow_name`** | false | ${{ github.workflow }} | This is for level 3 Folder Structure. you can overwrite with some other value. we don't care.
|**`env`** | false | None | This is for level 4 Folder Structure. you can overwrite with some other value. we don't care.
|**`order`** | true | descending | Order of Folders, ascending or descending.
|**`allure_report_generate_flag`** | false | false | If you are working with Allure and if you would like to have this action generate Allure Report out of the RAW Results, then select True. Make sure you provide Allure RAW Results Path for input **test_results**
| **`token`** | true | GITHUB_TOKEN | Please note we need GitHub Personal Access Token to perform gh pages deploy and to commit to another repo. The default GITHUB_TOKEN doesn't have deployment and commit to another repo permissions.

## Outputs

This Action defines the following formal outputs.

| Name | How to use(value) | Description|Comments
|-|-|-|-|
| **`GITHUB_PAGES_WEBSITE_URL`**  | ${{ env.GITHUB_PAGES_WEBSITE_URL }} | GitHub Pages Home URL|you can use this to pass to subsequent patterns
| **`PLEASE SEE NEXT COLUMN`**  | '${{ env.GITHUB_PAGES_WEBSITE_URL }}/${github.run_number}/index.html' | GitHub Pages Latest Run result URL|you can use this to pass to subsequent patterns
