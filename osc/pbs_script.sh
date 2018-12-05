#PBS -N ondemand/sys/myjobs/basic_matlab
#PBS -l walltime=02:00:00
#PBS -l nodes=1:ppn=28
#PBS -j oe


#  A Basic MATLAB Job for the OSC Owens Cluster
#  https://www.osc.edu/resources/available_software/software_list/matlab

#
# The following lines set up the Matlab environment
#
module load matlab/r2017a
#
# Transfer MATLAB script file to TMPDIR
#
cd $PBS_O_WORKDIR
cp starter.m $TMPDIR
cd $TMPDIR
#
# run MATLAB script
#
matlab -nodisplay -nodesktop < starter.m
