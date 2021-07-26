# blast_nf

quick dsl2 blast

```
git clone https://github.com/j23414/blast_nf.git

# Load necessary modules and dependencies
module load nextflow
module load blast

nextflow run main.nf \
  --db "path/to/nt.fasta" \
  --query "*.fasta" \
  --threads 50
```

Output should be in `Blast_Results` folder.
