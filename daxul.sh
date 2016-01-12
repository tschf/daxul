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
USER_EXIT=5

# Arguments
EXPECTED_ARGS=6

# Database parameters
APEX_PATH=$1
DB_HOST=$2
DB_PORT=$3
DB_SID=$4
DB_USER=$5
DB_PASS=$6

# Backup program paths/dependencies
OJDBC_PATH=lib/ojdbc5.jar
BACKUP_PROG_BASE_DIR=${APEX_PATH}/utilities
BACKUP_PROG_FULL_PATH=${BACKUP_PROG_BASE_DIR}/oracle/apex/APEXExport.class

# Get dir of this script so we can reference other scripts.
# Idea taken from: http://stackoverflow.com/a/246128/3476713
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WORKSPACE_ID_SCRIPT=${SCRIPT_DIR}/generateWorkspaceIds.sql
WORKSPACE_ID_FILE=$(mktemp)
WORKSPACE_BACKUP_DIR=$(mktemp -d)
INSTANCE_CONFIG_BACKUP_SCRIPT=${SCRIPT_DIR}/backupInstanceConfig.sql
PRE_INSTANCE_CONFIG_FILE=$(mktemp)
POST_INSTANCE_CONFIG_FILE=$(mktemp)
RESTORE_SCRIPT=$(mktemp)

RUN_AND_EXIT_SCRIPT=${SCRIPT_DIR}/runAndExit.sql

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
export CLASSPATH=${OJDBC_PATH}:${BACKUP_PROG_BASE_DIR}

#print_debug

# Output all workspace id's to a text file
sqlplus ${DB_USER}/${DB_PASS}@//${DB_HOST}:${DB_PORT}/${DB_SID} @${WORKSPACE_ID_SCRIPT} ${WORKSPACE_ID_FILE}
# Backup instance config for later restoration
sqlplus ${DB_USER}/${DB_PASS}@//${DB_HOST}:${DB_PORT}/${DB_SID} @${INSTANCE_CONFIG_BACKUP_SCRIPT} ${PRE_INSTANCE_CONFIG_FILE}

TOTAL_APP_COUNT=0
while read WID; do
    echo "Workspace ID: ${WID}"
    mkdir ${WORKSPACE_BACKUP_DIR}/${WID}
    cd ${WORKSPACE_BACKUP_DIR}/${WID}
    java oracle.apex.APEXExport -db ${DB_HOST}:${DB_PORT}:${DB_SID} -user ${DB_USER} -password ${DB_PASS} -expWorkspace -workspaceid ${WID}
    java oracle.apex.APEXExport -db ${DB_HOST}:${DB_PORT}:${DB_SID} -user ${DB_USER} -password ${DB_PASS} -workspaceid ${WID}

    NUM_APPS=$(ls -l ${WORKSPACE_BACKUP_DIR}/${WID} | wc -l)
    TOTAL_APP_COUNT=$(($TOTAL_APP_COUNT+$NUM_APPS))

done < ${WORKSPACE_ID_FILE}
echo "Uninstalling"
NUM_WORKSPACES=$(ls -l ${WORKSPACE_BACKUP_DIR} | wc -l)
echo "A total of ${NUM_WORKSPACES} workspaces were backed up, and ${TOTAL_APP_COUNT} applications".
echo "You can view the backed up workspaces/applications at: ${WORKSPACE_BACKUP_DIR}"
echo "You can view the backed up instance config at: ${PRE_INSTANCE_CONFIG_FILE}"
echo "If you continue, Application Express will be completely uninstalled and then re-installed"
echo "All users in the internal workspace will not be restored"
echo "You will have to re-do the instance configuration"
read -p "Are you sure you want to continue?: " CONFIRM_CONTINUE

# ^^converts it to uppercase. Idea grabbed from: http://stackoverflow.com/a/2265268/3476713
if [[ ! "${CONFIRM_CONTINUE^^}" = "Y" ]] && [[ ! "${CONFIRM_CONTINUE^^}" = "YES" ]]; then
    exit ${USER_EXIT}
fi

sqlplus sys/oracle@//${DB_HOST}:${DB_PORT}/${DB_SID} as sysdba @${RUN_AND_EXIT_SCRIPT} ${APEX_PATH}/apxremov.sql
echo "Uninstalling complete"

echo "Installing"
# Need to change into the directory where the scripts are, since the installation
# script is referencing other scripts - but expecting them in the same current
# working directory.
cd ${APEX_PATH}
sqlplus sys/oracle@//${DB_HOST}:${DB_PORT}/${DB_SID} as sysdba @${APEX_PATH}/apexins.sql SYSAUX SYSAUX TEMP /i/

#copy images

#echo "Installing complete"

# Restore workspaces and applications
while read WID; do
    sqlplus ${DB_USER}/${DB_PASS}@//${DB_HOST}:${DB_PORT}/${DB_SID} @${RUN_AND_EXIT_SCRIPT} ${WORKSPACE_BACKUP_DIR}/${WID}/w${WID}.sql

    for apexApp in ${WORKSPACE_BACKUP_DIR}/${WID}/f*.sql; do
        echo "Installing ${apexApp}"
        sqlplus ${DB_USER}/${DB_PASS}@//${DB_HOST}:${DB_PORT}/${DB_SID} @${RUN_AND_EXIT_SCRIPT} ${apexApp}
    done
done < ${WORKSPACE_ID_FILE}

echo "Restoring instance configuration"

echo "begin" > ${RESTORE_SCRIPT}

while read BACKED_PROPERTY; do

    IFS='=' read -r -a INSTANCE_PARAM <<< ${BACKED_PROPERTY}
    # If value isn't empty, append update call to the script
    if [[ ! -z ${INSTANCE_PARAM[1]//} ]]; then
        echo "APEX_INSTANCE_ADMIN.SET_PARAMETER('${INSTANCE_PARAM[0]}', '${INSTANCE_PARAM[1]}');" >> ${RESTORE_SCRIPT}
    fi

done < ${PRE_INSTANCE_CONFIG_FILE}

echo "end;" >> ${RESTORE_SCRIPT}
echo "/" >> ${RESTORE_SCRIPT}

echo "exit" >> ${RESTORE_SCRIPT}

# Before updating, get the current config
sqlplus ${DB_USER}/${DB_PASS}@//${DB_HOST}:${DB_PORT}/${DB_SID} @${INSTANCE_CONFIG_BACKUP_SCRIPT} ${POST_INSTANCE_CONFIG_FILE}

# Now, restore settings as they were before the upgrade
sqlplus ${DB_USER}/${DB_PASS}@//${DB_HOST}:${DB_PORT}/${DB_SID} @${RESTORE_SCRIPT}

echo "Restoration complete, script saved to ${RESTORE_SCRIPT}."
echo "You can review the instance config files at:"
echo "- Your existing settings before the upgrade: ${PRE_INSTANCE_CONFIG_FILE}"
echo "- The settings after upgrading APEX and before restoration: ${POST_INSTANCE_CONFIG_FILE}"
