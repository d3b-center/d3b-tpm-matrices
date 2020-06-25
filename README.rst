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
Addresses issue: https://github.com/d3b-center/bixu-tracker/issues/703

Description
===========

Combined matrices for the following:

1. TGEN Brain + GTEx Normal Brain: ``gtexbrain-tgen-combined-gene-expression-rsem-tpm-collapsed.polya.rds``
2. PBTA PolyA + rRNA corrected: ``all-pbta-gene-expression-rsem-tpm.polya.stranded.combined.rds``
3. PNOC003 PolyA: ``pnoc003-pbta-gene-expression-rsem-tpm-collapsed.polya.rds``
   
S3 location
===========

.. code-block:: bash

    aws s3 --profile saml cp --recursive results/ s3://d3b-bix-dev-data-bucket/hgg-dmg-integration/rsem/ --include "*.rds"

