.PHONY: clean w wheel d docker curl_go l linux m mac

PACKAGE_NAME=${or ${pkg}, simple_go_timer}
PYTHON_PACKAGE_NAME=$(lastword $(subst /, ,${PACKAGE_NAME}))
PYTHON_BINARY_PATH=${or ${py}, /usr/local/opt/python@3.11/bin/python3.11}


clean:
	rm -rf ./_tmp ./*.egg-info ./build ./setup.py

# make wheel py=PYTHON_BINARY_PATH pkg=PACKAGE_NAME
w wheel:
	cp setup_gopy.py setup.py
	${PYTHON_BINARY_PATH} -m pip install pybindgen
	CGO_LDFLAGS_ALLOW=".*" gopy build -no-make -dynamic-link=True -output="_tmp/${PACKAGE_NAME}" -vm=${PYTHON_BINARY_PATH} ${PACKAGE_NAME}
	echo "from .${PYTHON_PACKAGE_NAME} import *" > _tmp/${PACKAGE_NAME}/__init__.py
	_PACKAGE_PATH=${PACKAGE_NAME} ${PYTHON_BINARY_PATH} -m build -w -o ./wheelhouse
	$(MAKE) clean

# make docker v=3.10
d docker:
	docker run --rm -it -v `pwd`:/dist python:${or ${v}, 3.11}-slim bash

curl_go:
	[ ! -f "go.tar.gz" ] && curl -o go.tar.gz "https://dl.google.com/go/go1.19.3.linux-amd64.tar.gz" || echo "found go tar"

# make linux pkg=PACKAGE_NAME
l linux: curl_go
	cp setup_local.py setup.py && \
	sed -ie 's|REPLACE_ME|"${PACKAGE_NAME}"|' setup.py
	python -m pip install cibuildwheel
	CIBW_BEFORE_ALL='tar -C /usr/local -xzf go.tar.gz && export PATH=${PATH}:/usr/local/go/bin && ln -s /usr/local/go/bin/go /usr/bin/' \
	CIBW_BUILD="cp39-manylinux_x86_64 cp31*-manylinux_x86_64" \
	python -m cibuildwheel --output-dir ./wheelhouse --platform linux

# make mac py=PYTHON_BINARY_PATH pkg=PACKAGE_NAME, PYTHON_BINARY_PATH must be from python.org, it used in setup_local.py
m mac:
	cp setup_local.py setup.py && \
	sed -ie 's|REPLACE_ME|"${PACKAGE_NAME}"|' setup.py
	${PYTHON_BINARY_PATH} -m pip install cibuildwheel
	CIBW_BUILD=cp311-macosx_x86_64 \
	PYTHON_BINARY_PATH=${PYTHON_BINARY_PATH} \
	${PYTHON_BINARY_PATH} -m cibuildwheel --platform macos
