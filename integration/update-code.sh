#!/usr/bin/env bash

if [[ "$OSTYPE" == "msys" ]]; then
  PLUGIN_PATH="../protoc-gen-kobalt_ts_proto.bat"
else
  PLUGIN_PATH="../protoc-gen-kobalt_ts_proto"
fi

if [[ $# -eq 0 ]]; then
  TESTS=$(find . -mindepth 1 -maxdepth 1 -type d)
else
  TESTS=$@
fi

for TEST in $TESTS; do
  echo "Test ${TEST}"
  cd "${TEST}"

  PARAMETERS_FILE="parameters.txt"
  if [ -f "$PARAMETERS_FILE" ]; then
    PARAMETERS=$(cat "$PARAMETERS_FILE")
  else
    PARAMETERS=""
  fi

  PROTO_FILES=$(find . -name '*.proto' -type f)
  NODE_OPTIONS="--import tsx" protoc --experimental_allow_proto3_optional \
    "--plugin=$PLUGIN_PATH" \
    --kobalt_ts_proto_opt="annotateFilesWithVersion=false,${PARAMETERS}" \
    --kobalt_ts_proto_out=./ \
    $PROTO_FILES

  echo ""
  echo ""

  cd ..
done
