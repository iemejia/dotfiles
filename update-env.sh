#!/usr/bin/env bash
set -x

git -C ~/.oh-my-zsh pull

# Update vim native packages
for d in ~/.vim/pack/plugins/start/*; do
    [ -d "$d/.git" ] || continue
    echo "$d"
    git -C "$d" pull
done

# Update virtualenvs (if using virtualenvwrapper)
if [ -d "$HOME/.virtualenvs" ]; then
    for d in ~/.virtualenvs/*/; do
        [ -f "$d/bin/activate" ] || continue
        . "$d/bin/activate"
        pip install --upgrade pip setuptools wheel
        deactivate
    done
fi
