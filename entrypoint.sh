#! /usr/bin/env bash

          cat > index-template.html <<EOF

<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <title>Test Results</title>
 <style type="text/css">
  BODY { font-family : monospace, sans-serif;  color: black;}
  P { font-family : monospace, sans-serif; color: black; margin:0px; padding: 0px;}
  A:visited { text-decoration : none; margin : 0px; padding : 0px;}
  A:link    { text-decoration : none; margin : 0px; padding : 0px;}
  A:hover   { text-decoration: underline; background-color : yellow; margin : 0px; padding : 0px;}
  A:active  { margin : 0px; padding : 0px;}
  .VERSION { font-size: small; font-family : arial, sans-serif; }
  .NORM  { color: black;  }
  .FIFO  { color: purple; }
  .CHAR  { color: yellow; }
  .DIR   { color: blue;   }
  .BLOCK { color: yellow; }
  .LINK  { color: aqua;   }
  .SOCK  { color: fuchsia;}
  .EXEC  { color: green;  }
 </style>
</head>
<body>
	<h1>Test Results</h1><p>
	<a href=".">.</a><br>

EOF

mkdir -p ./${INPUT_GH_PAGES}
mkdir -p ./${INPUT_RESULTS_HISTORY}
cp -r ./${INPUT_GH_PAGES}/. ./${INPUT_RESULTS_HISTORY}

REPOSITORY_OWNER_SLASH_NAME=${INPUT_GITHUB_REPO}
REPOSITORY_NAME=${REPOSITORY_OWNER_SLASH_NAME##*/}
GITHUB_PAGES_WEBSITE_URL="https://${INPUT_GITHUB_REPO_OWNER}.github.io/${REPOSITORY_NAME}"
#echo "Github pages url $GITHUB_PAGES_WEBSITE_URL"


if [[ ${INPUT_SUBFOLDER} != '' ]]; then
    INPUT_RESUTLS_HISTORY="${INPUT_RESULTS_HISTORY}/${INPUT_SUBFOLDER}"
    INPUT_GH_PAGES="${INPUT_GH_PAGES}/${INPUT_SUBFOLDER}"
    echo "NEW results history folder ${INPUT_RESULTS_HISTORY}"
    mkdir -p ./${INPUT_RESULTS_HISTORY}
    GITHUB_PAGES_WEBSITE_URL="${GITHUB_PAGES_WEBSITE_URL}/${INPUT_SUBFOLDER}"
    echo "NEW github pages url ${GITHUB_PAGES_WEBSITE_URL}"
fi

if [[ ${INPUT_REPORT_URL} != '' ]]; then
    GITHUB_PAGES_WEBSITE_URL="${INPUT_REPORT_URL}"
    echo "Replacing github pages url with user input. NEW url ${GITHUB_PAGES_WEBSITE_URL}"
fi

COUNT=$( ( ls ./${INPUT_RESULTS_HISTORY} | wc -l ) )
echo "count folders in results-history: ${COUNT}"
echo "keep reports count ${INPUT_KEEP_REPORTS}"
INPUT_KEEP_REPORTS=$((INPUT_KEEP_REPORTS+1))
echo "if ${COUNT} > ${INPUT_KEEP_REPORTS}"
if (( COUNT > INPUT_KEEP_REPORTS )); then
  cd ./${INPUT_RESULTS_HISTORY}
  echo "remove index.html last-history"
  rm index.html last-history -rv
  echo "remove old reports"
  ls | sort -n | head -n -$((${INPUT_KEEP_REPORTS}-2)) | xargs rm -rv;
  cd ${GITHUB_WORKSPACE}
fi


cat index-template.html > ./${INPUT_RESULTS_HISTORY}/index.html

echo "├── <a href="./${INPUT_GITHUB_RUN_NUM}/index.html">Latest Test Results - RUN ID: ${INPUT_GITHUB_RUN_NUM}</a><br>" >> ./${INPUT_RESULTS_HISTORY}/index.html;
ls -l ./${INPUT_RESULTS_HISTORY} | grep "^d" | sort -nr | awk -F' ' '{print $9;}' | while read line;
    do
#       RUN_ID=$(awk -v '$1 == $line {print $9}');
#         RUN_ID=$(awk -F '{print $0;}');
        echo "├── <a href="./"${line}"/">RUN ID: "${line}"</a><br>" >> ./${INPUT_RESULTS_HISTORY}/index.html; 
    done;
echo "</html>" >> ./${INPUT_RESULTS_HISTORY}/index.html;
# cat ./${INPUT_RESULTS_HISTORY}/index.html

#echo "executor.json"
echo '{"name":"GitHub Actions","type":"github","reportName":"Test Results Report with history",' > executor.json
echo "\"url\":\"${GITHUB_PAGES_WEBSITE_URL}\"," >> executor.json # ???
echo "\"reportUrl\":\"${GITHUB_PAGES_WEBSITE_URL}/${INPUT_GITHUB_RUN_NUM}/\"," >> executor.json
echo "\"buildUrl\":\"https://github.com/${INPUT_GITHUB_REPO}/actions/runs/${INPUT_GITHUB_RUN_ID}\"," >> executor.json
echo "\"buildName\":\"GitHub Actions Run #${INPUT_GITHUB_RUN_ID}\",\"buildOrder\":\"${INPUT_GITHUB_RUN_NUM}\"}" >> executor.json
#cat executor.json
mv ./executor.json ./${INPUT_TEST_RESULTS}

#environment.properties
echo "URL=${GITHUB_PAGES_WEBSITE_URL}" >> ./${INPUT_TEST_RESULTS}/environment.properties


echo "keep test results history from ${INPUT_GH_PAGES}/last-history to ${INPUT_TEST_RESULTS}/history"
mkdir -p ${INPUT_TEST_RESULTS}/history
cp -R ./${INPUT_GH_PAGES}/last-history/. ./${INPUT_TEST_RESULTS}/history


echo "generating report from ${INPUT_TEST_RESULTS} to ${INPUT_TEST_REPORT} ..."
ls -l ${INPUT_TEST_RESULTS}
#echo "listing report directory ..."

echo "copy test-results to ${INPUT_RESULTS_HISTORY}/${INPUT_GITHUB_RUN_NUM}"
cp -R ./${INPUT_TEST_RESULTS}/. ./${INPUT_RESULTS_HISTORY}/${INPUT_GITHUB_RUN_NUM}
echo "copy test-results history to /${INPUT_RESULTS_HISTORY}/last-history"
cp -R ./${INPUT_TEST_RESULTS}/history/. ./${INPUT_RESULTS_HISTORY}/last-history
