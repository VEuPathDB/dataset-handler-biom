# Handler of .bioms


## Run tests

1. Make sure your python's version starts with 2

1a.  ... or change the shebang in bin/exportBiomToEuPathDB

2. Install bats
Then check you have it. `which bats`

3. Install parent libs

They're in this https://github.com/VEuPathDB/docker-galaxy-python-tools/blob/master/Dockerfile

```
pip install --no-cache-dir numpy cython git+https://github.com/VEuPathDB/dataset-handler-python-base \
pip install --no-cache-dir 'biom-format==2.1.7' h5py
```

3. Run tests (getting the PYTHONPATH right)

```
PYTHONPATH=./lib/python test/test.bats 
```
