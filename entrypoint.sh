#!/bin/bash
source /workspace/geant4-v11.2.2-install/bin/geant4.sh
cd /workspace/root
source bin/thisroot.sh
cd /workspace

# If no command is passed, start an interactive shell
if [ "$#" -eq 0 ]; then
    exec /bin/bash
else
    exec "$@"
fi
