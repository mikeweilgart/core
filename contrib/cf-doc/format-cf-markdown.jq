#!/bin/jq -rf
#
# Author: Mike Weilgart
# Date: 18 January 2019
# Purpose: Format specific json object into a pretty markdown list.
#
# The variables are expected to be set before this script runs, e.g.:
#
#   cat input.json |
#   jq --arg url_prefix "https://example.com/cfengine/masterfiles/blob/" \
#     --arg policy_version "master" -r -f thisscript

"\n# " + .header
,
(.info[]
| "- ["
  + .text
  + "]("
  + $url_prefix
  + $policy_version
  + "/"
  + .file
  + "#L"
  + (.linenumber|tostring)
  + ")"
)
