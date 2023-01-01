#!/usr/bin/fish

# Not only do we get better performance by relegating date-reading and table
# creation to `date` (gnu-coreutis) and `column` (util-linux) respectively, but
# as a result of this the python segment can be completed with nothing but the
# datetime and regular expressions module.
#
# GNU date is one of the few non-POSIX extensions I'm okay with,
# and Linux is the only Unix-like Kernel I will ever use, so util-linux is
# fine. 👍

argparse --max-args 2 'h/help' 'w/week' 't/format=' -- $argv || return 1
if set -q _flag_help
    echo "when [-h|--help] [-w|--week] [-t|--format FORMAT] SEARCH [GNU_DATE]"
    echo
    echo "The week flag will show the entire week instead of a single day"
    echo "FORMAT takes a strftime(3) string."
    echo "Please see `info '(coreutils) Date input formats'` for what GNU_DATE can be"
    return 0
end
if set -q argv[2]
    set d_string $argv[2]
else
    set d_string now
end
if set -q _flag_week
    set day 0
else
    set day (date -d $d_string +%u)
end
if set -q _flag_format
    set format $_flag_format
else
    set format '%I%P'
end

set csv ~/docs/school/atlanta.csv
set align column -tR 0 -s ","

python3 $scripts/when.py $argv[1] $csv $day $format | $align
