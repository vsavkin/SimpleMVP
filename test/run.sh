#!/bin/bash -e

PATH=$HOME/local/dart/chromium:$PATH
results=$(DumpRenderTree test/run.html 2>&1)

echo -e "$results"

echo "$results" | grep CONSOLE

echo $results | grep -v 'Exception: Some tests failed.' >/dev/null
