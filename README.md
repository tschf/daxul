# daxul - upgrade for APEX patch on XE

daxul is a utility to upgrade APEX on an XE database. The reason this is needed is that Oracle provides patch sets for APEX but only for paying customers. Seeing as though both Oracle XE and APEX are free, it makes sense you would need a method to upgrade to the latest version (which is currently difficult without the patch sets).

A way around this is to backup all workspaces, remove APEX and then re-install everything.

The backup functionality is provided through way of a Java program provided within the APEX installation files. Assuming you unzipped APEX installation files to `$ORACLE_HOME/apex`, you can initiate a workspace export with:

```
export CLASSPATH=.:${ORACLE_HOME}/jdbc/lib/ojdbc5.jar:${ORACLE_HOME}/apex/utilities/
java oracle.apex.APEXExport -db localhost:1521:XE -user system -password oracle -expWorkspace
```

It is worth reading the full documentation to see what options are available, which can be found at: `$ORACLE_HOME/apex/utilities/readme.txt`

This should only be used for minor updates - major updates should be installed with a full installation.

Usage:

```
sudo -E ./daxul.sh -a /u01/app/oracle/product/11.2.0/xe/apex -h localhost -p 1521 -s xe -su system -sp oracle -du sys -dp oracle -i /ords/apex_images/
```

Current caveats:

* This should be run from the server apex is installed on - so that images can be updated
* Users against the internal workspace will be lost
* not all instance configuration not backed up/restored
