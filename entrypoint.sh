#! /usr/bin/env bash

mkdir -p ./${INPUT_GH_PAGES}
mkdir -p ./${INPUT_PLAYWRIGHT_HISTORY}
cp -r ./${INPUT_GH_PAGES}/. ./${INPUT_PLAYWRIGHT_HISTORY}

REPOSITORY_OWNER_SLASH_NAME=${INPUT_GITHUB_REPO}
REPOSITORY_NAME=${REPOSITORY_OWNER_SLASH_NAME##*/}
GITHUB_PAGES_WEBSITE_URL="https://${INPUT_GITHUB_REPO_OWNER}.github.io/${REPOSITORY_NAME}"
#echo "Github pages url $GITHUB_PAGES_WEBSITE_URL"


if [[ ${INPUT_SUBFOLDER} != '' ]]; then
    INPUT_PLAYWRIGHT_HISTORY="${INPUT_PLAYWRIGHT_HISTORY}/${INPUT_SUBFOLDER}"
    INPUT_GH_PAGES="${INPUT_GH_PAGES}/${INPUT_SUBFOLDER}"
    echo "NEW playwright history folder ${INPUT_PLAYWRIGHT_HISTORY}"
    mkdir -p ./${INPUT_PLAYWRIGHT_HISTORY}
    GITHUB_PAGES_WEBSITE_URL="${GITHUB_PAGES_WEBSITE_URL}/${INPUT_SUBFOLDER}"
    echo "NEW github pages url ${GITHUB_PAGES_WEBSITE_URL}"
fi

if [[ ${INPUT_REPORT_URL} != '' ]]; then
    GITHUB_PAGES_WEBSITE_URL="${INPUT_REPORT_URL}"
    echo "Replacing github pages url with user input. NEW url ${GITHUB_PAGES_WEBSITE_URL}"
fi

COUNT=$( ( ls ./${INPUT_PLAYWRIGHT_HISTORY} | wc -l ) )
echo "count folders in playwright-history: ${COUNT}"
echo "keep reports count ${INPUT_KEEP_REPORTS}"
INPUT_KEEP_REPORTS=$((INPUT_KEEP_REPORTS+1))
echo "if ${COUNT} > ${INPUT_KEEP_REPORTS}"
if (( COUNT > INPUT_KEEP_REPORTS )); then
  cd ./${INPUT_PLAYWRIGHT_HISTORY}
  echo "remove index.html last-history"
  rm index.html last-history -rv
  echo "remove old reports"
  ls | sort -n | head -n -$((${INPUT_KEEP_REPORTS}-2)) | xargs rm -rv;
  cd ${GITHUB_WORKSPACE}
fi

#echo "index.html"
# echo "<!DOCTYPE html><meta charset=\"utf-8\"><meta http-equiv=\"refresh\" content=\"0; URL=${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/\">" > ./${INPUT_PLAYWRIGHT_HISTORY}/index.html # path
# echo "<meta http-equiv=\"Pragma\" content=\"no-cache\"><meta http-equiv=\"Expires\" content=\"0\">" >> ./${INPUT_PLAYWRIGHT_HISTORY}/index.html
# #cat ./${INPUT_PLAYWRIGHT_HISTORY}/index.html

cat index-template.html > ./${INPUT_PLAYWRIGHT_HISTORY}/index.html

echo "├── <a href="./${INPUT_GITHUB_RUN_NUM}/index.html">Latest Test Results - RUN ID: ${INPUT_GITHUB_RUN_NUM}</a><br>" >> ./${INPUT_PLAYWRIGHT_HISTORY}/index.html;
ls -l ./${INPUT_PLAYWRIGHT_HISTORY} | grep "^d" | sort -n | while read line;
    do 
        RUN_ID=$(awk -v line="$line" '{print $9}');
        echo "├── <a href="./${RUN_ID}/">RUN ID: ${RUN_ID}</a><br>" >> ./${INPUT_PLAYWRIGHT_HISTORY}/index.html; 
    done;
echo "</html>" >> ./${INPUT_PLAYWRIGHT_HISTORY}/index.html;
# cat ./${INPUT_PLAYWRIGHT_HISTORY}/index.html

#echo "executor.json"
echo '{"name":"GitHub Actions","type":"github","reportName":"Playwright Report with history",' > executor.json
echo "\"url\":\"${GITHUB_PAGES_WEBSITE_URL}\"," >> executor.json # ???
echo "\"reportUrl\":\"${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/\"," >> executor.json
echo "\"buildUrl\":\"https://github.com/${INPUT_GITHUB_REPO}/actions/runs/${INPUT_GITHUB_RUN_ID}\"," >> executor.json
echo "\"buildName\":\"GitHub Actions Run #${INPUT_GITHUB_RUN_ID}\",\"buildOrder\":\"${INPUT_GITHUB_RUN_NUM}\"}" >> executor.json
#cat executor.json
mv ./executor.json ./${INPUT_PLAYWRIGHT_RESULTS}

#environment.properties
echo "URL=${GITHUB_PAGES_WEBSITE_URL}" >> ./${INPUT_PLAYWRIGHT_RESULTS}/environment.properties


echo "keep playwright history from ${INPUT_GH_PAGES}/last-history to ${INPUT_PLAYWRIGHT_RESULTS}/history"
mkdir -p ${INPUT_PLAYWRIGHT_RESULTS}/history
cp -R ./${INPUT_GH_PAGES}/last-history/. ./${INPUT_PLAYWRIGHT_RESULTS}/history


echo "generating report from ${INPUT_PLAYWRIGHT_RESULTS} to ${INPUT_PLAYWRIGHT_REPORT} ..."
ls -l ${INPUT_PLAYWRIGHT_RESULTS}
#echo "listing report directory ..."

echo "copy playwright-results to ${INPUT_PLAYWRIGHT_HISTORY}/${INPUT_GITHUB_RUN_NUM}"
cp -R ./${INPUT_PLAYWRIGHT_RESULTS}/. ./${INPUT_PLAYWRIGHT_HISTORY}/${INPUT_GITHUB_RUN_NUM}
echo "copy playwright-results history to /${INPUT_PLAYWRIGHT_HISTORY}/last-history"
cp -R ./${INPUT_PLAYWRIGHT_RESULTS}/history/. ./${INPUT_PLAYWRIGHT_HISTORY}/last-history
