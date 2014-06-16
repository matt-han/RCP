/*
 * regler_strecke.c
 *
 * Real-Time Workshop code generation for Simulink model "regler_strecke.mdl".
 *
 * Model Version              : 1.16
 * Real-Time Workshop version : 7.0  (R2007b)  02-Aug-2007
 * C source code generated on : Mon Jun 16 16:00:06 2014
 */

#include "regler_strecke.h"
#include "regler_strecke_private.h"
#include <stdio.h>
#include "regler_strecke_dt.h"

/* options for Real-Time Windows Target board 0 */
static double RTWinBoardOptions0[] = {
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
};

/* list of Real-Time Windows Target boards */
const int RTWinBoardCount = 1;
RTWINBOARD RTWinBoards[1] = {
  { "National_Instruments/PCI-6025E", 4294967295U, 6, RTWinBoardOptions0 },
};

/* Block signals (auto storage) */
BlockIO_regler_strecke regler_strecke_B;

/* Continuous states */
ContinuousStates_regler_strecke regler_strecke_X;

/* Block states (auto storage) */
D_Work_regler_strecke regler_strecke_DWork;

/* Real-time model */
RT_MODEL_regler_strecke regler_strecke_M_;
RT_MODEL_regler_strecke *regler_strecke_M = &regler_strecke_M_;

/* This function updates continuous states using the ODE4 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE4_IntgData *id = (ODE4_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T *f3 = id->f[3];
  real_T temp;
  int_T i;
  int_T nXc = 1;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y,x,
                nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  regler_strecke_derivatives();

  /* f1 = f(t + (h/2), y + (h/2)*f0) */
  temp = 0.5 * h;
  for (i = 0; i < nXc; i++)
    x[i] = y[i] + (temp*f0[i]);
  rtsiSetT(si, t + temp);
  rtsiSetdX(si, f1);
  regler_strecke_output(0);
  regler_strecke_derivatives();

  /* f2 = f(t + (h/2), y + (h/2)*f1) */
  for (i = 0; i < nXc; i++)
    x[i] = y[i] + (temp*f1[i]);
  rtsiSetdX(si, f2);
  regler_strecke_output(0);
  regler_strecke_derivatives();

  /* f3 = f(t + h, y + h*f2) */
  for (i = 0; i < nXc; i++)
    x[i] = y[i] + (h*f2[i]);
  rtsiSetT(si, tnew);
  rtsiSetdX(si, f3);
  regler_strecke_output(0);
  regler_strecke_derivatives();

  /* tnew = t + h
     ynew = y + (h/6)*(f0 + 2*f1 + 2*f2 + 2*f3) */
  temp = h / 6.0;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + 2.0*f1[i] + 2.0*f2[i] + f3[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model output function */
void regler_strecke_output(int_T tid)
{
  /* local block i/o variables */
  real_T rtb_Add;

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(regler_strecke_M)) {
    regler_strecke_M->Timing.t[0] = rtsiGetT(&regler_strecke_M->solverInfo);
  }

  if (rtmIsMajorTimeStep(regler_strecke_M)) {
    /* set solver stop time */
    rtsiSetSolverStopTime(&regler_strecke_M->solverInfo,
                          ((regler_strecke_M->Timing.clockTick0+1)*
      regler_strecke_M->Timing.stepSize0));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(regler_strecke_M) &&
      regler_strecke_M->Timing.TaskCounters.TID[1] == 0) {
    /* S-Function Block: <Root>/Analog Input */
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) regler_strecke_P.AnalogInput_RangeMode;
      parm.rangeidx = regler_strecke_P.AnalogInput_VoltRange;
      RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1,
                     &regler_strecke_P.AnalogInput_Channels, &rtb_Add, &parm);
    }

    /* Sum: '<Root>/Add' incorporates:
     *  Constant: '<Root>/Offset_in'
     */
    rtb_Add += regler_strecke_P.Offset_in_Value;

    /* Gain: '<S1>/Gain' incorporates:
     *  Constant: '<Root>/Sprung'
     *  Sum: '<Root>/Sum'
     */
    regler_strecke_B.Gain = (regler_strecke_P.Sprung_Value - rtb_Add) *
      regler_strecke_P.Gain_Gain;
  }

  /* TransferFcn Block: '<S1>/first' */
  regler_strecke_B.first = regler_strecke_P.first_D*regler_strecke_B.Gain;
  regler_strecke_B.first += regler_strecke_P.first_C*
    regler_strecke_X.first_CSTATE;

  /* Sum: '<Root>/Add1' incorporates:
   *  Constant: '<Root>/offset_out'
   */
  regler_strecke_B.Add1 = regler_strecke_B.first +
    regler_strecke_P.offset_out_Value;
  if (rtmIsMajorTimeStep(regler_strecke_M) &&
      regler_strecke_M->Timing.TaskCounters.TID[1] == 0) {
    /* S-Function Block: <Root>/Analog Output */
    {
      {
        ANALOGIOPARM parm;
        parm.mode = (RANGEMODE) regler_strecke_P.AnalogOutput_RangeMode;
        parm.rangeidx = regler_strecke_P.AnalogOutput_VoltRange;
        RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                       &regler_strecke_P.AnalogOutput_Channels,
                       &regler_strecke_B.Add1, &parm);
      }
    }

    /* Gain: '<Root>/Gain' */
    regler_strecke_B.Gain_f = regler_strecke_P.Gain_Gain_i * rtb_Add;
  }

  UNUSED_PARAMETER(tid);
}

/* Model update function */
void regler_strecke_update(int_T tid)
{
  if (rtmIsMajorTimeStep(regler_strecke_M)) {
    rt_ertODEUpdateContinuousStates(&regler_strecke_M->solverInfo);
  }

  /* Update absolute time for base rate */
  if (!(++regler_strecke_M->Timing.clockTick0))
    ++regler_strecke_M->Timing.clockTickH0;
  regler_strecke_M->Timing.t[0] = regler_strecke_M->Timing.clockTick0 *
    regler_strecke_M->Timing.stepSize0 + regler_strecke_M->Timing.clockTickH0 *
    regler_strecke_M->Timing.stepSize0 * 4294967296.0;
  if (rtmIsMajorTimeStep(regler_strecke_M) &&
      regler_strecke_M->Timing.TaskCounters.TID[1] == 0) {
    /* Update absolute timer for sample time: [0.001s, 0.0s] */
    if (!(++regler_strecke_M->Timing.clockTick1))
      ++regler_strecke_M->Timing.clockTickH1;
    regler_strecke_M->Timing.t[1] = regler_strecke_M->Timing.clockTick1 *
      regler_strecke_M->Timing.stepSize1 + regler_strecke_M->Timing.clockTickH1 *
      regler_strecke_M->Timing.stepSize1 * 4294967296.0;
  }

  UNUSED_PARAMETER(tid);
}

/* Derivatives for root system: '<Root>' */
void regler_strecke_derivatives(void)
{
  /* TransferFcn Block: '<S1>/first' */
  {
    ((StateDerivatives_regler_strecke *) regler_strecke_M->ModelData.derivs)
      ->first_CSTATE = regler_strecke_B.Gain;
    ((StateDerivatives_regler_strecke *) regler_strecke_M->ModelData.derivs)
      ->first_CSTATE += (regler_strecke_P.first_A)*regler_strecke_X.first_CSTATE;
  }
}

/* Model initialize function */
void regler_strecke_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));    /* initialize real-time model */
  (void) memset((char_T *)regler_strecke_M,0,
                sizeof(RT_MODEL_regler_strecke));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&regler_strecke_M->solverInfo,
                          &regler_strecke_M->Timing.simTimeStep);
    rtsiSetTPtr(&regler_strecke_M->solverInfo, &rtmGetTPtr(regler_strecke_M));
    rtsiSetStepSizePtr(&regler_strecke_M->solverInfo,
                       &regler_strecke_M->Timing.stepSize0);
    rtsiSetdXPtr(&regler_strecke_M->solverInfo,
                 &regler_strecke_M->ModelData.derivs);
    rtsiSetContStatesPtr(&regler_strecke_M->solverInfo,
                         &regler_strecke_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&regler_strecke_M->solverInfo,
      &regler_strecke_M->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&regler_strecke_M->solverInfo, (&rtmGetErrorStatus
      (regler_strecke_M)));
    rtsiSetRTModelPtr(&regler_strecke_M->solverInfo, regler_strecke_M);
  }

  rtsiSetSimTimeStep(&regler_strecke_M->solverInfo, MAJOR_TIME_STEP);
  regler_strecke_M->ModelData.intgData.y = regler_strecke_M->ModelData.odeY;
  regler_strecke_M->ModelData.intgData.f[0] = regler_strecke_M->ModelData.odeF[0];
  regler_strecke_M->ModelData.intgData.f[1] = regler_strecke_M->ModelData.odeF[1];
  regler_strecke_M->ModelData.intgData.f[2] = regler_strecke_M->ModelData.odeF[2];
  regler_strecke_M->ModelData.intgData.f[3] = regler_strecke_M->ModelData.odeF[3];
  regler_strecke_M->ModelData.contStates = ((real_T *) &regler_strecke_X);
  rtsiSetSolverData(&regler_strecke_M->solverInfo, (void *)
                    &regler_strecke_M->ModelData.intgData);
  rtsiSetSolverName(&regler_strecke_M->solverInfo,"ode4");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = regler_strecke_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    regler_strecke_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    regler_strecke_M->Timing.sampleTimes =
      (&regler_strecke_M->Timing.sampleTimesArray[0]);
    regler_strecke_M->Timing.offsetTimes =
      (&regler_strecke_M->Timing.offsetTimesArray[0]);

    /* task periods */
    regler_strecke_M->Timing.sampleTimes[0] = (0.0);
    regler_strecke_M->Timing.sampleTimes[1] = (0.001);

    /* task offsets */
    regler_strecke_M->Timing.offsetTimes[0] = (0.0);
    regler_strecke_M->Timing.offsetTimes[1] = (0.0);
  }

  rtmSetTPtr(regler_strecke_M, &regler_strecke_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = regler_strecke_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mdlSampleHits[1] = 1;
    regler_strecke_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(regler_strecke_M, 10.0);
  regler_strecke_M->Timing.stepSize0 = 0.001;
  regler_strecke_M->Timing.stepSize1 = 0.001;

  /* external mode info */
  regler_strecke_M->Sizes.checksums[0] = (2899290560U);
  regler_strecke_M->Sizes.checksums[1] = (4012031924U);
  regler_strecke_M->Sizes.checksums[2] = (1932328512U);
  regler_strecke_M->Sizes.checksums[3] = (2447551299U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    regler_strecke_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(&rt_ExtModeInfo,
      &regler_strecke_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(&rt_ExtModeInfo, regler_strecke_M->Sizes.checksums);
    rteiSetTPtr(&rt_ExtModeInfo, rtmGetTPtr(regler_strecke_M));
  }

  regler_strecke_M->solverInfoPtr = (&regler_strecke_M->solverInfo);
  regler_strecke_M->Timing.stepSize = (0.001);
  rtsiSetFixedStepSize(&regler_strecke_M->solverInfo, 0.001);
  rtsiSetSolverMode(&regler_strecke_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  regler_strecke_M->ModelData.blockIO = ((void *) &regler_strecke_B);

  {
    int_T i;
    void *pVoidBlockIORegion;
    pVoidBlockIORegion = (void *)(&regler_strecke_B.Gain);
    for (i = 0; i < 4; i++) {
      ((real_T*)pVoidBlockIORegion)[i] = 0.0;
    }
  }

  /* parameters */
  regler_strecke_M->ModelData.defaultParam = ((real_T *) &regler_strecke_P);

  /* states (continuous) */
  {
    real_T *x = (real_T *) &regler_strecke_X;
    regler_strecke_M->ModelData.contStates = (x);
    (void) memset((char_T *)x,0,
                  sizeof(ContinuousStates_regler_strecke));
  }

  /* states (dwork) */
  regler_strecke_M->Work.dwork = ((void *) &regler_strecke_DWork);
  (void) memset((char_T *) &regler_strecke_DWork,0,
                sizeof(D_Work_regler_strecke));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    regler_strecke_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }
}

/* Model terminate function */
void regler_strecke_terminate(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) regler_strecke_P.AnalogOutput_RangeMode;
      parm.rangeidx = regler_strecke_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &regler_strecke_P.AnalogOutput_Channels,
                     &regler_strecke_P.AnalogOutput_FinalValue, &parm);
    }
  }

  /* External mode */
  rtExtModeShutdown(2);
}

/*========================================================================*
 * Start of GRT compatible call interface                                 *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  regler_strecke_output(tid);
}

void MdlUpdate(int_T tid)
{
  regler_strecke_update(tid);
}

void MdlInitializeSizes(void)
{
  regler_strecke_M->Sizes.numContStates = (1);/* Number of continuous states */
  regler_strecke_M->Sizes.numY = (0);  /* Number of model outputs */
  regler_strecke_M->Sizes.numU = (0);  /* Number of model inputs */
  regler_strecke_M->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  regler_strecke_M->Sizes.numSampTimes = (2);/* Number of sample times */
  regler_strecke_M->Sizes.numBlocks = (12);/* Number of blocks */
  regler_strecke_M->Sizes.numBlockIO = (4);/* Number of block outputs */
  regler_strecke_M->Sizes.numBlockPrms = (16);/* Sum of parameter "widths" */
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
  /* TransferFcn Block: '<S1>/first' */
  regler_strecke_X.first_CSTATE = 0.0;
}

void MdlStart(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) regler_strecke_P.AnalogOutput_RangeMode;
      parm.rangeidx = regler_strecke_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &regler_strecke_P.AnalogOutput_Channels,
                     &regler_strecke_P.AnalogOutput_InitialValue, &parm);
    }
  }

  MdlInitialize();
}

RT_MODEL_regler_strecke *regler_strecke(void)
{
  regler_strecke_initialize(1);
  return regler_strecke_M;
}

void MdlTerminate(void)
{
  regler_strecke_terminate();
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
