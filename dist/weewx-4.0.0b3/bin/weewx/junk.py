from __future__ import print_function
import os, time
from weeutil.weeutil import startOfInterval

interval = 195

os.environ['TZ'] = 'America/Los_Angeles'
time.tzset()

start_ts = time.mktime(time.strptime("2013-07-04 01:57:35", "%Y-%m-%d %H:%M:%S"))
print(start_ts)
rev = int(start_ts/interval)
start_ts = rev * interval
print(start_ts)
print(time.ctime(start_ts))

# begin = startOfInterval(start_ts, interval)
# print(time.ctime(begin), time.ctime(begin+interval))

alt = int(start_ts / interval)* interval
print(time.ctime(alt), time.ctime(alt+interval))


