#!/bin/bash

YUZU_DIR=$(dirname $(realpath $0))
pushd $YUZU_DIR > /dev/null

YUZU_FILE_NAME_PREFIX="Linux-Yuzu"
CURR_FILE_NAME=$(ls | grep ${YUZU_FILE_NAME_PREFIX})

GH_DL_LINK="https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest"
LATEST_YUZU_INFO=`curl -s ${GH_DL_LINK} | jq -r '.assets[] | select(.name | startswith('\"${YUZU_FILE_NAME_PREFIX}\"'))'`

if [ "${LATEST_YUZU_INFO}" != "" ]; then
    NEW_FILE_NAME=`echo ${LATEST_YUZU_INFO} | jq -r '.name'`
    if [[ ${NEW_FILE_NAME} > ${CURR_FILE_NAME} ]]; then
        echo ${LATEST_YUZU_INFO} | jq -r '.browser_download_url' | wget -qO ${NEW_FILE_NAME} -i -
        find -maxdepth 1 -name "${YUZU_FILE_NAME_PREFIX}*" ! -name ${NEW_FILE_NAME} -type f -delete
        chmod +x ${NEW_FILE_NAME}

        CURR_FILE_NAME=${NEW_FILE_NAME}
    fi
fi

popd > /dev/null
${YUZU_DIR}/${CURR_FILE_NAME} $@ > /de
v/null
