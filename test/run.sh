#!/bin/bash -e

results=$(DumpRenderTree test/run.html)
echo -e "$results"

if [[ "$results" == *"Some tests failed"* ]]
then
  exit 1
fi

exit 0