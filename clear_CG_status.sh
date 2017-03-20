##Clear SLURM queue CG status.

scontrol update nodename=node001 state=down reason=hang
scontrol update nodename=node001 state=resume
