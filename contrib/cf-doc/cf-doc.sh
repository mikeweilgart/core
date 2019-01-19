#!/bin/bash
# Author: Mike Weilgart
# Date: 18 January 2019
# Purpose: Extract summary documentation from specially prepared CFEngine policy.

url_prefix=https://example.com/cfengine/masterfiles/blob/

usage() {
cat >&2 <<EOF
SYNOPSIS
        cf-doc --help
        cf-doc [-f FILE] [-v VERSION] [-u URL] [-t]

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
        the above output.

OPTIONS
        -f FILE         The CFEngine policy file to begin with for
                        parsing.  This is passed to cf-promises.
                        Default is none, so the cf-promises default
                        applies of /var/cfengine/inputs/promises.cf

        -v VERSION      Version of the policy that is being checked,
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

[ "$1" = --help ] && { usage; exit 0;}
