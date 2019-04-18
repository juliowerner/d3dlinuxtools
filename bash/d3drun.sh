#!/bin/bash
# Run Delft3d FLOW
# Usage:
# d3drun [MDF FILE] [NofPARTITIONS]

MDFFILE=$1
NPART=$2

if [ -z "$MDFFILE" ]; then
  echo "Usage:
  rund3d [MDF FILE] [NofPARTITIONS]"
  exit 1
fi
if [ -z "$NPART" ]; then
  NPART=1
fi
# Generate xml file
echo '<?xml version="1.0" encoding="iso-8859-1"?>
<deltaresHydro xmlns="http://schemas.deltares.nl/deltaresHydro" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.deltares.nl/deltaresHydro http://content.oss.deltares.nl/schemas/d_hydro-1.00.xsd">
    <documentation>
        File created by: rund3d v0.1
    </documentation>
    <control>
        <sequence>
            <start>D3DFlowProject</start>
        </sequence>
    </control>
    <flow2D3D name="D3DFlowProject">
        <library>flow2d3d</library>
        <mdfFile>'$MDFFILE'</mdfFile>
    </flow2D3D>
</deltaresHydro>' > current_run.xml

# Running
export D3D_HOME=~/delft3d
exedir=$D3D_HOME/flow2d3d/bin
export LD_LIBRARY_PATH=$exedir:$LD_LIBRARY_PATH 
export PATH="/opt/mpich-intel/bin:${PATH}"

if  [[ ("$NPART" > 1) ]] ; then
  mpirun -np $NPART $exedir/d_hydro.exe current_run.xml
else
  $exedir/d_hydro.exe current_run.xml
fi
rm -f log*.irlog
rm current_run.xml
