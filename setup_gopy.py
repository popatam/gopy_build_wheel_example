import os
import setuptools


PACKAGE_PATH=os.getenv("_PACKAGE_PATH", "simple_go_timer")
PACKAGE_NAME=PACKAGE_PATH.split("/")[-1]

setuptools.setup(
    name=PACKAGE_NAME,
    version="0.1.0",
    author="change_me",
    author_email="change_me@example.com",
    description="",
    url="https://github.com/go-python/gopy",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
    ],
    include_package_data=True,
    package_dir={".": f"./_tmp/{PACKAGE_PATH}/../"},
    package_data={"": ["*.so"]}
)
