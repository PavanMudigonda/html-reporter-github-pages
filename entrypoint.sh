#! /usr/bin/env bash

mkdir -p ./${INPUT_GH_PAGES}
mkdir -p ./${INPUT_TEST_RESULTS_HISTORY}
cp -r ./${INPUT_GH_PAGES}/. ./${INPUT_TEST_RESULTS}

REPOSITORY_OWNER_SLASH_NAME=${INPUT_GITHUB_REPO}
REPOSITORY_NAME=${REPOSITORY_OWNER_SLASH_NAME##*/}
GITHUB_PAGES_WEBSITE_URL="https://${INPUT_GITHUB_REPO_OWNER}.github.io/${REPOSITORY_NAME}"
#echo "Github pages url $GITHUB_PAGES_WEBSITE_URL"

if [[ ${INPUT_SUBFOLDER} != '' ]]; then
    INPUT_TEST_RESULTS="${INPUT_TEST_RESULTS}/${INPUT_SUBFOLDER}"
    INPUT_GH_PAGES="${INPUT_GH_PAGES}/${INPUT_SUBFOLDER}"
    echo "NEW test results history folder ${INPUT_TEST_RESULTS}"
    mkdir -p ./${INPUT_TEST_RESULTS}
    GITHUB_PAGES_WEBSITE_URL="${GITHUB_PAGES_WEBSITE_URL}/${INPUT_SUBFOLDER}"
    echo "NEW github pages url ${GITHUB_PAGES_WEBSITE_URL}"
fi

if [[ ${INPUT_REPORT_URL} != '' ]]; then
    GITHUB_PAGES_WEBSITE_URL="${INPUT_REPORT_URL}"
    echo "Replacing github pages url with user input. NEW url ${GITHUB_PAGES_WEBSITE_URL}"
fi

COUNT=$( ( ls ./${INPUT_TEST_RESULTS} | wc -l ) )
echo "count folders in test-results-history: ${COUNT}"
echo "keep reports count ${INPUT_KEEP_REPORTS}"
INPUT_KEEP_REPORTS=$((INPUT_KEEP_REPORTS+1))
echo "if ${COUNT} > ${INPUT_KEEP_REPORTS}"
if (( COUNT > INPUT_KEEP_REPORTS )); then
  cd ./${INPUT_TEST_RESULTS}
  echo "remove index.html last-history"
  rm index.html last-history -rv
  echo "remove old reports"
  ls | sort -n | head -n -$((${INPUT_KEEP_REPORTS}-2)) | xargs rm -rv;
  cd ${GITHUB_WORKSPACE}
fi

#echo "index.html"
echo "<!DOCTYPE html><meta charset=\"utf-8\"><meta http-equiv=\"refresh\" content=\"0; URL=${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/\">" > ./${INPUT_TEST_RESULTS}/index.html # path
echo "<meta http-equiv=\"Pragma\" content=\"no-cache\"><meta http-equiv=\"Expires\" content=\"0\">" >> ./${INPUT_TEST_RESULTS}/index.html
#cat ./${INPUT_TEST_RESULTS}/index.html

#echo "executor.json"
echo '{"name":"GitHub Actions","type":"github","reportName":"Allure Report with history",' > executor.json
echo "\"url\":\"${GITHUB_PAGES_WEBSITE_URL}\"," >> executor.json # ???
echo "\"reportUrl\":\"${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/\"," >> executor.json
echo "\"buildUrl\":\"https://github.com/${INPUT_GITHUB_REPO}/actions/runs/${INPUT_GITHUB_RUN_ID}\"," >> executor.json
echo "\"buildName\":\"GitHub Actions Run #${INPUT_GITHUB_RUN_ID}\",\"buildOrder\":\"${INPUT_GITHUB_RUN_NUM}\"}" >> executor.json
#cat executor.json
mv ./executor.json ./${INPUT_TEST_RESULTS}

#environment.properties
echo "URL=${GITHUB_PAGES_WEBSITE_URL}" >> ./${INPUT_TEST_RESULTS}/environment.properties

echo "keep test results history from ${INPUT_GH_PAGES}/last-history to ${INPUT_TEST_RESULTS}/history"
cp -r ./${INPUT_GH_PAGES}/last-history/. ./${INPUT_TEST_RESULTS}/history


echo "copy allure-report to ${INPUT_TEST_RESULTS_HISTORY}/${INPUT_GITHUB_RUN_NUM}"
cp -r ./${INPUT_TEST_RESULTS}/. ./${INPUT_TEST_RESULTS_HISTORY}/${INPUT_GITHUB_RUN_NUM}
echo "copy test results history to /${INPUT_TEST_RESULTS_HISTORY}/last-history"
cp -r ./${INPUT_TEST_RESULTS}/history/. ./${INPUT_TEST_RESULTS_HISTORY}/last-history
