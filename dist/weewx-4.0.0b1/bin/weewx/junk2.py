from __future__ import print_function
import time

import weeutil.weeutil
import weewx.manager
import weewx.xtypes

archive_sqlite = {'database_name': '/home/weewx/archive/weepwr.sdb', 'driver': 'weedb.sqlite'}
archive_mysql = {'database_name': 'weewx', 'user': 'weewx', 'password': 'weewx', 'driver': 'weedb.mysql'}

sql_str = "SELECT %s(%s), MIN(usUnits), MAX(usUnits) FROM %s " \
          "WHERE dateTime > ? AND dateTime <= ?" % ('avg', 'outTemp', 'archive')

timespan = weeutil.weeutil.TimeSpan(1573245000, 1573246800)
timespan = weeutil.weeutil.TimeSpan(1573245000, 1573245000 + 600)
print('timespan=', timespan)

with weewx.manager.Manager.open(archive_sqlite) as db_manager:
    interpolate_dict = {
        'aggregate_type': 'diff',
        'obs_type': 'ch8_a_energy2',
        'table_name': db_manager.table_name,
        'start': timespan.start,
        'stop': timespan.stop,
    }

    SQL_TEMPLATE = "SELECT (ch8_a_energy2 - (SELECT ch8_a_energy2 FROM archive WHERE dateTime=%(start)s)) / (%(stop)s - %(start)s) FROM archive WHERE dateTime=%(stop)s;"
    SQL_TEMPLATE = """Select a.dateTime as StartTime
     , b.dateTime as EndTime
     , b.dateTime-a.dateTime as TimeChange
     , b.ch8_a_energy2-a.ch8_a_energy2 as ValueChange
    FROM archive a 
    Inner Join archive b ON b.dateTime>=1573245000 AND b.dateTime<=(1573245000 + 600)"""

    SQL_TEMPLATE = """Select a.dateTime as StartTime, b.datetime as EndTime, b.dateTime-a.dateTime as TimeChange, b.ch8_a_energy2-a.ch8_a_energy2 as ValueChange
FROM archive a, archive b WHERE b.dateTime = (Select MAX(c.dateTime) FROM archive c WHERE c.dateTime<=(1573245000+600)) AND a.dateTime = (SELECT MIN(dateTime) FROM archive WHERE dateTime>=1573245000);"""

    SQL_TEMPLATE = """Select a.dateTime as StartTime, b.datetime as EndTime, b.dateTime-a.dateTime as TimeChange, b.ch8_a_energy2-a.ch8_a_energy2 as ValueChange
    FROM archive a, archive b WHERE b.dateTime = (Select MAX(dateTime) FROM archive WHERE dateTime<=(1573245000+600)) AND a.dateTime = (SELECT MIN(dateTime) FROM archive WHERE dateTime>=1573245000);"""

    SQL_TEMPLATE = "SELECT (b.%(obs_type)s - a.%(obs_type)s) / (b.dateTime-a.dateTime) "\
                  "FROM archive a, archive b "\
                  "WHERE b.dateTime = (SELECT MAX(dateTime) FROM archive WHERE dateTime <= %(stop)s) "\
                  "AND a.dateTime = (SELECT MIN(dateTime) FROM archive WHERE dateTime >= %(start)s);"

    sql_stmt = SQL_TEMPLATE % interpolate_dict
    print(sql_stmt)
    # Get the number of records
    with db_manager.connection.cursor() as cursor:
        for row in cursor.execute(sql_stmt):
            print(row)
