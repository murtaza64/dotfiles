#! /usr/bin/python3

import argparse
import sys
from pathlib import Path
from datetime import datetime

CACHE_LOCATION=Path.home() / (".cache/rcnt")
CACHE_LOCATION.mkdir(parents=True, exist_ok=True)
CACHE_FILE=CACHE_LOCATION / "cache"
CACHE_FILE.touch()

def read_cache():
    files = {}
    with open(CACHE_FILE, "r") as f:
        for line in f:
            name, timestamp = line.rsplit(':', 1)
            timestamp = datetime.fromtimestamp(float(timestamp))
            files[name] = timestamp
    return files

def write_cache(files):
    with open(CACHE_FILE, "w") as f:
        for name, timestamp in sorted(
                files.items(), 
                key=lambda p: p[1], 
                reverse=True
            ):
            f.write(f"{name}:{datetime.timestamp(timestamp)}\n")

def get_age(date):
    '''Take a datetime and return its "age" as a string.
    The age can be in second, minute, hour, day, month or year. Only the
    biggest unit is considered, e.g. if it's 2 days and 3 hours, "2 days" will
    be returned.
    Make sure date is not in the future, or else it won't work.
    https://gist.github.com/zhangsen/1199964/7225c00d65605b5fc2b106346a6f8b4bca860b6c
    '''

    def formatn(n, s):
        '''Add "s" if it's plural'''

        if n == 1:
            return "1 %s ago" % s
        else:
            return "%d %ss ago" % (n, s)

    def q_n_r(a, b):
        '''Return quotient and remaining'''

        return a // b, a % b

    class PrettyDelta:
        def __init__(self, dt):
            now = datetime.now()
            delta = now - dt
            self.day = delta.days
            self.second = delta.seconds

            self.year, self.day = q_n_r(self.day, 365)
            self.month, self.day = q_n_r(self.day, 30)
            self.hour, self.second = q_n_r(self.second, 3600)
            self.minute, self.second = q_n_r(self.second, 60)

        def format(self):
            for period in ['year', 'month', 'day', 'hour', 'minute', 'second']:
                n = getattr(self, period)
                if n > 0:
                    return formatn(n, period)
            return "just now"

    return PrettyDelta(date).format()

def add(args):
    files = read_cache()
    files[args.file] = datetime.now()
    write_cache(files)

def show(args):
    files = read_cache()
    files_sorted = list(sorted(
        files.items(), 
        key=lambda p: p[1], 
        reverse=True
    ))
    for name, dt in files_sorted[:args.num]:
        if args.timestamp == 'none':
            print(f"{name}")
        elif args.timestamp == "raw":
            print(f"{name}:{datetime.timestamp(dt)}")
        elif args.timestamp == "pretty":
            print(f"{name}:{get_age(dt)}")


parser = argparse.ArgumentParser(prog="rcnt")
subparsers = parser.add_subparsers(help="subcommand", required=True)

parser_add = subparsers.add_parser("add", help="remember a file as recently used")
parser_add.add_argument("file", help="file to remember")
parser_add.set_defaults(func=add)

parser_get = subparsers.add_parser("get", help="get recently used files", aliases=["show"])
parser_get.add_argument("--num", default=10)
parser_get.add_argument("--timestamp", choices=['none', 'raw', 'pretty'], default='pretty')
parser_get.set_defaults(func=show)

args = parser.parse_args(sys.argv[1:])
args.func(args)