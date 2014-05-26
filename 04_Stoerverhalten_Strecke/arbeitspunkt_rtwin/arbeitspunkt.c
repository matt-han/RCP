/*
 * arbeitspunkt.c
 *
 * Real-Time Workshop code generation for Simulink model "arbeitspunkt.mdl".
 *
 * Model Version              : 1.23
 * Real-Time Workshop version : 7.0  (R2007b)  02-Aug-2007
 * C source code generated on : Mon May 26 14:40:29 2014
 */

#include "arbeitspunkt.h"
#include "arbeitspunkt_private.h"
#include <stdio.h>
#include "arbeitspunkt_dt.h"

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
BlockIO_arbeitspunkt arbeitspunkt_B;

/* Block states (auto storage) */
D_Work_arbeitspunkt arbeitspunkt_DWork;

/* Real-time model */
RT_MODEL_arbeitspunkt arbeitspunkt_M_;
RT_MODEL_arbeitspunkt *arbeitspunkt_M = &arbeitspunkt_M_;

/* Model output function */
void arbeitspunkt_output(int_T tid)
{
  /* local block i/o variables */
  real_T rtb_AnalogInput;

  {
    real_T currentTime;

    /* Step: '<Root>/4V_Step' */
    currentTime = arbeitspunkt_M->Timing.t[0];
    if (currentTime < arbeitspunkt_P.V_Step_Time) {
      arbeitspunkt_B.V_Step = arbeitspunkt_P.V_Step_Y0;
    } else {
      arbeitspunkt_B.V_Step = arbeitspunkt_P.V_Step_YFinal;
    }

    /* Sum: '<Root>/Add' incorporates:
     *  Constant: '<Root>/Offset_OUT'
     */
    arbeitspunkt_B.Add = arbeitspunkt_B.V_Step + arbeitspunkt_P.Offset_OUT_Value;

    /* S-Function Block: <Root>/Analog Output */
    {
      {
        ANALOGIOPARM parm;
        parm.mode = (RANGEMODE) arbeitspunkt_P.AnalogOutput_RangeMode;
        parm.rangeidx = arbeitspunkt_P.AnalogOutput_VoltRange;
        RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                       &arbeitspunkt_P.AnalogOutput_Channels,
                       &arbeitspunkt_B.Add, &parm);
      }
    }

    /* S-Function Block: <Root>/Analog Input */
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) arbeitspunkt_P.AnalogInput_RangeMode;
      parm.rangeidx = arbeitspunkt_P.AnalogInput_VoltRange;
      RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1,
                     &arbeitspunkt_P.AnalogInput_Channels, &rtb_AnalogInput,
                     &parm);
    }

    /* Sum: '<Root>/Add1' incorporates:
     *  Constant: '<Root>/Offset_IN'
     */
    arbeitspunkt_B.Add1 = rtb_AnalogInput + arbeitspunkt_P.Offset_IN_Value;
  }

  UNUSED_PARAMETER(tid);
}

/* Model update function */
void arbeitspunkt_update(int_T tid)
{
  /* Update absolute time for base rate */
  if (!(++arbeitspunkt_M->Timing.clockTick0))
    ++arbeitspunkt_M->Timing.clockTickH0;
  arbeitspunkt_M->Timing.t[0] = arbeitspunkt_M->Timing.clockTick0 *
    arbeitspunkt_M->Timing.stepSize0 + arbeitspunkt_M->Timing.clockTickH0 *
    arbeitspunkt_M->Timing.stepSize0 * 4294967296.0;

  {
    /* Update absolute timer for sample time: [0.001s, 0.0s] */
    if (!(++arbeitspunkt_M->Timing.clockTick1))
      ++arbeitspunkt_M->Timing.clockTickH1;
    arbeitspunkt_M->Timing.t[1] = arbeitspunkt_M->Timing.clockTick1 *
      arbeitspunkt_M->Timing.stepSize1 + arbeitspunkt_M->Timing.clockTickH1 *
      arbeitspunkt_M->Timing.stepSize1 * 4294967296.0;
  }

  UNUSED_PARAMETER(tid);
}

/* Model initialize function */
void arbeitspunkt_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));    /* initialize real-time model */
  (void) memset((char_T *)arbeitspunkt_M,0,
                sizeof(RT_MODEL_arbeitspunkt));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&arbeitspunkt_M->solverInfo,
                          &arbeitspunkt_M->Timing.simTimeStep);
    rtsiSetTPtr(&arbeitspunkt_M->solverInfo, &rtmGetTPtr(arbeitspunkt_M));
    rtsiSetStepSizePtr(&arbeitspunkt_M->solverInfo,
                       &arbeitspunkt_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&arbeitspunkt_M->solverInfo, (&rtmGetErrorStatus
      (arbeitspunkt_M)));
    rtsiSetRTModelPtr(&arbeitspunkt_M->solverInfo, arbeitspunkt_M);
  }

  rtsiSetSimTimeStep(&arbeitspunkt_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&arbeitspunkt_M->solverInfo,"FixedStepDiscrete");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = arbeitspunkt_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    arbeitspunkt_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    arbeitspunkt_M->Timing.sampleTimes =
      (&arbeitspunkt_M->Timing.sampleTimesArray[0]);
    arbeitspunkt_M->Timing.offsetTimes =
      (&arbeitspunkt_M->Timing.offsetTimesArray[0]);

    /* task periods */
    arbeitspunkt_M->Timing.sampleTimes[0] = (0.0);
    arbeitspunkt_M->Timing.sampleTimes[1] = (0.001);

    /* task offsets */
    arbeitspunkt_M->Timing.offsetTimes[0] = (0.0);
    arbeitspunkt_M->Timing.offsetTimes[1] = (0.0);
  }

  rtmSetTPtr(arbeitspunkt_M, &arbeitspunkt_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = arbeitspunkt_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mdlSampleHits[1] = 1;
    arbeitspunkt_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(arbeitspunkt_M, 10.0);
  arbeitspunkt_M->Timing.stepSize0 = 0.001;
  arbeitspunkt_M->Timing.stepSize1 = 0.001;

  /* external mode info */
  arbeitspunkt_M->Sizes.checksums[0] = (51356583U);
  arbeitspunkt_M->Sizes.checksums[1] = (1228941243U);
  arbeitspunkt_M->Sizes.checksums[2] = (1622391598U);
  arbeitspunkt_M->Sizes.checksums[3] = (3849823737U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    arbeitspunkt_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(&rt_ExtModeInfo,
      &arbeitspunkt_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(&rt_ExtModeInfo, arbeitspunkt_M->Sizes.checksums);
    rteiSetTPtr(&rt_ExtModeInfo, rtmGetTPtr(arbeitspunkt_M));
  }

  arbeitspunkt_M->solverInfoPtr = (&arbeitspunkt_M->solverInfo);
  arbeitspunkt_M->Timing.stepSize = (0.001);
  rtsiSetFixedStepSize(&arbeitspunkt_M->solverInfo, 0.001);
  rtsiSetSolverMode(&arbeitspunkt_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  arbeitspunkt_M->ModelData.blockIO = ((void *) &arbeitspunkt_B);

  {
    int_T i;
    void *pVoidBlockIORegion;
    pVoidBlockIORegion = (void *)(&arbeitspunkt_B.V_Step);
    for (i = 0; i < 3; i++) {
      ((real_T*)pVoidBlockIORegion)[i] = 0.0;
    }
  }

  /* parameters */
  arbeitspunkt_M->ModelData.defaultParam = ((real_T *) &arbeitspunkt_P);

  /* states (dwork) */
  arbeitspunkt_M->Work.dwork = ((void *) &arbeitspunkt_DWork);
  (void) memset((char_T *) &arbeitspunkt_DWork,0,
                sizeof(D_Work_arbeitspunkt));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    arbeitspunkt_M->SpecialInfo.mappingInfo = (&dtInfo);
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
void arbeitspunkt_terminate(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) arbeitspunkt_P.AnalogOutput_RangeMode;
      parm.rangeidx = arbeitspunkt_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &arbeitspunkt_P.AnalogOutput_Channels,
                     &arbeitspunkt_P.AnalogOutput_FinalValue, &parm);
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
  arbeitspunkt_output(tid);
}

void MdlUpdate(int_T tid)
{
  arbeitspunkt_update(tid);
}

void MdlInitializeSizes(void)
{
  arbeitspunkt_M->Sizes.numContStates = (0);/* Number of continuous states */
  arbeitspunkt_M->Sizes.numY = (0);    /* Number of model outputs */
  arbeitspunkt_M->Sizes.numU = (0);    /* Number of model inputs */
  arbeitspunkt_M->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  arbeitspunkt_M->Sizes.numSampTimes = (2);/* Number of sample times */
  arbeitspunkt_M->Sizes.numBlocks = (9);/* Number of blocks */
  arbeitspunkt_M->Sizes.numBlockIO = (3);/* Number of block outputs */
  arbeitspunkt_M->Sizes.numBlockPrms = (13);/* Sum of parameter "widths" */
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
      parm.mode = (RANGEMODE) arbeitspunkt_P.AnalogOutput_RangeMode;
      parm.rangeidx = arbeitspunkt_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &arbeitspunkt_P.AnalogOutput_Channels,
                     &arbeitspunkt_P.AnalogOutput_InitialValue, &parm);
    }
  }

  MdlInitialize();
}

RT_MODEL_arbeitspunkt *arbeitspunkt(void)
{
  arbeitspunkt_initialize(1);
  return arbeitspunkt_M;
}

void MdlTerminate(void)
{
  arbeitspunkt_terminate();
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
