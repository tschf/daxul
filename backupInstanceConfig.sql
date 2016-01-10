set echo off
set verify off
set feedback off
set heading off
set trimspool on
set termout off
set pagesize 0
set serveroutput on

spool &1

begin

    dbms_output.put_line('ACCOUNT_LIFETIME_DAYS=' || apex_instance_admin.get_parameter('ACCOUNT_LIFETIME_DAYS'));
    dbms_output.put_line('ALLOW_DB_MONITOR=' || apex_instance_admin.get_parameter('ALLOW_DB_MONITOR'));
    dbms_output.put_line('ALLOW_HOSTNAMES=' || apex_instance_admin.get_parameter('ALLOW_HOSTNAMES'));
    dbms_output.put_line('ALLOW_PUBLIC_FILE_UPLOAD=' || apex_instance_admin.get_parameter('ALLOW_PUBLIC_FILE_UPLOAD'));
    dbms_output.put_line('ALLOW_RAS=' || apex_instance_admin.get_parameter('ALLOW_RAS'));
    dbms_output.put_line('ALLOW_REST=' || apex_instance_admin.get_parameter('ALLOW_REST'));
    dbms_output.put_line('APEX_BUILDER_AUTHENTICATION=' || apex_instance_admin.get_parameter('APEX_BUILDER_AUTHENTICATION'));
    dbms_output.put_line('APEX_REST_PATH_PREFIX=' || apex_instance_admin.get_parameter('APEX_REST_PATH_PREFIX'));
    dbms_output.put_line('APPLICATION_ACTIVITY_LOGGING=' || apex_instance_admin.get_parameter('APPLICATION_ACTIVITY_LOGGING'));
    dbms_output.put_line('APPLICATION_ID_MAX=' || apex_instance_admin.get_parameter('APPLICATION_ID_MAX'));
    dbms_output.put_line('APPLICATION_ID_MIN=' || apex_instance_admin.get_parameter('APPLICATION_ID_MIN'));
    dbms_output.put_line('AUTOEXTEND_TABLESPACES=' || apex_instance_admin.get_parameter('AUTOEXTEND_TABLESPACES'));
    dbms_output.put_line('BIGFILE_TABLESPACES_ENABLED=' || apex_instance_admin.get_parameter('BIGFILE_TABLESPACES_ENABLED'));
    dbms_output.put_line('CHECKSUM_HASH_FUNCTION=' || apex_instance_admin.get_parameter('CHECKSUM_HASH_FUNCTION'));
    dbms_output.put_line('CHECK_FOR_UPDATES=' || apex_instance_admin.get_parameter('CHECK_FOR_UPDATES'));
    dbms_output.put_line('DELETE_UPLOADED_FILES_AFTER_DAYS=' || apex_instance_admin.get_parameter('DELETE_UPLOADED_FILES_AFTER_DAYS'));
    dbms_output.put_line('DISABLE_ADMIN_LOGIN=' || apex_instance_admin.get_parameter('DISABLE_ADMIN_LOGIN'));
    dbms_output.put_line('DISABLE_WORKSPACE_LOGIN=' || apex_instance_admin.get_parameter('DISABLE_WORKSPACE_LOGIN'));
    dbms_output.put_line('DISABLE_WS_PROV=' || apex_instance_admin.get_parameter('DISABLE_WS_PROV'));
    dbms_output.put_line('EMAIL_IMAGES_URL=' || apex_instance_admin.get_parameter('EMAIL_IMAGES_URL'));
    dbms_output.put_line('EMAIL_INSTANCE_URL=' || apex_instance_admin.get_parameter('EMAIL_INSTANCE_URL'));
    dbms_output.put_line('ENABLE_TRANSACTIONAL_SQL=' || apex_instance_admin.get_parameter('ENABLE_TRANSACTIONAL_SQL'));
    dbms_output.put_line('ENCRYPTED_TABLESPACES_ENABLED=' || apex_instance_admin.get_parameter('ENCRYPTED_TABLESPACES_ENABLED'));
    dbms_output.put_line('EXPIRE_FIND_USER_ACCOUNTS=' || apex_instance_admin.get_parameter('EXPIRE_FIND_USER_ACCOUNTS'));
    dbms_output.put_line('HTTP_ERROR_STATUS_ON_ERROR_PAGE_ENABLED=' || apex_instance_admin.get_parameter('HTTP_ERROR_STATUS_ON_ERROR_PAGE_ENABLED'));
    dbms_output.put_line('HTTP_RESPONSE_HEADERS=' || apex_instance_admin.get_parameter('HTTP_RESPONSE_HEADERS'));
    dbms_output.put_line('HTTP_STS_MAX_AGE=' || apex_instance_admin.get_parameter('HTTP_STS_MAX_AGE'));
    dbms_output.put_line('INBOUND_PROXIES=' || apex_instance_admin.get_parameter('INBOUND_PROXIES'));
    dbms_output.put_line('LOGIN_THROTTLE_DELAY=' || apex_instance_admin.get_parameter('LOGIN_THROTTLE_DELAY'));
    dbms_output.put_line('LOGIN_THROTTLE_METHODS=' || apex_instance_admin.get_parameter('LOGIN_THROTTLE_METHODS'));
    dbms_output.put_line('MAX_SESSION_IDLE_SEC=' || apex_instance_admin.get_parameter('MAX_SESSION_IDLE_SEC'));
    dbms_output.put_line('MAX_SESSION_IDLE_SEC=' || apex_instance_admin.get_parameter('MAX_SESSION_IDLE_SEC'));
    dbms_output.put_line('MAX_SESSION_LENGTH_SEC=' || apex_instance_admin.get_parameter('MAX_SESSION_LENGTH_SEC'));
    dbms_output.put_line('MAX_SESSION_LENGTH_SEC=' || apex_instance_admin.get_parameter('MAX_SESSION_LENGTH_SEC'));
    dbms_output.put_line('PASSWORD_ALPHA_CHARACTERS=' || apex_instance_admin.get_parameter('PASSWORD_ALPHA_CHARACTERS'));
    dbms_output.put_line('PASSWORD_HASH_FUNCTION=' || apex_instance_admin.get_parameter('PASSWORD_HASH_FUNCTION'));
    dbms_output.put_line('PASSWORD_HASH_ITERATIONS=' || apex_instance_admin.get_parameter('PASSWORD_HASH_ITERATIONS'));
    dbms_output.put_line('PASSWORD_HISTORY_DAYS=' || apex_instance_admin.get_parameter('PASSWORD_HISTORY_DAYS'));
    dbms_output.put_line('PASSWORD_PUNCTUATION_CHARACTERS=' || apex_instance_admin.get_parameter('PASSWORD_PUNCTUATION_CHARACTERS'));
    dbms_output.put_line('PLSQL_EDITING=' || apex_instance_admin.get_parameter('PLSQL_EDITING'));
    dbms_output.put_line('PRINT_BIB_LICENSED=' || apex_instance_admin.get_parameter('PRINT_BIB_LICENSED'));
    dbms_output.put_line('PRINT_SVR_HOST=' || apex_instance_admin.get_parameter('PRINT_SVR_HOST'));
    dbms_output.put_line('PRINT_SVR_PORT=' || apex_instance_admin.get_parameter('PRINT_SVR_PORT'));
    dbms_output.put_line('PRINT_SVR_PROTOCOL=' || apex_instance_admin.get_parameter('PRINT_SVR_PROTOCOL'));
    dbms_output.put_line('PRINT_SVR_SCRIPT=' || apex_instance_admin.get_parameter('PRINT_SVR_SCRIPT'));
    dbms_output.put_line('QOS_MAX_SESSION_KILL_TIMEOUT=' || apex_instance_admin.get_parameter('QOS_MAX_SESSION_KILL_TIMEOUT'));
    dbms_output.put_line('QOS_MAX_SESSION_REQUESTS=' || apex_instance_admin.get_parameter('QOS_MAX_SESSION_REQUESTS'));
    dbms_output.put_line('QOS_MAX_WORKSPACE_REQUESTS=' || apex_instance_admin.get_parameter('QOS_MAX_WORKSPACE_REQUESTS'));
    dbms_output.put_line('REQ_NEW_SCHEMA=' || apex_instance_admin.get_parameter('REQ_NEW_SCHEMA'));
    dbms_output.put_line('REQUIRE_HTTPS=' || apex_instance_admin.get_parameter('REQUIRE_HTTPS'));
    dbms_output.put_line('REQUIRE_VERIFICATION_CODE=' || apex_instance_admin.get_parameter('REQUIRE_VERIFICATION_CODE'));
    dbms_output.put_line('RESTFUL_SERVICES_ENABLED=' || apex_instance_admin.get_parameter('RESTFUL_SERVICES_ENABLED'));
    dbms_output.put_line('RM_CONSUMER_GROUP=' || apex_instance_admin.get_parameter('RM_CONSUMER_GROUP'));
    dbms_output.put_line('SERVICE_REQUEST_FLOW=' || apex_instance_admin.get_parameter('SERVICE_REQUEST_FLOW'));
    dbms_output.put_line('SERVICE_REQUESTS_ENABLED=' || apex_instance_admin.get_parameter('SERVICE_REQUESTS_ENABLED'));
    dbms_output.put_line('SMTP_FROM=' || apex_instance_admin.get_parameter('SMTP_FROM'));
    dbms_output.put_line('SMTP_HOST_ADDRESS=' || apex_instance_admin.get_parameter('SMTP_HOST_ADDRESS'));
    dbms_output.put_line('SMTP_HOST_PORT=' || apex_instance_admin.get_parameter('SMTP_HOST_PORT'));
    dbms_output.put_line('SMTP_PASSWORD=' || apex_instance_admin.get_parameter('SMTP_PASSWORD'));
    dbms_output.put_line('SMTP_TLS_MODE=' || apex_instance_admin.get_parameter('SMTP_TLS_MODE'));
    dbms_output.put_line('SMTP_USERNAME=' || apex_instance_admin.get_parameter('SMTP_USERNAME'));
    dbms_output.put_line('SQL_SCRIPT_MAX_OUTPUT_SIZE=' || apex_instance_admin.get_parameter('SQL_SCRIPT_MAX_OUTPUT_SIZE'));
    dbms_output.put_line('STRONG_SITE_ADMIN_PASSWORD=' || apex_instance_admin.get_parameter('STRONG_SITE_ADMIN_PASSWORD'));
    dbms_output.put_line('SYSTEM_HELP_URL=' || apex_instance_admin.get_parameter('SYSTEM_HELP_URL'));
    dbms_output.put_line('TRACING_ENABLED=' || apex_instance_admin.get_parameter('TRACING_ENABLED'));
    dbms_output.put_line('USERNAME_VALIDATION=' || apex_instance_admin.get_parameter('USERNAME_VALIDATION'));
    dbms_output.put_line('WALLET_PATH=' || apex_instance_admin.get_parameter('WALLET_PATH'));
    dbms_output.put_line('WALLET_PWD=' || apex_instance_admin.get_parameter('WALLET_PWD'));
    dbms_output.put_line('WEBSHEET_SQL_ACCESS=' || apex_instance_admin.get_parameter('WEBSHEET_SQL_ACCESS'));
    dbms_output.put_line('WORKSPACE_EMAIL_MAXIMUM=' || apex_instance_admin.get_parameter('WORKSPACE_EMAIL_MAXIMUM'));
    dbms_output.put_line('WORKSPACE_MAX_FILE_BYTES=' || apex_instance_admin.get_parameter('WORKSPACE_MAX_FILE_BYTES'));
    dbms_output.put_line('WORKSPACE_MAX_OUTPUT_SIZE=' || apex_instance_admin.get_parameter('WORKSPACE_MAX_OUTPUT_SIZE'));
    dbms_output.put_line('WORKSPACE_PROVISION_DEMO_OBJECTS=' || apex_instance_admin.get_parameter('WORKSPACE_PROVISION_DEMO_OBJECTS'));
    dbms_output.put_line('WORKSPACE_WEBSHEET_OBJECTS=' || apex_instance_admin.get_parameter('WORKSPACE_WEBSHEET_OBJECTS'));

end;
/

spool off
exit
