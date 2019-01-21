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

filepassed=''
policy_version=master
# url_prefix is set at the top for easy customization by users
textonly=''

while getopts :f:p:u:t opt; do
  case "$opt" in
    f)
      filepassed="${OPTARG}"
      # Known bug/unexpected behavior: if you call the script with -f ''
      # it will act as though the -f flag and its argument were omitted
      # entirely rather than throw an error, so cf-promises will be run
      # without any -f flag.  For interactive use this shouldn't matter
      # but if you're scripting something around cf-doc then be sure to
      # check any variable you pass to the -f flag if you care about
      # reporting an error for an empty string argument.
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

########################################################################
#                     MAIN ACTION                                      #
########################################################################

# Allow proper building of the link e.g. for GitLab
# We only need this if we're generating markdown
if [ "$textonly" ]; then
  :
else
  if [ "$filepassed" ]; then # there was a file passed
    # If the file passed has a slash then use the dirname,
    # otherwise cf-promises will default to /var/cfengine/inputs/
    # to find the file passed, so we'll use that.
    if [ "${filepassed%/*}" = "$filepassed" ]; then # no slash
      trimstring='/var/cfengine/inputs/'
    else
      trimstring="$(dirname "$filepassed")/"
    fi
  else # no file passed, use fallback dir
    trimstring='/var/cfengine/inputs/'
  fi
fi

thisdir="$(dirname "$0")"

cf-promises -p json-full ${filepassed:+-f "$filepassed"} |
  jq --argjson collection "$collection" -f "$thisdir"/extract-cf-meta.jq |
  if [ "$textonly" ]; then
    jq -r '"\n# " + .header , (.info[] | "- " + .text)'
  else
    jq --arg url_prefix "$url_prefix" --arg policy_version "$policy_version" --arg trimstring "$trimstring" -rf "$thisdir"/format-cf-markdown.jq
  fi
