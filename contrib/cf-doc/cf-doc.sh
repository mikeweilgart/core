#!/bin/bash
# Author: Mike Weilgart
# Date: 18 January 2019
# Purpose: Extract summary documentation from specially prepared CFEngine policy.

# url_prefix should have a trailing slash
url_prefix=https://example.com/cfengine/masterfiles/blob/

collection='
{
  "metapromisers": {
    "inventory": "Inventory",
    "config": "Configuration"
  },
  "metatags": {
    "docinv": "Inventory",
    "docconfig": "Configuration"
  }
}
'

########################################################################
#                      USAGE MESSAGE                                   #
########################################################################
usage() {
cat >&2 <<EOF
SYNOPSIS
        cf-doc --help
        cf-doc [-f FILE] [-p VERSION] [-u URL] [-t]

DESCRIPTION
        cf-doc will extract particular meta tags and meta promises
        from CFEngine policy and will output a list of them in
        Markdown format.

        Each line of output is formatted as a URL linking back
        to the line of policy from which it was extracted.
        The -t option can also be used to generate plain text
        (no hyperlinks).

        cf-promises is used internally to parse CFEngine policy and
        generate json output, which is further parsed to produce
        the final script output.

        The particular meta tags and meta promises to be collected
        are as defined in the "collection" variable in this script.
        For further details on this see the inline documentation
        in the supporting script 'extract-cf-meta.jq'.

OPTIONS
        -f FILE         The CFEngine policy file to begin with for
                        parsing.  This is passed to cf-promises.
                        Default is none, so the cf-promises default
                        applies of /var/cfengine/inputs/promises.cf

        -p VERSION      Version of the policy that is being checked,
                        for inclusion in the URL.  Default is master.

        -u URL          URL prefix to use for all links.  Default is
                        coded into the script at the top and is intended
                        for modification to suit your site, but can also
                        be overridden on the command line with -u.
                        Current default is $url_prefix

        -t              Text only mode.  The -v and -u switches do nothing
                        if this option is passed, as the output will not
                        be markdown formatted as URLs.
EOF
}

########################################################################
#                     OPTIONS HANDLING                                 #
########################################################################
[ "$1" = --help ] && { usage; exit 0;}

filewaspassed=''
policy_version=master
# url_prefix is set at the top for easy customization by users
textonly=''

while getopts :f:p:u:t opt; do
  case "$opt" in
    f)
      filewaspassed='non-empty string for boolean true'
      file="${OPTARG}"
      ;;
    p)
      policy_version="${OPTARG}"
      ;;
    u)
      url_prefix="${OPTARG}"
      ;;
    t)
      textonly='non-empty string for boolean true'
      ;;
    :)
      printf 'Option -%s requires an argument\n' "$OPTARG" >&2
      usage
      exit 1
      ;;
    *)
      printf 'Invalid option: -%s\n' "$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done
shift "$((OPTIND-1))"
