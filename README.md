## simulation environment

scripts to make the docker/apptainer environment for simulations (including Geant4, Pythia8, ROOT).

To make the docker image, run the following command in the terminal:
```bash
docker build -t alma9forgeant4:v1 .
```

To convert the docker image to an apptainer image
```bash
SINGULARITY_TMPDIR=/home/yfeng/Desktop/.apptainer/tmp SINGULARITY_CACHEDIR=/home/yfeng/Desktop/.apptainer singularity build alma9forgeant4 docker-daemon://alma9forgeant4
```
and build the sandbox from the image
```bash
singularity build --sandbox alma9forgeant4_sbox alma9forgeant4
```
