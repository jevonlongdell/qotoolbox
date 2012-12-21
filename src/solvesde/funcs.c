#include <math.h>
#include "llnltyps.h"
#define PI (3.14159265358979)
#define NFUNCS 7

int     fatal_error(char *msg);

integer fpcheck[NFUNCS] = {0, 4, 5, 2, 7, 2, 3};

void    func0(integer n, real * params, real x, real * yr, real * yi)
{
    *yr = 1.0;
    *yi = 0.0;
    return;
}

void    func1(integer n, real * params, real x, real * yr, real * yi)
/*
  Generates a Gaussian pulse,
   params[1] = Amplitude of pulse
   params[2] = Phase of pulse (radians)
   params[3] = Position of pulse
   params[4] = Width of pulse
 */
{
    real    temp;
    if (n != fpcheck[1]) {
        fatal_error("Error in calling func1.\n");
    }
    temp = (x - params[3]) / params[4];
    temp = params[1] * exp(-0.5 * temp * temp);
    *yr = temp * cos(params[2]);
    *yi = temp * sin(params[2]);
}

void    func2(integer n, real * params, real x, real * yr, real * yi)
/*
  Generates a Gaussian pulse with complex exponential modulation
   params[1] = Amplitude of pulse
   params[2] = Phase of pulse (radians)
   params[3] = Position of pulse
   params[4] = Width of pulse
   params[5] = Angular frequency of oscillation
 */

{
    real    temp;
    if (n != fpcheck[2]) {
        fatal_error("Error in calling func2.\n");
    }
    temp = (x - params[3]) / params[4];
    temp = params[1] * exp(-0.5 * temp * temp);
    *yr = temp * cos(params[2] - params[5] * x);
    *yi = temp * sin(params[2] - params[5] * x);
}

void    func3(integer n, real * params, real x, real * yr, real * yi)
/*
   Generates a complex exponential
    params[1] = Real part of complex angular frequency
    params[2] = Imaginary part of complex angular frequency
 */

{
    real    temp;
    if (n != fpcheck[3]) {
        fatal_error("Error in calling func3.\n");
    }
    temp = exp(params[1] * x);
    *yr = temp * cos(params[2] * x);
    *yi = temp * sin(params[2] * x);
}

void    func4(integer n, real * params, real x, real * yr, real * yi)
/*
   Generates a complex exponential of unit amplitude at t=0 within a flat top pulse
    with raised cosinusoidal rise and fall

    params[1] = Phase of oscillation
    params[2] = Real part of complex angular frequency
    params[3] = Imaginary part of complex angular frequency
    params[4] = Start time of rectangular pulse
    params[5] = Rise time of rectangular pulse
    params[6] = End time of rectangular pulse
    params[7] = Fall time of rectangular pulse
 */
{
    real    temp, ampl;
    if (n != fpcheck[4]) {
        fatal_error("Error in calling func4.\n");
    }
    if ((x >= params[4] - 0.5 * params[5]) && (x <= params[6] + 0.5 * params[7])) {
        temp = exp(params[2] * x);
        *yr = temp * cos(params[3] * x + params[1]);
        *yi = temp * sin(params[3] * x + params[1]);
        if (fabs(x - params[4]) <= 0.5 * params[5]) {
            ampl = sin(PI * (x - params[4]) / params[5]);
            ampl = 0.5 * (ampl + 1.0);
            *yr *= ampl;
            *yi *= ampl;
        } else if (fabs(x - params[6]) <= 0.5 * params[7]) {
            ampl = -sin(PI * (x - params[6]) / params[7]);
            ampl = 0.5 * (ampl + 1.0);
            *yr *= ampl;
            *yi *= ampl;
        }
    } else {
        *yr = *yi = 0;
    }
}

void    func5(integer n, real * params, real x, real * yr, real * yi)
/*
   Generates the amplitude damping function kappa1 given by

   kappa1 = kappa * exp(kappa t) / (exp(kappa t) + exp(-kappa t))

    params[1] = Value of kappa
    params[2] = Flag, which is 1 for sqrt(kappa1), 2 for sqrt(kappa2), 3 for sqrt(kappa1 * kappa2)
                               4 for kappa1,       5 for kappa2,       6 for kappa1*kappa2
    
    
 */
{
    real    temp, ampl;
    integer choice;
    if (n != fpcheck[5]) {
        fatal_error("Error in calling func5.\n");
    }

    choice = params[2];
    switch (choice)
    {
    case 1:	
       temp = exp(params[1] * x);
       *yr = sqrt(params[1] * temp / (temp + 1/temp));
       break;
    case 2:
       temp = exp(-params[1] * x);
       *yr = sqrt(params[1] * temp / (temp + 1/temp));
       break;
    case 3:
       temp = exp(params[1] * x);
       *yr = params[1] / (temp + 1/temp);
       break;
    case 4:	
       temp = exp(params[1] * x);
       *yr = params[1] * temp / (temp + 1/temp);
       break;
    case 5:
       temp = exp(-params[1] * x);
       *yr = params[1] * temp / (temp + 1/temp);
       break;
    case 6:
       temp = exp(params[1] * x);
       *yr = params[1] / (temp + 1/temp);
       *yr = (*yr)*(*yr);
       break;
    }   
    *yi = 0;
}

void    func6(integer n, real * params, real x, real * yr, real * yi)
/*
   Generates the amplitude damping function kappa1 given by

   kappa1 = kappa / (exp(-2*kappa t) - 1)

    params[1] = Value of kappa
    params[2] = Flag, which is 1 for sqrt(kappa1), 2 for sqrt(kappa2), 3 for sqrt(kappa1 * kappa2)
                               4 for kappa1,       5 for kappa2,       6 for kappa1*kappa2
    
    
 */
{
    real    temp, ampl;
    integer choice;
    if (n != fpcheck[6]) {
        fatal_error("Error in calling func6.\n");
    }

    choice = params[3];
    if (x > params[2]) x = params[2];
    switch (choice)
    {
    case 1:	
       temp = exp(-2*params[1] * x);
       *yr = sqrt(params[1] / (temp - 1.0));
       break;
    case 2:
       *yr = sqrt(params[1]);
       break;
    case 3:
       temp = exp(-2*params[1] * x);
       *yr = params[1] / sqrt(temp - 1.0);
       break;
    case 4:	
       temp = exp(-2*params[1] * x);
       *yr = params[1] / (temp - 1.0);
       break;
    case 5:
       *yr = params[1];
       break;
    case 6:
       temp = exp(-2*params[1] * x);
       *yr = params[1]*params[1] / (temp - 1.0);
       break;
    }   
    *yi = 0;
}

void    (*funclist[NFUNCS]) (integer, real *, real, real *, real *) = {
    func0, func1, func2, func3, func4, func5, func6
};
