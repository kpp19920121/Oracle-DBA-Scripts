# tablespace #

- 创建永久表空间<br>

		create tablespace develop_tablespace 
			datafile '/u01/app/oracle/oradata/orcl/develop1.dbf' size 100M 
			autoextend on 
			next 100M 
			maxsize unlimited  
			extent management local;

- 创建临时表空间

		create temporary tablespace develop_tablespace_temp 
		       tempfile '/u01/app/oracle/oradata/orcl/develop_temp1.dbf' size 100M
		       autoextend on next 100M maxsize unlimited extent management local;

# schema #

- 创建用户

		create user developerUser identified by developerUser 
			default tablespace itreasury  
			temporary tablespace itreasury_temp;

- 锁定用户

		alter user developerUser account  lock;

- 解锁用户

		alter user developerUser account  unlock;

- 修改用户密码

		alter user developerUser  identified by icip_user;

# 导出库/导入库 #

- 导出整个用户

		expdp developerUser/developerUser directory=DATA_PUMP_DIR dumpfile=developerUser.dmp    EXCLUDE=STATISTICS
		注：DATA_PUMP_DIR可查询select   * from dba_directories；获取
- 单时间段导出

		expdp developerUser/developerUser directory=DATA_PUMP_DIR dumpfile=test_messagelog.dmp TABLES=developerUser.test_messagelog     QUERY=developerUser.test_messagelog:\"WHERE to_char\(dtmessagedatetime,\'yyyy-MM-dd\'\) \>= \'2016-12-01\' \"   EXCLUDE=STATISTICS


- 导入整个用户

		expdp developerUser/developerUser directory=DATA_PUMP_DIR dumpfile=developerUser.dmp EXCLUDE=STATISTICS

- 导入用户忽略指定用户和指定表


		impdp developerUser/developerUser directory=DATA_PUMP_DIR dumpfile=developerUser.dmp exclude=SCHEMA:\" IN \(\'procuctUserDp\'\)\" exclude=TABLE:\" IN \(\'test_SYSTEMLOG\'\)\" REMAP_SCHEMA=procuctUser:developerUser

- 单时间段导入

		impdp developerUser/developerUser PARALLEL=1 remap_schema=developerUser:developerUser directory=DATA_PUMP_DIR dumpfile=developerUser.dmp TABLES=developerUser.test_messagelog     QUERY=developerUser.test_messagelog:\"WHERE to_char\(dtmessagedatetime,\'yyyy-MM-dd\'\) \>= \'2016-12-01\' \"   TABLE_EXISTS_ACTION=APPEND

- imp导入（不建议使用）

		imp developerUser/developerUser file=/upload/developerUser.dmp log=import.log fromuser=developerUser touser=productUser ignore=y
		


# 附件 #

## 批量编译视图 ##

登录sqlplus，执行sql语句:

	SPOOL   /upload/compile.sql
		SET HEADING OFF
		select 'alter view ' || tt.OWNER || '.' || tt.VIEW_NAME || ' COMPILE;'    from dba_views tt where tt.OWNER = 'CNMEFDP';
	SPOOL OFF

退出sqlplus执行:

	sqlplus / as sysdba  @/upload/compile.sql
