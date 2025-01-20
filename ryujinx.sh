#!/bin/sh

SCRIPT_DIR=$(dirname $(realpath $0))
RELEASE_ID_PATH=${SCRIPT_DIR}/release_id
GAME_FILE_PATH=${SCRIPT_DIR}/publish
EXECUTABLE_PATH=${GAME_FILE_PATH}/Ryujinx.sh
ARCHIVE_FILENAME_PATTERN="^ryujinx-.*-linux_x64.tar.gz$"
ARCHIVE_EXTRACT_CMD="tar -xf"
GITHUB_RELEASE_URI="https://api.github.com/repos/Ryubing/Ryujinx/releases/latest"

latest_release=`curl -s ${GITHUB_RELEASE_URI} | jq -r '.assets[] | select(.name | test('\"${ARCHIVE_FILENAME_PATTERN}\"'))'`
latest_release_id=`echo ${latest_release} | jq -r .id`
if [ "${latest_release}" != "" ]; then
    if [ -f "${RELEASE_ID_PATH}" ]; then
        current_release_id=$(cat ${RELEASE_ID_PATH})
    else
        current_release_id=""
    fi
    if [[ ${latest_release_id} != ${current_release_id} ]] || [[ ! -f ${EXECUTABLE_PATH} ]]; then
        archive_download_path=${SCRIPT_DIR}/download.temp
        echo ${latest_release} | jq -r '.browser_download_url' | wget -qO ${archive_download_path} -i -
        rm -rf ${GAME_FILE_PATH}
        ${ARCHIVE_EXTRACT_CMD} ${archive_download_path}
        echo ${latest_release_id} > ${RELEASE_ID_PATH}
        rm -rf ${archive_download_path}
    fi
fi

${EXECUTABLE_PATH} $@
