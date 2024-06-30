from setuptools import setup

setup(
    name='pybrary_extraction',
    version='1.0',
    description='Library Extraction for Python!',
    packages=['pybrary_extraction'],  # same as name
    install_requires=['click', 'pyparsing', 'pylint'],  # external packages as dependencies
)
