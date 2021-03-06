/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Unpaired_pruning_DAFS_DAFS_DV_terminate.c
 *
 * Code generation for function 'Unpaired_pruning_DAFS_DAFS_DV_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "Unpaired_pruning_DAFS_DAFS_DV.h"
#include "Unpaired_pruning_DAFS_DAFS_DV_terminate.h"
#include "_coder_Unpaired_pruning_DAFS_DAFS_DV_mex.h"
#include "Unpaired_pruning_DAFS_DAFS_DV_data.h"

/* Function Definitions */
void Unpaired_pruning_DAFS_DAFS_DV_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void Unpaired_pruning_DAFS_DAFS_DV_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (Unpaired_pruning_DAFS_DAFS_DV_terminate.c) */
