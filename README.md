# bauler - alternate upgrade for APEX 

The problem?

APEX is a free product. Oracle XE is a free product. Oracle XE editions are never patched, but APEX is. If you only deal with XE, it becomes very difficult to upgrade because APEX because Oracle only provides patch sets to paying customers. The full installation media you can download from the website doesn't include an upgrade path - only the full installation of the APEX schema, so it will not succeed.

So if you want to upgrade, you other need to get your hands on the patch sets, or drop the APEX schema and install afresh.

The solution?

APEX installation files come with a utility to generate exports for both workspaces and applications. This is located in: `apex/utilities/oracle/apex/` and is a Java program. To initiate it you first need to set the classpath like so:

```bash
export CLASSPATH=.:${ORACLE_HOME}/jdbc/lib/ojdbc5.jar:${ORACLE_HOME}/apex/utilities/
#Assuming apex was extracted to ORACLE_HOME
```

Then, you can initiate the backup of workspaces for example with:

```bash
java oracle.apex.APEXExport -db localhost:1521:XE -user system -password oracle -expWorkspace
```
