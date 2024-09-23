#!/bin/bash
source /workspace/geant4-v11.2.2-install/bin/geant4.sh
source /workspace/root/bin/thisroot.sh

# If no command is passed, start an interactive shell
if [ "$#" -eq 0 ]; then
    exec /bin/bash
else
    exec "$@"
fi
