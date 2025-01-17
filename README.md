# Purpose

This package is meant to work as a template for other packages that want to
be pip-installable

## Further Reading

This project tries to follow and implement the best practices laid out in
[this tutorial](https://packaging.python.org/en/latest/tutorials/packaging-projects/).

The specifications found [here](https://packaging.python.org/en/latest/specifications/)
are also helpful. In particular,
[this section](https://packaging.python.org/en/latest/specifications/declaring-project-metadata/#dependencies-optional-dependencies)
contains a fairly succinct demonstration of how to specify dependencies.

# Usage

## On GitHub

It appears that you can use the `Use this template` button to create your own copy
of this repository for future editing

## Locally

Alternatively, you can:
* clone the repository
* delete the `.git` folder
* Run `git init` to re-initialize the repository as a repository independent
  of this template

These steps look like this:

```bash
cd ~/temp # as an example - can be wherever you want!
git clone git@github.com:LexisNexis-RBA/wc-pyproject-template.git my-new-repo
cd my-new-repo # whatever name you cloned into above
rm -rf ./.git
git init
```

# Things to Change

If you use this package, you'll want to make some updates:

* Name, author, description, etc. in `pyproject.toml`
* The contents of `src/`
    - **NOTE**: `src/hello/__init__.py` may be helpful for those who wish to populate a
      `__version__` attribute using the setuptools_scm approach. It's the same
      as [here](https://github.com/pypa/setuptools_scm#retrieving-package-version-at-runtime).
    - Otherwise, feel free to just delete the entire `src/hello` folder.
* This README

# Things you might not have to change

* `.pre-commit-config.yaml`
    - This was another topic from the 2022-08-05 Water Cooler. There
      doesn't seem to be much down-side to keeping it around, but you may
      wish to augment it and/or update package versions.
* `.gitignore`
