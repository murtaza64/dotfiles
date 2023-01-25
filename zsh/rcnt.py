#! /usr/bin/python3

import argparse
import sys
from datetime import datetime

CACHE_LOCATION="/home/murtaza/.cache/rcnt/cache"

def read_cache():
    files = {}
    with open(CACHE_LOCATION, "r") as f:
        for line in f:
            name, timestamp = line.rsplit(':', 1)
            timestamp = datetime.fromtimestamp(float(timestamp))
            files[name] = timestamp
    return files

def write_cache(files):
    with open(CACHE_LOCATION, "w") as f:
        for name, timestamp in sorted(
                files.items(), 
                key=lambda p: p[1], 
                reverse=True
            ):
            f.write(f"{name}:{datetime.timestamp(timestamp)}")
    

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
            print(f"{name}:{dt}")


parser = argparse.ArgumentParser(prog="rcnt")
subparsers = parser.add_subparsers(help="subcommand")

parser_add = subparsers.add_parser("add", help="remember a file as recently used")
parser_add.add_argument("file", help="file to remember")
parser_add.set_defaults(func=add)

parser_get = subparsers.add_parser("get", help="get recently used files")
parser_get.add_argument("--num", default=10)
parser_get.add_argument("--timestamp", choices=['none', 'raw', 'pretty'], default='pretty')
parser_get.set_defaults(func=show)

args = parser.parse_args(sys.argv[1:])
args.func(args)