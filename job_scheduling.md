
# job scheduling and resource management

\define{Slurm}{__Slurm__}
## \Slurm

\define{Slurm_partition_linked}{[__partition__](#Slurm_partition)}
__(Slurm) partition__<a name="Slurm_partition"></a>

: a set of computing nodes grouped logically for a specific purpose

+ show info on nodes and \Slurm_partition_linked\plural:

	```bash
	sinfo
	```

	show more detailed information:

	```bash
	scontrol show partition
	```

+ show jobs managed by \Slurm

	```bash
	squeue
	```

	`ST` = state, `R` = running, `PD` = awaiting resource allocation

\define{Slurm_subm_script}{job.sh}
+ run a job:

	```bash
	sbatch \Slurm_subm_script
	```

	+ `\Slurm_subm_script`: a submission script composed of:

		+ resource requests (job name, number of CPUs, \Slurm_partition_linked, time limit, output file, etc.) --- prefixed with `#SBATCH`

		+ job steps (tasks to be pefrormed)

			```bash
			\include{job_scheduling/job.sh}
			```
