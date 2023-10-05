#!/bin/bash

if [ "$#" -ne 1 ];
then
    echo "Need to provide path to .riproject file"
    exit 1
fi
echo "Parsing File $1"
RIPROJECT=$1


# Create directories to hold outputs
extraction_dir=${RIPROJECT}/time_extraction
rxp2ply_dir=${extraction_dir}/rxp2ply
downsample_dir=${extraction_dir}/downsample

# Check if already have a tile index, if do then processing has already run.
if [ -f ${extraction_dir}/tile_index.dat ]; then
    echo "Looks like processing has already run for ${RIPROJECT} please remove tile index to run again"
    exit 0
fi

mkdir -p $rxp2ply_dir
mkdir -p $downsample_dir

# Convert to ply
python /code/rxp2ply.py --project ${RIPROJECT} --deviation 15 --odir ${rxp2ply_dir} --verbose --num-prcs 1 &&
# Downsample
python /code/downsample.py -i ${rxp2ply_dir} -o ${downsample_dir} --length 0.02 --verbose &&
# Create new tile index
python /code/tile_index.py ${downsample_dir} -o ${extraction_dir}

