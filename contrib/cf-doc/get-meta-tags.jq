#!/bin/jq -f
#
# Author: Mike Weilgart
# Date: 17 January 2019
# Purpose: Extracts the meta tags from CFEngine policy
#   which start with the string "doc".
#
# This should be run with:
#
#   cf-promises -p json-full | thisscript
#
# It can also be run on a specific CFEngine policy file with:
#
#   cf-promises -p json-full ./somefile | thisscript
#
# Example output objects showing the two intended uses,
# "docinv" and "docconfig":
#
# {
#   "file": "./ourpolicy/inventory.cf",
#   "bundle": "inventory",
#   "promiseType": "methods",
#   "context": "redhat",
#   "promiser": "Inventory Enabled Services",
#   "linenumber": 24,
#   "docinv": "Enabled services"
# }
# {
#   "file": "./ourpolicy/time.cf",
#   "bundle": "time",
#   "promiseType": "files",
#   "context": "!(special_hosts)",
#   "promiser": "/etc/localtime",
#   "linenumber": 13,
#   "docconfig": "Set timezone to GMT"
# }

.bundles[]
| {file: .sourcePath,bundle: .name}
  +
  (.promiseTypes[]
  | {promiseType: .name}
    +
    (.contexts[]
    | {context: .name}
      +
      (.promises[]
      | {promiser}
        +
        (.attributes[]
        | select(.lval == "meta")
        | {linenumber: .line}
          +
          (.rval.value[].value
          | select(startswith("doc"))
          | split("=")
          | {(.[0]): .[1]}
          )
        )
      )
    )
  )
