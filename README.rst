.. |date| date::

*********************
Combined TPM matrices
*********************

:authors: Komal S Rathi
:contact: rathik@email.chop.edu
:organization: D3B, CHOP
:status: This is "work in progress"
:date: |date|

.. meta::
   :keywords: tpm, matrices, 2020
   :description: TPM matrices

Introduction
============

The goal of this repo is to combine TPM matrices from various RNA-seq datasets.
Addresses issues: 
https://github.com/d3b-center/bixu-tracker/issues/703
https://github.com/d3b-center/bixu-tracker/issues/725
https://github.com/d3b-center/bixu-tracker/issues/726

Run Analysis
============

.. code-block:: bash

	# PNOC003 Cohort 1 + GTEx Brain + TGEN Brain
	bash run_cohort1_analysis.sh

	# PNOC003 Cohort 3a + GTEx Brain + TGEN Brain
	bash run_cohort3a_analysis.sh

	# PNOC003 Cohort 3b + GTEx Brain + TGEN Brain
	bash run_cohort3b_analysis.sh

Output
======

Uncorrected matrices:

1. PNOC003 Cohort 1 + GTEx Normal Brain + TGEN Brain : ``pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm.rds``
2. PNOC003 Cohort 3a + GTEx Normal Brain + TGEN Brain : ``pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm.rds``
3. PNOC003 Cohort 3b + GTEx Normal Brain + TGEN Brain : ``pnoc003-cohort3b-gtex-tgen-gene-expression-rsem-tpm.rds``

Corrected matrices:

1. PNOC003 Cohort 1 + GTEx Normal Brain + TGEN Brain: ``pnoc003-cohort1-gtex-tgen-gene-expression-rsem-tpm-corrected.rds``
2. PNOC003 Cohort 3a + GTEx Normal Brain + TGEN Brain : ``pnoc003-cohort3a-gtex-tgen-gene-expression-rsem-tpm-corrected.rds``
3. PNOC003 Cohort 3b + GTEx Normal Brain + TGEN Brain : ``pnoc003-cohort3b-gtex-tgen-gene-expression-rsem-tpm-corrected.rds``

S3 location
===========

.. code-block:: bash

    aws s3 --profile saml sync results/ s3://d3b-bix-dev-data-bucket/hgg-dmg-integration/batch_correction/ --include "*.rds"



    

