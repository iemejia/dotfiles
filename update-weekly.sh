#!/usr/bin/env bash

. "$HOME/.local/bin/update-env.sh"
if [[ "$OSTYPE" == "darwin"* ]]; then
    . "$HOME/.local/bin/update-mac.sh"
else
    . "$HOME/.local/bin/update-linux.sh"
fi
. "$HOME/.local/bin/update-repositories.sh"
