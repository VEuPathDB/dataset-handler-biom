# Transformer of .bioms
This is a validator / transformer of .bioms, ran before they go into iRODS.

## Run tests locally
These are instructions for an Ubuntu laptop.

1. Make sure your python's version starts with 2
You can also change the first line of bin/exportBiomToEuPathDB to point to your python2 

2. Install bats

Google for how. Then check you have it. `which bats`

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
