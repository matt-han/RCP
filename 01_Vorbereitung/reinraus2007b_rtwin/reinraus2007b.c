/*
 * reinraus2007b.c
 *
 * Real-Time Workshop code generation for Simulink model "reinraus2007b.mdl".
 *
 * Model Version              : 1.12
 * Real-Time Workshop version : 7.0  (R2007b)  02-Aug-2007
 * C source code generated on : Mon May 12 14:41:13 2014
 */

#include "reinraus2007b.h"
#include "reinraus2007b_private.h"
#include <stdio.h>
#include "reinraus2007b_dt.h"

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
BlockIO_reinraus2007b reinraus2007b_B;

/* Block states (auto storage) */
D_Work_reinraus2007b reinraus2007b_DWork;

/* Real-time model */
RT_MODEL_reinraus2007b reinraus2007b_M_;
RT_MODEL_reinraus2007b *reinraus2007b_M = &reinraus2007b_M_;
static void rate_scheduler(void);

/*
 * This function updates active task flag for each subrate.
 * The function must be is called at model base rate, hence the
 * generated code self-manages all its subrates.
 */
static void rate_scheduler(void)
{
  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  if (++reinraus2007b_M->Timing.TaskCounters.TID[2] == 1000) {/* Sample time: [1.0s, 0.0s] */
    reinraus2007b_M->Timing.TaskCounters.TID[2] = 0;
  }

  reinraus2007b_M->Timing.sampleHits[2] =
    (reinraus2007b_M->Timing.TaskCounters.TID[2] == 0);
}

/* Model output function */
void reinraus2007b_output(int_T tid)
{
  /* local block i/o variables */
  real_T rtb_Clock;

  {
    real_T currentTime;

    /* S-Function Block: <Root>/Analog Input */
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) reinraus2007b_P.AnalogInput_RangeMode;
      parm.rangeidx = reinraus2007b_P.AnalogInput_VoltRange;
      RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1,
                     &reinraus2007b_P.AnalogInput_Channels,
                     &reinraus2007b_B.AnalogInput, &parm);
    }

    /* Step: '<S1>/Step' */
    currentTime = reinraus2007b_M->Timing.t[0];
    if (currentTime < reinraus2007b_P.Step_Time) {
      currentTime = reinraus2007b_P.Step_Y0;
    } else {
      currentTime = reinraus2007b_P.Step_YFinal;
    }

    /* Clock: '<S1>/Clock' */
    rtb_Clock = reinraus2007b_M->Timing.t[0];

    /* Sum: '<S1>/Output' incorporates:
     *  Constant: '<S1>/Constant'
     *  Constant: '<S1>/Constant1'
     *  Product: '<S1>/Product'
     *  Sum: '<S1>/Sum'
     */
    reinraus2007b_B.Output = (rtb_Clock - reinraus2007b_P.Constant_Value) *
      currentTime + reinraus2007b_P.Constant1_Value;
    if (reinraus2007b_M->Timing.TaskCounters.TID[2] == 0) {
      /* ZeroOrderHold: '<Root>/Zero-Order Hold' */
      reinraus2007b_B.ZeroOrderHold = reinraus2007b_B.Output;
    }

    /* S-Function Block: <Root>/Analog Output */
    {
      {
        ANALOGIOPARM parm;
        parm.mode = (RANGEMODE) reinraus2007b_P.AnalogOutput_RangeMode;
        parm.rangeidx = reinraus2007b_P.AnalogOutput_VoltRange;
        RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                       &reinraus2007b_P.AnalogOutput_Channels,
                       &reinraus2007b_B.ZeroOrderHold, &parm);
      }
    }

    if (reinraus2007b_M->Timing.TaskCounters.TID[2] == 0) {
    }
  }

  UNUSED_PARAMETER(tid);
}

/* Model update function */
void reinraus2007b_update(int_T tid)
{
  /* Update absolute time for base rate */
  if (!(++reinraus2007b_M->Timing.clockTick0))
    ++reinraus2007b_M->Timing.clockTickH0;
  reinraus2007b_M->Timing.t[0] = reinraus2007b_M->Timing.clockTick0 *
    reinraus2007b_M->Timing.stepSize0 + reinraus2007b_M->Timing.clockTickH0 *
    reinraus2007b_M->Timing.stepSize0 * 4294967296.0;

  {
    /* Update absolute timer for sample time: [0.001s, 0.0s] */
    if (!(++reinraus2007b_M->Timing.clockTick1))
      ++reinraus2007b_M->Timing.clockTickH1;
    reinraus2007b_M->Timing.t[1] = reinraus2007b_M->Timing.clockTick1 *
      reinraus2007b_M->Timing.stepSize1 + reinraus2007b_M->Timing.clockTickH1 *
      reinraus2007b_M->Timing.stepSize1 * 4294967296.0;
  }

  if (reinraus2007b_M->Timing.TaskCounters.TID[2] == 0) {
    /* Update absolute timer for sample time: [1.0s, 0.0s] */
    if (!(++reinraus2007b_M->Timing.clockTick2))
      ++reinraus2007b_M->Timing.clockTickH2;
    reinraus2007b_M->Timing.t[2] = reinraus2007b_M->Timing.clockTick2 *
      reinraus2007b_M->Timing.stepSize2 + reinraus2007b_M->Timing.clockTickH2 *
      reinraus2007b_M->Timing.stepSize2 * 4294967296.0;
  }

  rate_scheduler();
  UNUSED_PARAMETER(tid);
}

/* Model initialize function */
void reinraus2007b_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));    /* initialize real-time model */
  (void) memset((char_T *)reinraus2007b_M,0,
                sizeof(RT_MODEL_reinraus2007b));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&reinraus2007b_M->solverInfo,
                          &reinraus2007b_M->Timing.simTimeStep);
    rtsiSetTPtr(&reinraus2007b_M->solverInfo, &rtmGetTPtr(reinraus2007b_M));
    rtsiSetStepSizePtr(&reinraus2007b_M->solverInfo,
                       &reinraus2007b_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&reinraus2007b_M->solverInfo, (&rtmGetErrorStatus
      (reinraus2007b_M)));
    rtsiSetRTModelPtr(&reinraus2007b_M->solverInfo, reinraus2007b_M);
  }

  rtsiSetSimTimeStep(&reinraus2007b_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&reinraus2007b_M->solverInfo,"FixedStepDiscrete");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = reinraus2007b_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    mdlTsMap[2] = 2;
    reinraus2007b_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    reinraus2007b_M->Timing.sampleTimes =
      (&reinraus2007b_M->Timing.sampleTimesArray[0]);
    reinraus2007b_M->Timing.offsetTimes =
      (&reinraus2007b_M->Timing.offsetTimesArray[0]);

    /* task periods */
    reinraus2007b_M->Timing.sampleTimes[0] = (0.0);
    reinraus2007b_M->Timing.sampleTimes[1] = (0.001);
    reinraus2007b_M->Timing.sampleTimes[2] = (1.0);

    /* task offsets */
    reinraus2007b_M->Timing.offsetTimes[0] = (0.0);
    reinraus2007b_M->Timing.offsetTimes[1] = (0.0);
    reinraus2007b_M->Timing.offsetTimes[2] = (0.0);
  }

  rtmSetTPtr(reinraus2007b_M, &reinraus2007b_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = reinraus2007b_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mdlSampleHits[1] = 1;
    mdlSampleHits[2] = 1;
    reinraus2007b_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(reinraus2007b_M, 20.0);
  reinraus2007b_M->Timing.stepSize0 = 0.001;
  reinraus2007b_M->Timing.stepSize1 = 0.001;
  reinraus2007b_M->Timing.stepSize2 = 1.0;

  /* external mode info */
  reinraus2007b_M->Sizes.checksums[0] = (1501396963U);
  reinraus2007b_M->Sizes.checksums[1] = (4125846119U);
  reinraus2007b_M->Sizes.checksums[2] = (772950504U);
  reinraus2007b_M->Sizes.checksums[3] = (3035179523U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    reinraus2007b_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(&rt_ExtModeInfo,
      &reinraus2007b_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(&rt_ExtModeInfo, reinraus2007b_M->Sizes.checksums);
    rteiSetTPtr(&rt_ExtModeInfo, rtmGetTPtr(reinraus2007b_M));
  }

  reinraus2007b_M->solverInfoPtr = (&reinraus2007b_M->solverInfo);
  reinraus2007b_M->Timing.stepSize = (0.001);
  rtsiSetFixedStepSize(&reinraus2007b_M->solverInfo, 0.001);
  rtsiSetSolverMode(&reinraus2007b_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  reinraus2007b_M->ModelData.blockIO = ((void *) &reinraus2007b_B);

  {
    int_T i;
    void *pVoidBlockIORegion;
    pVoidBlockIORegion = (void *)(&reinraus2007b_B.AnalogInput);
    for (i = 0; i < 3; i++) {
      ((real_T*)pVoidBlockIORegion)[i] = 0.0;
    }
  }

  /* parameters */
  reinraus2007b_M->ModelData.defaultParam = ((real_T *) &reinraus2007b_P);

  /* states (dwork) */
  reinraus2007b_M->Work.dwork = ((void *) &reinraus2007b_DWork);
  (void) memset((char_T *) &reinraus2007b_DWork,0,
                sizeof(D_Work_reinraus2007b));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    reinraus2007b_M->SpecialInfo.mappingInfo = (&dtInfo);
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
void reinraus2007b_terminate(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) reinraus2007b_P.AnalogOutput_RangeMode;
      parm.rangeidx = reinraus2007b_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &reinraus2007b_P.AnalogOutput_Channels,
                     &reinraus2007b_P.AnalogOutput_FinalValue, &parm);
    }
  }

  /* External mode */
  rtExtModeShutdown(3);
}

/*========================================================================*
 * Start of GRT compatible call interface                                 *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  reinraus2007b_output(tid);
}

void MdlUpdate(int_T tid)
{
  reinraus2007b_update(tid);
}

void MdlInitializeSizes(void)
{
  reinraus2007b_M->Sizes.numContStates = (0);/* Number of continuous states */
  reinraus2007b_M->Sizes.numY = (0);   /* Number of model outputs */
  reinraus2007b_M->Sizes.numU = (0);   /* Number of model inputs */
  reinraus2007b_M->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  reinraus2007b_M->Sizes.numSampTimes = (3);/* Number of sample times */
  reinraus2007b_M->Sizes.numBlocks = (12);/* Number of blocks */
  reinraus2007b_M->Sizes.numBlockIO = (3);/* Number of block outputs */
  reinraus2007b_M->Sizes.numBlockPrms = (13);/* Sum of parameter "widths" */
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
}

void MdlStart(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) reinraus2007b_P.AnalogOutput_RangeMode;
      parm.rangeidx = reinraus2007b_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &reinraus2007b_P.AnalogOutput_Channels,
                     &reinraus2007b_P.AnalogOutput_InitialValue, &parm);
    }
  }

  MdlInitialize();
}

RT_MODEL_reinraus2007b *reinraus2007b(void)
{
  reinraus2007b_initialize(1);
  return reinraus2007b_M;
}

void MdlTerminate(void)
{
  reinraus2007b_terminate();
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
