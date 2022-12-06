## gopy_build_wheel_example

An example showing how to build python wheel from golang code with [gopy](https://github.com/go-python/gopy).
It is recommended to use GitHub Actions for cross-platform build.

## How to use

### build with github actions

* copy `setup_ci.py` and `.github/workflows/build_wheel.yml` to your golang github project
* replace `PACKAGE_PATH` var value in `setup_ci.py` with name of golang package
* push to github and wait for github actions jobs to complete
* download build wheels from actions

### local build linux wheel from any with cibuildwheel

- `make linux pkg=GO_PACKAGE_NAME`  
  target python version can be passed to `CIBW_BUILD` see `Makefile`,
  see cibuildwheel [docs](https://cibuildwheel.readthedocs.io/en/stable/options/#build-skip)

example:  
building `github.com/go-python/gopy/_examples/hi` from gopy examples

- `go get github.com/go-python/gopy/_examples/hi`
- `make linux pkg=github.com/go-python/gopy/_examples/hi`

### local build macos wheel from macos with cibuildwheel

need go and gopy installed

`make mac py=PYTHON_BINARY_PATH pkg=PACKAGE_NAME`

- `PYTHON_BINARY_PATH` - path to python binary from python.org
- `PACKAGE_NAME` - name of go package to build

`make mac pkg=github.com/go-python/gopy/_examples/hi`

example:  
`make mac pkg=github.com/go-python/gopy/_examples/hi py=/usr/local/opt/python@3.11/bin/python3.11`

### build local without cibuildwheel

need go and gopy installed

`make wheel py=PYTHON_BINARY_PATH pkg=PACKAGE_NAME`

- `PYTHON_BINARY_PATH` - path to python binary from python.org
- `PACKAGE_NAME` - name of go package to build

example:
`make wheel py=/usr/local/opt/python@3.11/bin/python3.11 pkg=simple_go_timer`

## files

- `setup_ci.py` setup.py for build in github actions
- `setup_gopy.py` setup.py for local build with gopy
- `setup_local.py` setup.py for local cross-platform build

- `.github/workflows/build_wheel.yml` github actions with cross-platform build jobs

- `simple_go_timer.go` simple go timer just for build demonstration
- `example.py` demonstrates work of simple_go_timer package in python
- `cmd/main.go` demonstrates work of simple_go_timer in go

## FAQ

- _Build fails with `cgo: cannot parse $WORK/b001/_cgo_.o as ELF, Mach-O, PE or XCOFF`_  
  On MacOS it seems that you are using python in gopy's `-vm` not from python.org


- _What for cibuildwheel?_  
  It really helps to build packages. Without cibuildwheel it would be necessary to make auditwheel on linux and
  delocate-wheel on mac.

## TODO

- linux x86 and arm64
- macos py 38,39 arm64
- windows
- add wheels auto tests
