from argparse import ArgumentParser

from . import hello

parser = ArgumentParser(prog="hello")
parser.add_argument("--to", "-t", default="World", help="Whom to greet")

args = parser.parse_args()

print(hello(to=args.to))
