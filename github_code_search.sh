#!/bin/bash

set -euxo pipefail

GITHUB_TOKEN="MY_GITHUB_PERSONAL_ACCESS_TOKEN"
GITHUB_ORG="MY_GITHUB_ORGANIZATION"
CODE_SEARCH_QUERY="grafana"

curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/search/code?q=org:$GITHUB_ORG+$CODE_SEARCH_QUERY \
    | jq \
      '.items[] | {repository: .repository["full_name"], file_path: .path, html_url: .html_url}' \
    | jq -s --arg GITHUB_ORG "$GITHUB_ORG" --arg CODE_SEARCH_QUERY "$CODE_SEARCH_QUERY" \
      'sort_by(.repository) | {github_code_search: {github_organization: $GITHUB_ORG, code_search_query_string: $CODE_SEARCH_QUERY, code_search_results_count: [.[]] | length, code_search_results: [.[]]}}' \
    > code_search_results.json
