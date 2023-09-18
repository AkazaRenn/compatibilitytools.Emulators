#!/bin/bash

YUZU_DIR=$(dirname $(realpath $0))/Yuzu
YUZU_FILE_NAME_PATTERN="^Linux-Yuzu-.*AppImage$"
GH_DL_LINK="https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest"

latest_yuzu_info=`curl -s ${GH_DL_LINK} | jq -r '.assets[] | select(.name | test('\"${YUZU_FILE_NAME_PATTERN}\"'))'`
if [ "${latest_yuzu_info}" != "" ]; then
    mkdir -p ${YUZU_DIR}
    pushd ${YUZU_DIR} > /dev/null
    curr_file_name=$(ls | grep -o ${YUZU_FILE_NAME_PATTERN})
    new_file_name=`echo ${latest_yuzu_info} | jq -r '.name'`
    
    if [[ ${new_file_name} > ${curr_file_name} ]]; then
        echo ${latest_yuzu_info} | jq -r '.browser_download_url' | wget -qO ${new_file_name} -i -
        find . * -maxdepth 1 -regextype sed -regex ${YUZU_FILE_NAME_PATTERN} ! -name ${new_file_name} -type f -delete
        chmod +x ${new_file_name}
        curr_file_name=${new_file_name}
    fi

    popd > /dev/null
fi

${YUZU_DIR}/${curr_file_name} $@ > /dev/null
