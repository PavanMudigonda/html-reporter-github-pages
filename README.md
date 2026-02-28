# PavanMudigonda/html-reporter-github-pages@v1.5.21

## Enhanced GitHub Pages HTML Reporter

**If you like my Github Action, please STAR ⭐ it**

## ⚠️ Important: Permissions Required

This action requires **write permissions** to push content to GitHub Pages. You have two options:

### Option 1: Grant permissions to GITHUB_TOKEN (Recommended)

Add `permissions: contents: write` to your workflow:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: write  # Required for pushing to gh-pages branch
      pages: write     # Optional: enables automatic GitHub Pages configuration via API
    steps:
      - uses: actions/checkout@v4
      - uses: PavanMudigonda/html-reporter-github-pages@v1.5.21
        with:
          test_results: test-results
          # No need to specify token - uses GITHUB_TOKEN automatically
```

**Note about `pages: write` permission:**
- **Without it**: The action will successfully deploy your reports to GitHub Pages. The action intelligently detects the deployment method (GitHub Actions vs. legacy branch-based) and will only attempt to configure GitHub Pages settings for legacy deployments. You may need to manually enable GitHub Pages in Settings → Pages on the first deployment.
- **With it**: The action can automatically configure GitHub Pages settings (branch and folder) via the API for legacy branch-based deployments, providing a fully automated experience.
- **Important**: When using the "GitHub Actions" deployment method (recommended), the action automatically detects this and skips source branch configuration since it's not applicable. You won't see permission warnings in this case.

### Option 2: Use a Personal Access Token (PAT)

If you need to push to a different repository or require additional permissions:

```yaml
- uses: PavanMudigonda/html-reporter-github-pages@v1.5.21
  with:
    test_results: test-results
    token: ${{ secrets.GH_PAT }}  # PAT with repo and pages:write permissions
    external_repository: username/another-repo  # optional
```

To create a PAT: Settings → Developer settings → Personal access tokens → Generate new token (with `repo` scope, and optionally `pages: write` for automatic configuration)

## Example workflow - same repo

**Complete workflow example:**

```yaml
name: Deploy Test Report

on:
  push:
    branches: [main]

jobs:
  test-and-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: write  # Required to push to gh-pages branch
      pages: write     # Optional: enables automatic GitHub Pages configuration
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Run tests
        run: npm test  # or your test command
      
      - name: Deploy Report to GitHub Pages
        uses: PavanMudigonda/html-reporter-github-pages@v1.5.21
        with:
          test_results: test-results
          keep_reports: 20
          gh_pages: gh_pages # BRANCH NAME you like #defaults to gh_pages #do not modify if you are not sure
          subfolder: docs  # Level 1 Folder Structure you like #defaults to docs #do not modify if you are not sure
          tool_name: cucumber # Level 2 Folder Structure you like
          workflow_name: ${{ github.workflow }} # Level 3 Folder Structure you like
          env: QA # Level 4 Folder Structure you like
          use_actions_summary: true # Control job summary output
          # token defaults to GITHUB_TOKEN - no need to specify if permissions.contents: write is set
```


## Example workflow - different repo

**For deploying to a different repository, you MUST use a Personal Access Token:**

```yaml
name: Deploy to External Repo

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy Report to External GitHub Pages
        uses: PavanMudigonda/html-reporter-github-pages@v1.5.21
        with:
          test_results: test-results
          keep_reports: 20
          gh_pages: gh_pages # BRANCH NAME you like #defaults to gh_pages #do not modify if you are not sure
          subfolder: docs  # Level 1 Folder Structure you like #defaults to docs #do not modify if you are not sure
          tool_name: cucumber # Level 2 Folder Structure you like
          workflow_name: ${{ github.workflow }} # Level 3 Folder Structure you like
          env: QA # Level 4 Folder Structure you like
          external_repository: PavanMudigonda/another-awesome-repo
          use_actions_summary: true # Control job summary output
          token: ${{ secrets.GH_PAT }} # REQUIRED: PAT with repo permissions for external repository
```

## ALLURE REPORT EXAMPLE - Same Repo

```yaml
name: Allure Report

on:
  push:
    branches: [main]

jobs:
  allure-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: write  # Required to push to gh-pages branch
      pages: write     # Optional: enables automatic GitHub Pages configuration
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Run tests and generate Allure results
        run: npm test  # Should generate allure-results folder
      
      - name: Deploy Allure Report to GitHub Pages
        uses: PavanMudigonda/html-reporter-github-pages@v1.5.21
        with:
          test_results: allure-results
          allure_report_generate_flag: true
          keep_reports: 20
          gh_pages: gh_pages # BRANCH NAME you like #defaults to gh_pages #do not modify if you are not sure
          subfolder: docs  # Level 1 Folder Structure you like #defaults to docs #do not modify if you are not sure
          tool_name: allure # Level 2 Folder Structure you like
          workflow_name: ${{ github.workflow }} # Level 3 Folder Structure you like
          # token defaults to GITHUB_TOKEN - no need to specify if permissions.contents: write is set
```

## Demo https://pavanmudigonda.github.io/html-reporter-github-pages/


<img width="1512" height="519" alt="image" src="https://github.com/user-attachments/assets/063f6d4c-1ccb-4175-82e5-091c604c94ef" />
<img width="1473" height="527" alt="image" src="https://github.com/user-attachments/assets/3cfe3088-4d01-4328-a024-079bdd753bc8" />
<img width="1460" height="410" alt="image" src="https://github.com/user-attachments/assets/39995d8e-33d9-41c4-af48-c41a43c696ab" />
<img width="1453" height="910" alt="image" src="https://github.com/user-attachments/assets/aa85ac75-e1df-4e08-a5ab-bc1fae7c5ab3" />
<img width="1456" height="347" alt="image" src="https://github.com/user-attachments/assets/039dea37-df8e-4032-9c9f-eb11373af559" />
<img width="1408" height="904" alt="image" src="https://github.com/user-attachments/assets/3399cf75-83cf-41bc-b4d0-936e2ca37039" />
<img width="1291" height="910" alt="image" src="https://github.com/user-attachments/assets/9cc156d3-674d-4574-8eab-d403d15e9f3d" />
<img width="1505" height="773" alt="image" src="https://github.com/user-attachments/assets/b5fe5e5d-2a1f-45db-9c48-34ea44387e24" />












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
| **`token`** | false | GITHUB_TOKEN | GitHub token for authentication. For same-repo deployments, the default GITHUB_TOKEN works if you grant `permissions: contents: write` in your workflow. For external repository deployments, you MUST provide a Personal Access Token (PAT) with `repo` scope.
|**`use_actions_summary`** | false | true | Write GitHub Pages URLs to the GitHub Actions Job Summary.
|**`force_orphan`** | false | true | Create a fresh orphan commit on each deploy, eliminating git history to keep the gh-pages branch small. Recommended for large or frequent deployments. Set to `false` if you need to retain commit history on the gh-pages branch.

## Outputs

This Action defines the following formal outputs.

| Name | How to use(value) | Description|Comments
|-|-|-|-|
| **`GITHUB_PAGES_WEBSITE_URL`**  | ${{ env.GITHUB_PAGES_WEBSITE_URL }} | GitHub Pages Home URL|you can use this to pass to subsequent patterns
| **`PLEASE SEE NEXT COLUMN`**  | '${{ env.GITHUB_PAGES_WEBSITE_URL }}/${github.run_number}/index.html' | GitHub Pages Latest Run result URL|you can use this to pass to subsequent patterns

## FAQ

### Why do I see "Resource not accessible by integration" (403) when getting the GitHub Pages URL?

The default `GITHUB_TOKEN` does **not** have permission to read GitHub Pages configuration via the API. The action will still deploy your reports correctly — only the URL lookup step is affected.

**To fix it**, add `pages: write` to your workflow permissions:

```yaml
permissions:
  contents: write  # Required: push to gh-pages branch
  pages: write     # Optional: enables GitHub Pages API calls (URL lookup, auto-configuration)
```

If you don't add `pages: write`, the action will construct the URL from your repository name (e.g., `https://<owner>.github.io/<repo>/`) which works for most cases.

### How does `keep_reports` work? Do I need my own cleanup code?

No — the action handles cleanup automatically. When the number of report folders exceeds `keep_reports`, the **oldest reports are deleted** before the new one is added. No custom housekeeping code is needed.

### Why is my GitHub Pages URL something like `verbose-robot-pgv5y5j.pages.github.io` instead of `<owner>.github.io/<repo>`?

This happens when your repository is **private**. GitHub assigns a randomized subdomain for private repo GitHub Pages to prevent URL enumeration. This URL is stable for a given repo but differs per repository. You **cannot change it**, but you can use the `report_url` input to override the URL displayed in the action's output:

```yaml
- uses: PavanMudigonda/html-reporter-github-pages@v1.5.4
  with:
    test_results: test-results
    report_url: https://verbose-robot-pgv5y5j.pages.github.io
```

### How is the report URL structured?

The full path to a specific report run follows this pattern:

```
<pages_url>/<subfolder>/<tool_name>/<workflow_name>/<env>/<run_number>/index.html
```

For example: `https://blah-blah.pages.github.io/docs/cucumber/CucumberBranchRunner/QA/137/index.html`

The action outputs the latest result URL as `LATEST_RUN_GH_PAGES_URL` which you can use in subsequent steps.
