#!/bin/jq -f
#
# Author: Mike Weilgart
# Date: 16 January 2019
# Purpose: Extracts the meta promises from CFEngine policy.
#
# This should be run with:
#
#   cf-promises -p json-full | thisscript
#
# It can also be run on a specific CFEngine policy file with:
#
#   cf-promises -p json-full ./somefile | thisscript
#
# Example output object (there will be many of these):
#
# {
#   "file": "./configure_self.cf",
#   "linenumber": 30,
#   "bundle": "emacs",
#   "context": "any",
#   "promiser": "brief",
#   "metacomment": "Install emacs"
# }

.bundles[]
| {bundle: .name,file: .sourcePath}
  +
  (.promiseTypes[]
  | select(.name == "meta")
  | .contexts[]
  | {context: .name}
    +
    (.promises[]
    | {promiser}
      +
      (.attributes[]
      | select(.lval == "string")
      | {metacomment: .rval.value,linenumber: .line}
      )
    )
  )
| {file,linenumber,bundle,context,promiser,metacomment}
