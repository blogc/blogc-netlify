#!/bin/bash
#
# blogc runner for Netlify.
#
# Copyright (C) 2018 Rafael G. Martins <rafael@rafaelmartins.eng.br>
#
# This program can be distributed under the terms of the BSD License.
# See https://github.com/blogc/blogc/blob/master/LICENSE for details.
#

set -ex

I() {
    if [[ -z "${BLOGC_VERSION}" ]]; then
        BLOGC_VERSION=$(wget -qO- https://blogc.rgm.io/ | grep '^LATEST_RELEASE=' | cut -d= -f2)
    fi

    local P="blogc-static-amd64-${BLOGC_VERSION}"
    local BASE_URL="https://distfiles.rgm.io/blogc/blogc-${BLOGC_VERSION}"

    if ! wget -q "${BASE_URL}/${P}.xz"{,.sha512}; then
        echo "Failed to fetch blogc binary. Please check BLOGC_VERSION"
        exit 1
    fi

    sha512sum -c "${P}.xz.sha512"

    xz -cd "${P}.xz" > blogc
    chmod +x blogc

    ./blogc -m -f blogcfile all
}

I
