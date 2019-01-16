#!/bin/jq -f

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
