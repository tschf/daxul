#!/bin/bash
# upgrade.sh
# Program to upgrade the APEX schema in the database. This is useful when
# access to the patchsets is not available (when you're not a paying Oracle
# customer).
#
# Relies on the apex installation files which comes with a java program to export
# the required workspace/app export files; Also, a library in the Oracle
# installation files, so ORACLE_HOME is expected to be set.
#
# Basically, the goal is to export all workspaces and applications; drop the apex
# schema and re run in the apex installation. Future goal, handle instance config

# Define exit codes
INVALID_ARGS=1
ORACLE_UNDEFINED=2
PROGRAM_UNDEFINED=3
OJDBC_UNDEFINED=4

# Arguments
EXPECTED_ARGS=6

APEX_PATH=$1
DB_HOST=$2
DB_PORT=$3
DB_SID=$4
DB_USER=$5
DB_PASS=$6

OJDBC_PATH=lib/ojdbc5.jar
BACKUP_PROG_BASE_DIR=${APEX_PATH}/utilities
BACKUP_PROG_FULL_PATH=${BACKUP_PROG_BASE_DIR}/oracle/apex/APEXExport.class

print_usage(){
    echo "upgrade.sh /path/to/apex/install/files host port sid user password"
}

print_debug(){
    echo "HOST: ${DB_HOST}"
    echo "PORT: ${DB_PORT}"
    echo "SID: ${DB_SID}"
    echo "USER: ${DB_USER}"
    echo "PASSWORD: ${DB_PASS}"
    echo "CLASSPATH: ${CLASSPATH}"
}

# Make sure the correct number of arguments were received
if [[ $# -ne ${EXPECTED_ARGS} ]]; then
    echo "Wrong number of args; Received $#; Expected ${EXPECTED_ARGS}" >&2
    print_usage
    exit ${INVALID_ARGS}
fi

# Make sure ORACLE_HOME points to a valid path
if [[ ! -e ${ORACLE_HOME} ]]; then
    echo "ORACLE_HOME is not set or points to an invalid path on this sytem. Can not continue" >&2
    exit ${ORACLE_UNDEFINED}
fi

# The program requires Oracle JDBC drivers in the classpath. Based on my two
# example cases of Oracle installations (the XE server and my workstation)
# it seems there are two possible locations:
#
# 1. $ORACLE_HOME/jdbc/lib/ojdbc5.jar
# 2. $ORACLE_HOME/lib/ojdbc.jar
#
# By default set it to 1, but if that doesn't exist, try pointing it to 2.
if [[ -e ${ORACLE_HOME}/jdbc/${OJDBC_PATH} ]]; then
    OJDBC_PATH=${ORACLE_HOME}/jdbc/${OJDBC_PATH}
elif [[ -e ${ORACLE_HOME}/${OJDBC_PATH} ]]; then
    OJDBC_PATH=${ORACLE_HOME}/${OJDBC_PATH}
else
    echo "Could not find ojdbc5.jar. Is Oracle properly installed?" >&2
    exit ${OJDBC_UNDEFINED}
fi

# The apex path was found, but let us double check the java program is there
if [[ ! -e ${BACKUP_PROG_FULL_PATH} ]]; then
    echo "Could not find the backup program at path ${BACKUP_PROG_FULL_PATH}" >&2
    exit ${PROGRAM_UNDEFINED}
fi


# Error checking all done, now we need to set the classpath so it can be run
export CLASSPATH=${CLASSPATH}:${OJDBC_PATH}:${BACKUP_PROG_BASE_DIR}

#print_debug

java oracle.apex.APEXExport -db ${DB_HOST}:${DB_PORT}:${DB_SID} -user ${DB_USER} -password ${DB_PASS} -expWorkspace
