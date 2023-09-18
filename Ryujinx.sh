#!/bin/bash

RYU_DIR=$(dirname $(realpath $0))/Ryujinx
RYU_FILE_NAME_PATTERN="ava-ryujinx-.*-linux_x64.tar.gz$"
GH_DL_LINK="https://api.github.com/repos/Ryujinx/release-channel-master/releases/latest"

latest_ryu_info=`curl -s ${GH_DL_LINK} | jq -r '.assets[] | select(.name | test('\"${RYU_FILE_NAME_PATTERN}\"'))'`
if [ "${latest_ryu_info}" != "" ]; then
    mkdir -p ${RYU_DIR}
    pushd ${RYU_DIR} > /dev/null
    curr_file_name=$(ls | grep -o ${RYU_FILE_NAME_PATTERN})
    new_file_name=`echo ${latest_ryu_info} | jq -r '.name'`

    if [[ ${new_file_name} > ${curr_file_name} ]]; then
        echo ${latest_ryu_info} | jq -r '.browser_download_url' | wget -qO ${new_file_name} -i -
        find . * -maxdepth 1 -regextype sed -regex ${RYU_FILE_NAME_PATTERN} ! -name ${new_file_name} -type f -delete
        rm -rf publish
        tar -xf ${new_file_name}
    fi

    popd > /dev/null
fi

${RYU_DIR}/publish/Ryujinx.sh $@ > /dev/null
