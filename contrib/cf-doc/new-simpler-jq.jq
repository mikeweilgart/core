#!/bin/jq -f

[
  .bundles[]
  | {file: .sourcePath}
    +
    (.promiseTypes[]
    | select(.name == "meta")
    | .contexts[]
    | (.promises[]
      | select(.promiser|in($collection.metapromisers))
      | {category: $collection.metapromisers[.promiser]}
        +
        (.attributes[]
        | select(.lval == "string")
        | {linenumber: .line,text: .rval.value }
        )
      )
    )
]
+
[
  .bundles[]
  | {file: .sourcePath}
    +
    (.promiseTypes[]
    | (.contexts[]
      | (.promises[]
        | (.attributes[]
          | select(.lval == "meta")
          | {linenumber: .line}
            +
            (.rval.value[].value
            | split("=")
            | select(.[0]|in($collection.metatags))
            | {category: $collection.metatags[.[0]]}
              +
              {text: .[1]}
            )
          )
        )
      )
    )
]
| group_by(.category)[]
| {(.[0].category): [.[]|del(.category)]}
