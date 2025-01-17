from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version("wc-pyproject-template")
except PackageNotFoundError:
    # package is not installed
    pass

def hello(greeting="Hello", to="World"):
    return f"{greeting}, {to}!"
