#!/usr/bin/env python3

import sys
import datetime
import re
from operator import methodcaller as method

from pymonad.reader import Compose

target, csv, day, tfmt = sys.argv[1:]
target = re.compile(target)
day = int(day)

if day:
    fnum = day * 2 - 1
    d = datetime.datetime.strptime(str(day), '%u').date()

with open(csv, 'r') as f:
    # Setup our header
    fields = next(f).strip().split(',')
    if day:
        print(fields[0] + ',', end='')
        frange = slice(fnum, fnum+2)
    else:
        frange = slice(len(fields))
    print(*fields[frange], sep=',')

    for fields in map(Compose(method('strip')).map(method('split', ',')), f):
        frange = slice(fnum, fnum+2) if day else slice(1, len(fields))
        if target.search((field_list := [fields[0]])[0]):
            for h in fields[frange]:
                try:
                    hf = float(h)
                    t_h = int(hf // 1)
                    t_m = int(hf % 1) * 60
                    field_list.append(datetime.time(t_h, t_m).strftime(tfmt))
                except ValueError:
                    field_list.append(h)
            print(*field_list, sep=',')
