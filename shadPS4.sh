#!/bin/sh

SCRIPT_DIR=$(dirname $(realpath $0))
RELEASE_ID_PATH=${SCRIPT_DIR}/release_id
DOWNLOADED_FILE_PATH=${SCRIPT_DIR}/Shadps4-qt.AppImage
EXECUTABLE_PATH=${DOWNLOADED_FILE_PATH}
ARCHIVE_FILENAME_PATTERN="^shadps4-linux-qt-.*.zip$"
ARCHIVE_EXTRACT_CMD="unzip -d ${SCRIPT_DIR}"
GITHUB_RELEASE_URI="https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest"

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
        rm -rf ${DOWNLOADED_FILE_PATH}
        ${ARCHIVE_EXTRACT_CMD} ${archive_download_path}
        echo ${latest_release_id} > ${RELEASE_ID_PATH}
        rm -rf ${archive_download_path}
    fi
fi

${EXECUTABLE_PATH} $@
