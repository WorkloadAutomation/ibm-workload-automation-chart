#!/bin/sh
####################################################################
# Licensed Materials Property of HCL*
# (c) Copyright HCL Technologies Ltd. 2021. All rights reserved.
#
# * Trademark of HCL Technologies Limited
####################################################################
copyCustomPlugins(){
    SOURCE_PLUGINS_DIR=$1
    REMOTE_PLUGINS_DIR=$2
    echo "I: Starting copy of custom plugins...." 
    if [ -d "${SOURCE_PLUGINS_DIR}" ] && [ -d "${REMOTE_PLUGINS_DIR}" ];then
        echo "I: Copying custom plugins...." 
        cp --verbose -R ${SOURCE_PLUGINS_DIR} ${REMOTE_PLUGINS_DIR}
    fi
}
###############
#MAIN
###############
copyCustomPlugins $1 $2