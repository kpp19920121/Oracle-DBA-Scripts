
set linesize 200;
set pagesize 100;


col TABLESPACE_NAME format  a20;

col CONTENTS format  a10;

col FILE_NAME format  a50;


col FILE_NAME format  a50;


column SIZE   format   a10 ;


column MAX_SIZE   format   a10;

column AUTOEXTENSIBLE   format   a14;


select t1.TABLESPACE_NAME,
       t1.CONTENTS,
       case
         when t1.CONTENTS != 'TEMPORARY' then
          t2.FILE_NAME
         else
          t3.FILE_NAME
       end FILE_NAME,
       case
         when t1.CONTENTS != 'TEMPORARY' then
          ROUND(t2.BYTES / (1024 * 1024), 2)
         else
          ROUND(t3.BYTES / (1024 * 1024), 2)
       end || 'M' "SIZE",
       case
         when t1.CONTENTS != 'TEMPORARY' then
          ROUND(t2.MAXBYTES / (1024 * 1024 * 1024), 2)
         else
          ROUND(t3.MAXBYTES / (1024 * 1024 * 1024), 2)
       end || 'G' "MAX_SIZE",
       case
         when t1.CONTENTS != 'TEMPORARY' then
          t2.AUTOEXTENSIBLE
         else
          t3.AUTOEXTENSIBLE
       end AUTOEXTENSIBLE
  from dba_tablespaces t1
  left join dba_data_files t2
    on (t1.TABLESPACE_NAME = t2.TABLESPACE_NAME)
  left join dba_temp_files t3
    on (t1.TABLESPACE_NAME = t3.TABLESPACE_NAME);

