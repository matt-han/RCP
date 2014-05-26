/*
 * Statische_Kennlinie.c
 *
 * Real-Time Workshop code generation for Simulink model "Statische_Kennlinie.mdl".
 *
 * Model Version              : 1.22
 * Real-Time Workshop version : 7.0  (R2007b)  02-Aug-2007
 * C source code generated on : Mon May 26 13:42:09 2014
 */

#include "Statische_Kennlinie.h"
#include "Statische_Kennlinie_private.h"
#include <stdio.h>
#include "Statische_Kennlinie_dt.h"

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
BlockIO_Statische_Kennlinie Statische_Kennlinie_B;

/* Block states (auto storage) */
D_Work_Statische_Kennlinie Statische_Kennlinie_DWork;

/* Real-time model */
RT_MODEL_Statische_Kennlinie Statische_Kennlinie_M_;
RT_MODEL_Statische_Kennlinie *Statische_Kennlinie_M = &Statische_Kennlinie_M_;

/* Model output function */
void Statische_Kennlinie_output(int_T tid)
{
  /* local block i/o variables */
  real_T rtb_V_Step;
  real_T rtb_AnalogInput;

  {
    real_T currentTime;

    /* Step: '<Root>/4V_Step' */
    currentTime = Statische_Kennlinie_M->Timing.t[0];
    if (currentTime < Statische_Kennlinie_P.V_Step_Time) {
      rtb_V_Step = Statische_Kennlinie_P.V_Step_Y0;
    } else {
      rtb_V_Step = Statische_Kennlinie_P.V_Step_YFinal;
    }

    /* Step: '<Root>/1V_Step' */
    currentTime = Statische_Kennlinie_M->Timing.t[0];
    if (currentTime < Statische_Kennlinie_P.V_Step_Time_p) {
      currentTime = Statische_Kennlinie_P.V_Step_Y0_d;
    } else {
      currentTime = Statische_Kennlinie_P.V_Step_YFinal_a;
    }

    /* Sum: '<Root>/Add2' */
    Statische_Kennlinie_B.Add2 = rtb_V_Step + currentTime;

    /* Sum: '<Root>/Add' incorporates:
     *  Constant: '<Root>/Offset_OUT'
     */
    Statische_Kennlinie_B.Add = Statische_Kennlinie_B.Add2 +
      Statische_Kennlinie_P.Offset_OUT_Value;

    /* S-Function Block: <Root>/Analog Output */
    {
      {
        ANALOGIOPARM parm;
        parm.mode = (RANGEMODE) Statische_Kennlinie_P.AnalogOutput_RangeMode;
        parm.rangeidx = Statische_Kennlinie_P.AnalogOutput_VoltRange;
        RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                       &Statische_Kennlinie_P.AnalogOutput_Channels,
                       &Statische_Kennlinie_B.Add, &parm);
      }
    }

    /* S-Function Block: <Root>/Analog Input */
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) Statische_Kennlinie_P.AnalogInput_RangeMode;
      parm.rangeidx = Statische_Kennlinie_P.AnalogInput_VoltRange;
      RTBIO_DriverIO(0, ANALOGINPUT, IOREAD, 1,
                     &Statische_Kennlinie_P.AnalogInput_Channels,
                     &rtb_AnalogInput, &parm);
    }

    /* Sum: '<Root>/Add1' incorporates:
     *  Constant: '<Root>/Offset_IN'
     */
    Statische_Kennlinie_B.Add1 = rtb_AnalogInput +
      Statische_Kennlinie_P.Offset_IN_Value;
  }

  UNUSED_PARAMETER(tid);
}

/* Model update function */
void Statische_Kennlinie_update(int_T tid)
{
  /* Update absolute time for base rate */
  if (!(++Statische_Kennlinie_M->Timing.clockTick0))
    ++Statische_Kennlinie_M->Timing.clockTickH0;
  Statische_Kennlinie_M->Timing.t[0] = Statische_Kennlinie_M->Timing.clockTick0 *
    Statische_Kennlinie_M->Timing.stepSize0 +
    Statische_Kennlinie_M->Timing.clockTickH0 *
    Statische_Kennlinie_M->Timing.stepSize0 * 4294967296.0;

  {
    /* Update absolute timer for sample time: [0.001s, 0.0s] */
    if (!(++Statische_Kennlinie_M->Timing.clockTick1))
      ++Statische_Kennlinie_M->Timing.clockTickH1;
    Statische_Kennlinie_M->Timing.t[1] =
      Statische_Kennlinie_M->Timing.clockTick1 *
      Statische_Kennlinie_M->Timing.stepSize1 +
      Statische_Kennlinie_M->Timing.clockTickH1 *
      Statische_Kennlinie_M->Timing.stepSize1 * 4294967296.0;
  }

  UNUSED_PARAMETER(tid);
}

/* Model initialize function */
void Statische_Kennlinie_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));    /* initialize real-time model */
  (void) memset((char_T *)Statische_Kennlinie_M,0,
                sizeof(RT_MODEL_Statische_Kennlinie));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&Statische_Kennlinie_M->solverInfo,
                          &Statische_Kennlinie_M->Timing.simTimeStep);
    rtsiSetTPtr(&Statische_Kennlinie_M->solverInfo, &rtmGetTPtr
                (Statische_Kennlinie_M));
    rtsiSetStepSizePtr(&Statische_Kennlinie_M->solverInfo,
                       &Statische_Kennlinie_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&Statische_Kennlinie_M->solverInfo,
                          (&rtmGetErrorStatus(Statische_Kennlinie_M)));
    rtsiSetRTModelPtr(&Statische_Kennlinie_M->solverInfo, Statische_Kennlinie_M);
  }

  rtsiSetSimTimeStep(&Statische_Kennlinie_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&Statische_Kennlinie_M->solverInfo,"FixedStepDiscrete");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = Statische_Kennlinie_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mdlTsMap[1] = 1;
    Statische_Kennlinie_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    Statische_Kennlinie_M->Timing.sampleTimes =
      (&Statische_Kennlinie_M->Timing.sampleTimesArray[0]);
    Statische_Kennlinie_M->Timing.offsetTimes =
      (&Statische_Kennlinie_M->Timing.offsetTimesArray[0]);

    /* task periods */
    Statische_Kennlinie_M->Timing.sampleTimes[0] = (0.0);
    Statische_Kennlinie_M->Timing.sampleTimes[1] = (0.001);

    /* task offsets */
    Statische_Kennlinie_M->Timing.offsetTimes[0] = (0.0);
    Statische_Kennlinie_M->Timing.offsetTimes[1] = (0.0);
  }

  rtmSetTPtr(Statische_Kennlinie_M, &Statische_Kennlinie_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = Statische_Kennlinie_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mdlSampleHits[1] = 1;
    Statische_Kennlinie_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(Statische_Kennlinie_M, 5.0);
  Statische_Kennlinie_M->Timing.stepSize0 = 0.001;
  Statische_Kennlinie_M->Timing.stepSize1 = 0.001;

  /* external mode info */
  Statische_Kennlinie_M->Sizes.checksums[0] = (2271890356U);
  Statische_Kennlinie_M->Sizes.checksums[1] = (106342308U);
  Statische_Kennlinie_M->Sizes.checksums[2] = (3399039307U);
  Statische_Kennlinie_M->Sizes.checksums[3] = (3782860742U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    Statische_Kennlinie_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(&rt_ExtModeInfo,
      &Statische_Kennlinie_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(&rt_ExtModeInfo, Statische_Kennlinie_M->Sizes.checksums);
    rteiSetTPtr(&rt_ExtModeInfo, rtmGetTPtr(Statische_Kennlinie_M));
  }

  Statische_Kennlinie_M->solverInfoPtr = (&Statische_Kennlinie_M->solverInfo);
  Statische_Kennlinie_M->Timing.stepSize = (0.001);
  rtsiSetFixedStepSize(&Statische_Kennlinie_M->solverInfo, 0.001);
  rtsiSetSolverMode(&Statische_Kennlinie_M->solverInfo,
                    SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  Statische_Kennlinie_M->ModelData.blockIO = ((void *) &Statische_Kennlinie_B);

  {
    int_T i;
    void *pVoidBlockIORegion;
    pVoidBlockIORegion = (void *)(&Statische_Kennlinie_B.Add2);
    for (i = 0; i < 3; i++) {
      ((real_T*)pVoidBlockIORegion)[i] = 0.0;
    }
  }

  /* parameters */
  Statische_Kennlinie_M->ModelData.defaultParam = ((real_T *)
    &Statische_Kennlinie_P);

  /* states (dwork) */
  Statische_Kennlinie_M->Work.dwork = ((void *) &Statische_Kennlinie_DWork);
  (void) memset((char_T *) &Statische_Kennlinie_DWork,0,
                sizeof(D_Work_Statische_Kennlinie));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    Statische_Kennlinie_M->SpecialInfo.mappingInfo = (&dtInfo);
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
void Statische_Kennlinie_terminate(void)
{
  /* S-Function Block: <Root>/Analog Output */
  {
    {
      ANALOGIOPARM parm;
      parm.mode = (RANGEMODE) Statische_Kennlinie_P.AnalogOutput_RangeMode;
      parm.rangeidx = Statische_Kennlinie_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &Statische_Kennlinie_P.AnalogOutput_Channels,
                     &Statische_Kennlinie_P.AnalogOutput_FinalValue, &parm);
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
  Statische_Kennlinie_output(tid);
}

void MdlUpdate(int_T tid)
{
  Statische_Kennlinie_update(tid);
}

void MdlInitializeSizes(void)
{
  Statische_Kennlinie_M->Sizes.numContStates = (0);/* Number of continuous states */
  Statische_Kennlinie_M->Sizes.numY = (0);/* Number of model outputs */
  Statische_Kennlinie_M->Sizes.numU = (0);/* Number of model inputs */
  Statische_Kennlinie_M->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  Statische_Kennlinie_M->Sizes.numSampTimes = (2);/* Number of sample times */
  Statische_Kennlinie_M->Sizes.numBlocks = (11);/* Number of blocks */
  Statische_Kennlinie_M->Sizes.numBlockIO = (3);/* Number of block outputs */
  Statische_Kennlinie_M->Sizes.numBlockPrms = (16);/* Sum of parameter "widths" */
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
      parm.mode = (RANGEMODE) Statische_Kennlinie_P.AnalogOutput_RangeMode;
      parm.rangeidx = Statische_Kennlinie_P.AnalogOutput_VoltRange;
      RTBIO_DriverIO(0, ANALOGOUTPUT, IOWRITE, 1,
                     &Statische_Kennlinie_P.AnalogOutput_Channels,
                     &Statische_Kennlinie_P.AnalogOutput_InitialValue, &parm);
    }
  }

  MdlInitialize();
}

RT_MODEL_Statische_Kennlinie *Statische_Kennlinie(void)
{
  Statische_Kennlinie_initialize(1);
  return Statische_Kennlinie_M;
}

void MdlTerminate(void)
{
  Statische_Kennlinie_terminate();
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
