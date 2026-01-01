import argparse
from datetime import datetime

DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"

def parse_datetime(value: str) -> datetime:
    try:
        return datetime.strptime(value, DATETIME_FORMAT)
    except ValueError:
        raise argparse.ArgumentTypeError(
            f"Invalid datetime format. Expected: {DATETIME_FORMAT}"
        )


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--end_date",
        required=True,
        type=parse_datetime,
        help=f"End datetime (format: {DATETIME_FORMAT})",
    )

    parser.add_argument(
        "--delta",
        choices=["seconds", "minutes", "hours", "days", "weeks", "months"],
        default="seconds",
        help="Unit to return the duration in",
    )
    parser.add_argument(
        "--no_stub",
        action="store_true",
        help="Set to True if You want a CRLF at end of output"
    )
    return parser.parse_args()


def format_duration(delta, unit):
    seconds = delta.total_seconds()
    if unit == "seconds":
        return seconds
    if unit == "minutes":
        return seconds / 60
    if unit == "hours":
        return seconds / 3600
    if unit == "days":
        return seconds / 86400
    if unit == "weeks":
        return seconds / 604800
    if unit == "months":
        return seconds / 2629746  # average Gregorian month
    raise ValueError(unit)

def format_placeholders(unit):
    if unit == "seconds":
        return 10,0 
    if unit == "minutes":
        return 9,0
    if unit == "hours":
        return 8,0
    if unit == "days":
        return 5,0
    if unit == "weeks":
        return 4,0
    if unit == "months":
        return 3,0 
    raise ValueError(unit)

def main():
    args = parse_args()

    start = datetime.now()
    end = args.end_date

    duration = end - start

    result = format_duration(duration, args.delta)
    major,minor = format_placeholders(args.delta)
    print(f"{result:{major}.{minor}f}", end="\n" if args.no_stub else "")


if __name__ == "__main__":
    main()
