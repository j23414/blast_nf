#! /usr/bin/env bash

nextflow.enable.dsl=2

process makeblastdb {
    publishDir "$params.outdir/", mode: 'copy'
    input: path(db_fasta)
    output: tuple path("${db_fasta}"), path("${db_fasta}*")
    script:
    """
    #! /usr/bin/env bash
    makeblastdb -in ${db_fasta} -dbtype nucl
    """
}

process blastn {
    publishDir "$params.outdir/", mode: 'copy'
    input: tuple path(db_fasta), path(db_indexed), path(query_fasta)
    output: path("*_blastout.txt")
    script:
    """
    #! /usr/bin/env bash
    blastn \
      -num_treads ${params.threads} \
      -db $db_fasta \
      -query $query_fasta \
      -outfmt 6 \
      -out ${query_fasta.baseName}_blastout.txt
    """
}

workflow {
  /* input channels */
  db_ch = channel.fromPath(params.db, checkIfExists:true) 
  query_ch = channel.fromPath(params.query, checkIfExists:true) 
  
  /* run blast */
  db_ch | makeblastdb | combine(query_ch) | blastn | view
}