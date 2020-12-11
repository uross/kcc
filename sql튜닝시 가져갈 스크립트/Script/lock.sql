SELECT /*+ RULE */
       DECODE(l.request, 0, '+Holder:', ' ->Waiter:') lock_info,
       s.sid||','||s.serial# sid,
       p.spid||','||s.process pid,
       s.program,
       DECODE(s.sql_hash_value, 0, s.prev_hash_value, s.sql_hash_value) sql_hash_value,
       DECODE(s.command, 1, 'CreTab',               -- CREATE TABLE
                         2, 'INSERT',               -- INSERT
                         3, 'SELECT',               -- SELECT
                         4, 'CreClu',               -- CREATE CLUSTER
                         5, 'AltClu',               -- ALTER CLUSTER
                         6, 'UPDATE',               -- UPDATE
                         7, 'DELETE',               -- DELETE
                         8, 'DrpClu',               -- DROP CLUSTER
                         9, 'CreIdx',               -- CREATE INDEX
                        10, 'DrpIdx',               -- DROP INDEX
                        11, 'AltIdx',               -- ALTER INDEX
                        12, 'DrpTab',               -- DROP TABLE
                        13, 'CreSeq',               -- CREATE SEQUENCE
                        14, 'AltSeq',               -- ALTER SEQUENCE
                        15, 'AltTab',               -- ALTER TABLE
                        16, 'DrpSeq',               -- DROP SEQUENCE
                        17, 'GrtObj',               -- GRANT OBJECT
                        18, 'RvkObj',               -- REVOKE OBJECT
                        19, 'CreSyn',               -- CREATE SYNONYM
                        20, 'DrpSyn',               -- DROP SYNONYM
                        21, 'CreView',              -- CREATE VIEW
                        22, 'DrpView',              -- DROP VIEW
                        23, 'ValIdx',               -- VALIDATE INDEX
                        24, 'CreProc',              -- CREATE PROCEDURE
                        25, 'AltProc',              -- ALTER PROCEDURE
                        26, 'LOCK',                 -- LOCK
                        27, 'NO-OP',                -- NO-OP
                        28, 'RENAME',               -- RENAME
                        29, 'Commnt',               -- COMMENT
                        30, 'AdtObj',               -- AUDIT OBJECT
                        31, 'NoAdtObj',             -- NOAUDIT OBJECT
                        32, 'CreLink',              -- CREATE DATABASE LINK
                        33, 'DrpLink',              -- DROP DATABASE LINK
                        34, 'CreDB',                -- CREATE DATABASE
                        35, 'AltDB',                -- ALTER DATABASE
                        36, 'CreRS',                -- CREATE ROLLBACK SEG
                        37, 'AltRS',                -- ALTER ROLLBACK SEG
                        38, 'DrpRS',                -- DROP ROLLBACK SEG
                        39, 'CreTbs',               -- CREATE TABLESPACE
                        40, 'AltTbs',               -- ALTER TABLESPACE
                        41, 'DrpTbs',               -- DROP TABLESPACE
                        42, 'AltSess',              -- ALTER SESSION
                        43, 'AltUser',              -- ALTER USER
                        44, 'COMMIT',               -- COMMIT
                        45, 'RollBk',               -- ROLLBACK
                        46, 'SavPoin',              -- SAVEPOINT
                        47, 'PL/SQL',               -- PL/SQL EXECUTE
                        48, 'SetTran',              -- SET TRANSACTION
                        49, 'AltSys',               -- ALTER SYSTEM
                        50, 'EXPLAIN',              -- EXPLAIN
                        51, 'CreUser',              -- CREATE USER
                        52, 'CreRole',              -- CREATE ROLE
                        53, 'DrpUser',              -- DROP USER
                        54, 'DrpRole',              -- DROP ROLE
                        55, 'SetRole',              -- SET ROLE
                        56, 'CREATE SCHEMA',        -- CREATE SCHEMA
                        57, 'CreCtrl',              -- CREATE CONTROL FILE
                        59, 'CreTrig',              -- CREATE TRIGGER
                        60, 'AltTrig',              -- ALTER TRIGGER
                        61, 'DrpTrig',              -- DROP TRIGGER
                        62, 'AnalTab',              -- ANALYZE TABLE
                        63, 'AnalIdx',              -- ANALYZE INDEX
                        64, 'AnalClu',              -- ANALYZE CLUSTER
                        65, 'CreProf',              -- CREATE PROFILE
                        66, 'DrpProf',              -- DROP PROFILE
                        67, 'AltProf',              -- ALTER PROFILE
                        68, 'DrpProc',              -- DROP PROCEDURE
                        70, 'ALTER RESOURCE COST',  -- ALTER RESOURCE COST
                        71, 'CreMVLog',             -- CREATE MATERIALIZED VIEW LOG
                        72, 'AltMVLog',             -- ALTER MATERIALIZED VIEW LOG
                        73, 'DrpMVLog',             -- DROP MATERIALIZED VIEW LOG
                        74, 'CreMV',                -- CREATE MATERIALIZED VIEW
                        75, 'AltMV',                -- ALTER MATERIALIZED VIEW
                        76, 'DrpMV',                -- DROP MATERIALIZED VIEW
                        77, 'CreType',              -- CREATE TYPE
                        78, 'DrpType',              -- DROP TYPE
                        79, 'AltRole',              -- ALTER ROLE
                        80, 'AltType',              -- ALTER TYPE
                        81, 'CreTypeBd',            -- CREATE TYPE BODY
                        82, 'AltTypeBd',            -- ALTER TYPE BODY
                        83, 'DrpTypeBd',            -- DROP TYPE BODY
                        84, 'DrpLib',               -- DROP LIBRARY
                        85, 'TrcTab',               -- TRUNCATE TABLE
                        86, 'TrcClu',               -- TRUNCATE CLUSTER
                        91, 'CreFunc',              -- CREATE FUNCTION
                        92, 'AltFunc',              -- ALTER FUNCTION
                        93, 'DrpFunc',              -- DROP FUNCTION
                        94, 'CrePkg',               -- CREATE PACKAGE
                        95, 'AltPkg',               -- ALTER PACKAGE
                        96, 'DrpPkg',               -- DROP PACKAGE
                        97, 'CrePkgBd',             -- CREATE PACKAGE BODY
                        98, 'AltPkgBd',             -- ALTER PACKAGE BODY
                        99, 'DrpPkgBd',             -- DROP PACKAGE BODY
                       100, 'LOGON',                -- LOGON
                       101, 'LOGOFF',               -- LOGOFF
                       102, 'LOGOFF BY CLEANUP',    -- LOGOFF BY CLEANUP
                       103, 'SESSION REC',          -- SESSION REC
                       104, 'SysAdt',               -- SYSTEM AUDIT
                       105, 'SysNoAdt',             -- SYSTEM NOAUDIT
                       106, 'AdtDef',               -- AUDIT DEFAULT
                       107, 'NoAdtDef',             -- NOAUDIT DEFAULT
                       108, 'SysGrt',               -- SYSTEM GRANT
                       109, 'SysRvk',               -- SYSTEM REVOKE
                       110, 'CrePubSyn',            -- CREATE PUBLIC SYNONYM
                       111, 'DrpPubSyn',            -- DROP PUBLIC SYNONYM
                       112, 'CrePubLink',           -- CREATE PUBLIC DATABASE LINK
                       113, 'DrpPubLink',           -- DROP PUBLIC DATABASE LINK
                       114, 'GrnRole',              -- GRANT ROLE
                       115, 'RvkRole',              -- REVOKE ROLE
                       116, 'ExeProc',              -- EXECUTE PROCEDURE
                       117, 'UserComm',             -- USER COMMENT
                       118, 'EnTrig',               -- ENABLE TRIGGER
                       119, 'DisTrig',              -- DISABLE TRIGGER
                       120, 'EnAllTrig',            -- ENABLE ALL TRIGGERS
                       121, 'DisAllTrig',           -- DISABLE ALL TRIGGERS
                       122, 'NetErr',               -- NETWORK ERROR
                       123, 'ExeType',              -- EXECUTE TYPE
                       157, 'CreDir',               -- CREATE DIRECTORY
                       158, 'DrpDir',               -- DROP DIRECTORY
                       159, 'CreLib',               -- CREATE LIBRARY
                       160, 'CreJava',              -- CREATE JAVA
                       161, 'AltJava',              -- ALTER JAVA
                       162, 'DrpJava',              -- DROP JAVA
                       163, 'CreOper',              -- CREATE OPERATOR
                       164, 'CreIdxType',           -- CREATE INDEXTYPE
                       165, 'DrpIdxType',           -- DROP INDEXTYPE
                       -- 167, 'DrpOper',              -- DROP OPERATOR
                       -- 168, 'ASSOCIATE STATISTICS', -- ASSOCIATE STATISTICS
                       -- 169, 'DISASSOCIATE STATISTICS', -- DISASSOCIATE STATISTICS
                       -- 170, 'CALL METHOD',          -- CALL METHOD
                       -- 171, 'CreSumm',              -- CREATE SUMMARY
                       -- 172, 'AltSumm',              -- ALTER SUMMARY
                       -- 173, 'DrpSumm',              -- DROP SUMMARY
                       -- 174, 'CreDimen',             -- CREATE DIMENSION
                       -- 175, 'AltDimen',             -- ALTER DIMENSION
                       -- 176, 'DrpDimen',             -- DROP DIMENSION
                       -- 177, 'CreContext',           -- CREATE CONTEXT
                       -- 178, 'DrpContext',           -- DROP CONTEXT
                       -- 179, 'AltOutLn',             -- ALTER OUTLINE
                       -- 180, 'CreOutLn',             -- CREATE OUTLINE
                       -- 181, 'DrpOutLn',             -- DROP OUTLINE
                       -- 182, 'UpdIdx',               -- UPDATE INDEXES
                       -- 183, 'AltOper',              -- ALTER OPERATOR
                         command||'-???') COMMAND,
       l.type||'('||DECODE(l.type,
         'BL', 'Buffer hash table instance',
         'CF', 'Control file schema global enqueue',
         'CI', 'Cross-instance function invocation instance',
--       'CS', 'Control file schema global enqueue',
         'CU', 'Cursor bind',
         'DF', 'Data file instance',
         'DL', 'Direct loader parallel index create',
         'DM', 'Mount/startup db primary/secondary instance',
         'DR', 'Distributed recovery process',
         'DX', 'Distributed transaction entry',
--       'FI', 'SGA open-file information',
         'FS', 'File set',
         'HW', 'Space management operations on a specific segment',
         'IN', 'Instance number',
         'IR', 'Instance recovery serialization global enqueue',
         'IS', 'Instance state',
         'IV', 'Library cache invalidation instance',
         'JQ', 'Job queue',
         'KK', 'Thread kick',
         'MM', 'Mount definition gloabal enqueue',
--       'MB', 'Master buffer hash table instance',
         'MR', 'Media recovery',
         'PF', 'Password file',
         'PI', 'Parallel operation',
         'PS', 'Parallel operation',
         'PR', 'Process startup',
--       'RE', 'USE_ROW_ENQUEUE enforcement',
         'RT', 'Redo thread global enqueue',
--       'RW', 'Row wait enqueue',
         'SC', 'System commit number instance',
--       'SH', 'System commit number high water mark enqueue',
         'SM', 'SMON',
         'SN', 'Sequence number instance',
         'SQ', 'Sequence number enqueue',
         'SS', 'Sort segment',
         'ST', 'Space transaction enqueue',
         'SV', 'Sequence number value',
         'TA', 'Generic enqueue',
--       'TD', 'DDL enqueue',
--       'TE', 'Extend-segment enqueue',
         'TM', 'DML enqueue',
         'TT', 'Temporary table enqueue',
         'TX', 'Row Transaction enqueue',
         'UL', 'User supplied',
         'UN', 'User name',
         'US', 'Undo segment DDL',
         'WL', 'Being-written redo log instance',
--       'WS', 'Write-atomic-log-switch global enqueue',
         'TS', DECODE(l.id2, 0, 'Temporary segment enqueue (ID2=0)',
                                'New block allocation enqueue (ID2=1)'),
         'LA', 'Library cache lock instance (A=namespace)',
         'LB', 'Library cache lock instance (B=namespace)',
         'LC', 'Library cache lock instance (C=namespace)',
         'LD', 'Library cache lock instance (D=namespace)',
         'LE', 'Library cache lock instance (E=namespace)',
         'LF', 'Library cache lock instance (F=namespace)',
         'LG', 'Library cache lock instance (G=namespace)',
         'LH', 'Library cache lock instance (H=namespace)',
         'LI', 'Library cache lock instance (I=namespace)',
         'LJ', 'Library cache lock instance (J=namespace)',
         'LK', 'Library cache lock instance (K=namespace)',
         'LL', 'Library cache lock instance (L=namespace)',
         'LM', 'Library cache lock instance (M=namespace)',
         'LN', 'Library cache lock instance (N=namespace)',
         'LO', 'Library cache lock instance (O=namespace)',
         'LP', 'Library cache lock instance (P=namespace)',
--       'LS', 'Log start/log switch enqueue',
         'NA', 'Library cache pin instance (A=namespace)',
         'NB', 'Library cache pin instance (B=namespace)',
         'NC', 'Library cache pin instance (C=namespace)',
         'ND', 'Library cache pin instance (D=namespace)',
         'NE', 'Library cache pin instance (E=namespace)',
         'NF', 'Library cache pin instance (F=namespace)',
         'NG', 'Library cache pin instance (G=namespace)',
         'NH', 'Library cache pin instance (H=namespace)',
         'NI', 'Library cache pin instance (I=namespace)',
         'NJ', 'Library cache pin instance (J=namespace)',
         'NK', 'Library cache pin instance (K=namespace)',
         'NL', 'Library cache pin instance (L=namespace)',
         'NM', 'Library cache pin instance (M=namespace)',
         'NN', 'Library cache pin instance (N=namespace)',
         'NO', 'Library cache pin instance (O=namespace)',
         'NP', 'Library cache pin instance (P=namespace)',
         'NQ', 'Library cache pin instance (Q=namespace)',
         'NR', 'Library cache pin instance (R=namespace)',
         'NS', 'Library cache pin instance (S=namespace)',
         'NT', 'Library cache pin instance (T=namespace)',
         'NU', 'Library cache pin instance (U=namespace)',
         'NV', 'Library cache pin instance (V=namespace)',
         'NW', 'Library cache pin instance (W=namespace)',
         'NX', 'Library cache pin instance (X=namespace)',
         'NY', 'Library cache pin instance (Y=namespace)',
         'NZ', 'Library cache pin instance (Z=namespace)',
         'QA', 'Row cache instance (A=cache)',
         'QB', 'Row cache instance (B=cache)',
         'QC', 'Row cache instance (C=cache)',
         'QD', 'Row cache instance (D=cache)',
         'QE', 'Row cache instance (E=cache)',
         'QF', 'Row cache instance (F=cache)',
         'QG', 'Row cache instance (G=cache)',
         'QH', 'Row cache instance (H=cache)',
         'QI', 'Row cache instance (I=cache)',
         'QJ', 'Row cache instance (J=cache)',
         'QL', 'Row cache instance (K=cache)',
         'QK', 'Row cache instance (L=cache)',
         'QM', 'Row cache instance (M=cache)',
         'QN', 'Row cache instance (N=cache)',
         'QO', 'Row cache instance (O=cache)',
         'QP', 'Row cache instance (P=cache)',
         'QQ', 'Row cache instance (Q=cache)',
         'QR', 'Row cache instance (R=cache)',
         'QS', 'Row cache instance (S=cache)',
         'QT', 'Row cache instance (T=cache)',
         'QU', 'Row cache instance (U=cache)',
         'QV', 'Row cache instance (V=cache)',
         'QW', 'Row cache instance (W=cache)',
         'QX', 'Row cache instance (X=cache)',
         'QY', 'Row cache instance (Y=cache)',
         'QZ', 'Row cache instance (Z=cache)',
         '????')||')' Type,
       l.id1,
       l.id2,
       l.lmode,
       l.request,
--       DECODE(l.lmode, 0, '0-None',            /* Mon Lock equivalent */
--                       1, '1-Null',            /* N */
--                       2, '2-Row-S (SS)',      /* L */
--                       3, '3-Row-X (SX)',      /* R */
--                       4, '4-Share',           /* S */
--                       5, '5-S/Row-X (SSX)',   /* C */
--                       6, '6-Exclusive',       /* X */
--                       TO_CHAR(lmode)) mode_held,
--       DECODE(l.request, 0, '0-None',           /* Mon Lock equivalent */
--                         1, '1-Null',           /* N */
--                         2, '2-Row-S (SS)',     /* L */
--                         3, '3-Row-X (SX)',     /* R */
--                         4, '4-Share',          /* S */
--                         5, '5-S/Row-X (SSX)',  /* C */
--                         6, '6-Exclusive',      /* X */
--                         TO_CHAR(request)) mode_requested,
       DECODE(l.block, 0, 'NONE',             /* Not blocking any other processes */
                       1, 'Blocking',         /* This lock blocks other processes */
                       2, 'Global',           /* This lock is global, so we can't tell */
                       TO_CHAR(block)) blocking_others,
       l.ctime,
       DECODE(l.type, 'TM', o.object_name, 'TX', r.name, NULL) oname
  FROM v$lock l,
       v$session s,
       v$process p,
       v$rollname r,
       dba_objects o
 WHERE ( l.request > 0 OR l.block = 1 )
--l.id1 IN ( SELECT id1 FROM v$lock WHERE l.lmode = 0 )
   AND l.sid = s.sid
   AND l.id1 = o.object_id(+)
   AND s.paddr = p.addr
   AND TRUNC(l.id1(+)/65535) = r.usn
 ORDER BY id1, id2, request
/
