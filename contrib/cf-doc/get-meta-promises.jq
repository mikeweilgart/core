#!/bin/jq -f

.bundles[]|{bundle: .name,file: .sourcePath,toBeFiltered: (.promiseTypes[]|select(.name == "meta")|.contexts[]|{context: .name,promises: .promises[]})}|{bundle,file,context: .toBeFiltered.context,promiser: .toBeFiltered.promises.promiser,metacomment: (.toBeFiltered.promises.attributes[]|select(.lval == "string")|.rval.value),linenumber: (.toBeFiltered.promises.attributes[]|select(.lval == "string")|.line)}
