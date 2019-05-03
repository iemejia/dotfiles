#!/bin/sh
set -x
git -C ~/upstream/beam fetch --all
git -C ~/upstream/avro update-ref refs/heads/master refs/remotes/origin/master
git -C ~/upstream/beam update-ref refs/heads/beam-master refs/remotes/origin/master
git -C ~/upstream/avro fetch --all
git -C ~/upstream/avro update-ref refs/heads/master refs/remotes/origin/master
git -C ~/upstream/avro update-ref refs/heads/avro-master refs/remotes/origin/master
