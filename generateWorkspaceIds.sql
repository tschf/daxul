set echo off
set verify off
set feedback off
set heading off
set trimspool on
set termout off
set pagesize 0

spool &1

select to_char(workspace_id)
from apex_workspaces
where source_identifier is not null;

spool off
exit
