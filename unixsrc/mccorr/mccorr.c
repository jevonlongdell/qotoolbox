/*
  Solution of system of differential equations with sparse time-dependent
  coefficient matrices and Quantum Monte Carlo algorithm. Experimental 
  version for calculating correlations.

%% version 0.14 10-Mar-1999
%%
    Copyright (C) 1996-1999  Sze M. Tan

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

    Address: Physics Department, The University of Auckland, New Zealand
    Email: s.tan@auckland.ac.nz

  Date:		
    4 March 1996	Modified from odesolve for time-independent coefficients
    6 March 1996	Wrote Gaussian pulse routines
    24 April 1996	Modifications for quantum Monte Carlo
    20 June 1996	Modifications to compute expectation values
    27 Nov  1998	Replaced Numerical Recipes by RANLIB and CVODE
    28 Sep  1999	Added optional inputs to ODE solvers
*/

#define  DEBUG
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include "ranlib.h"
#include "llnltyps.h"
#include "cvode.h"
#include "cvdiag.h"
#include "vector.h"

#define PI (3.14159265358979)
#define RELTOL (1.0e-6)
#define ABSTOL (1.0e-6)
#define THRESHTOL (1.0e-3)

#define Ith(v,i)	N_VIth(v,i-1)
#define EXTRA 1
#define NHASH 69

char    errmsg[240];
static int progress;

int     fatal_error(char *msg)
{
    FILE   *fp;
    struct tm *newtime;
    time_t  long_time;

    time(&long_time);           /* Get time as long integer. */
    newtime = localtime(&long_time);  /* Convert to local time. */
    fp = fopen("failure.qo", "w");
    fprintf(fp, "FAIL\nSOLVEMC failed at %s\n", asctime(newtime));
    fprintf(fp, "%s\n", msg);
    fprintf(stderr, "SOLVEMC FAILED.\n%s", msg);
    fclose(fp);
    exit(1);
    return 0;
}

/* Routines for allocating and freeing vectors */

real   *vector(integer low, integer high)
{
    real   *temp;
    temp = (real *) calloc(high - low + 1 + EXTRA, sizeof(real));
    if (temp == NULL) {
        fatal_error("Error in vector allocation.\n");
    }
    return (temp - low + EXTRA);
}

integer *ivector(integer low, integer high)
{
    integer *temp;
    temp = (integer *) calloc(high - low + 1 + EXTRA, sizeof(integer));
    if (temp == NULL) {
        fatal_error("Error in ivector allocation.\n");
    }
    return (temp - low + EXTRA);
}

void    free_vector(real * p, integer low, integer high)
{
    free(p + low - EXTRA);
}

void    free_ivector(integer * p, integer low, integer high)
{
    free(p + low - EXTRA);
}

real    ropt[OPT_SIZE];
long int iopt[OPT_SIZE];

static FILE *fp, *op, *cp;
integer kount;
integer N, Rnterms, Cnterms, Onterms, ntraj, ftraj;

struct FS {                     /* Define the function series structure */
    integer N;                  /* Size of sparse matrices */
    integer nterms;             /* Number of terms in series */
    integer *nnz;               /* Array storing number of non-zeros in each
                                 * sparse matrix */
    integer **rowptrp;          /* Sparse matrix pointers */
    integer **ninrowp;
    integer **colindxp;
    integer *ftypes;            /* Function types associated with terms */
    integer *fparamsn;          /* Number of parameters for each term */
    real  **fparamsp;           /* Function parameters */
    real  **Mrealp;             /* Real parts of sparse matrices */
    real  **Mimagp;             /* Imaginary parts of sparse matrices */
};

static real reltol, abstol;
static struct FS RHS;
static struct FS *collapses;
static integer ncollapses;
static struct FS *opers;
static integer nopers;

static integer clrecflag;
static N_Vector tlist, ystart, y, corrstart, corr, abstolv;
static real *Cprobs;
static N_Vector *opr, *opi, q;
static long iseed;
static integer ntimes;
static void *cvode_mem, *cvode_mem_corr;
static integer method, itertype, nabstol;
static real reltol, abstol;
static void *abstolp;

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
    if (n != 4) {
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
    if (n != 5) {
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
    if (n != 2) {
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
    if (n != 7) {
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

void    (*funclist[5]) (integer, real *, real, real *, real *) = {
    func0, func1, func2, func3, func4
};
integer fpcheck[5] = {0, 4, 5, 2, 7};

void    FSmul(struct FS * S, real x, real y[], real Sy[])
{
    integer i, j, k, l, N, base, ft;
    real    sumr, sumi;
    integer nparams;
    real   *fparams;
    real   *Mreal, *Mimag;

    N = S->N;
    for (i = 1; i <= S->N; i++) {
        sumr = sumi = 0.0;
        for (l = 1; l <= S->nterms; l++) {
            real    fr, fi, tr, ti;
            void    (*func) (integer, real *, real, real *, real *);
            Mreal = S->Mrealp[l];
            Mimag = S->Mimagp[l];
            fparams = S->fparamsp[l];
            nparams = S->fparamsn[l];
            base = S->rowptrp[l][i];
            func = funclist[ft = S->ftypes[l]];
            for (j = 1; j <= S->ninrowp[l][i]; j++, base++) {
                k = S->colindxp[l][base];
                tr = Mreal[base] * y[k] - Mimag[base] * y[N + k];
                ti = Mreal[base] * y[N + k] + Mimag[base] * y[k];
                if (ft) {
                    (*func) (nparams, fparams, x, &fr, &fi);
                    sumr += tr * fr - ti * fi;
                    sumi += tr * fi + ti * fr;
                } else {
                    sumr += tr;
                    sumi += ti;
                }
            }
        }
        Sy[i] = sumr;
        Sy[N + i] = sumi;
    }
}

static void derivs(integer N, real x, N_Vector y, N_Vector dydx, void *f_data)
{
    N_VLENGTH(dydx) = N_VLENGTH(y);
    FSmul(&RHS, x, N_VDATA(y) - 1, N_VDATA(dydx) - 1);
}

real    norm2(real * y, integer N)
/* Calculates square of norm of the complex vector y */
{
    integer i;
    double  sum = 0.0;
    real   *yp1, *yp2;
    yp1 = &y[1];
    yp2 = &y[N + 1];
    for (i = 1; i <= N; i++) {
        sum += (*yp1) * (*yp1) + (*yp2) * (*yp2);
        yp1++;
        yp2++;
    }
    return sum;
}

void    inprod(real x[], real y[], integer N, real * ipr, real * ipi)
/* Calculates inner product of the complex vector y */
{
    integer i;
    double  sumr = 0.0, sumi = 0.0;
    real   *xpr, *xpi, *ypr, *ypi;
    xpr = &x[1];
    xpi = &x[N + 1];
    ypr = &y[1];
    ypi = &y[N + 1];
    for (i = 1; i <= N; i++) {
        sumr += (*xpr) * (*ypr) + (*xpi) * (*ypi);
        sumi += (*xpr) * (*ypi) - (*xpi) * (*ypr);
        xpr++;
        xpi++;
        ypr++;
        ypi++;
    }
    *ipr = sumr;
    *ipi = sumi;
}

void    file2FS(FILE * fp, struct FS * S)
{
    integer i, j, l, code, N, nterms;

    /* Allocate memory for sparse matrix data structures */

    N = S->N;
    nterms = S->nterms;
    S->nnz = (integer *) calloc(nterms, sizeof(integer));
    S->rowptrp = (integer **) calloc(nterms, sizeof(integer *));
    S->ninrowp = (integer **) calloc(nterms, sizeof(integer *));
    S->colindxp = (integer **) calloc(nterms, sizeof(integer *));
    S->ftypes = (integer *) calloc(nterms, sizeof(integer));
    S->fparamsn = (integer *) calloc(nterms, sizeof(integer));
    S->fparamsp = (real **) calloc(nterms, sizeof(real *));
    S->Mrealp = (real **) calloc(nterms, sizeof(real *));
    S->Mimagp = (real **) calloc(nterms, sizeof(real *));

    /* Check for invalid allocation */

    if (S->nnz == NULL || S->rowptrp == NULL || S->ninrowp == NULL ||
        S->colindxp == NULL || S->ftypes == NULL ||
        S->fparamsn == NULL || S->fparamsp == NULL ||
        S->Mrealp == NULL || S->Mimagp == NULL) {
        fatal_error("Allocation error in file2FS.\n");
    }
    /* Adjust base pointers for Fortran-style indexing */

    S->nnz--;
    S->rowptrp--;
    S->ninrowp--;
    S->colindxp--;
    S->ftypes--;
    S->fparamsn--;
    S->fparamsp--;
    S->Mrealp--;
    S->Mimagp--;

    /* Read in the data structures from the input file */

    for (l = 1; l <= nterms; l++) {
        fread(&code, sizeof(integer), 1, fp);
        if (code != 2002) {
            sprintf(errmsg, "Invalid code in file2FS, expected %d, found %d.\n", 2002, code);
            fatal_error(errmsg);
        }
        fread(&j, sizeof(integer), 1, fp);
        if (j != N) {
            sprintf(errmsg, "Inconsistent matrix size passed to file2FS.\n");
            fatal_error(errmsg);
        }
        fread(&S->nnz[l], sizeof(integer), 1, fp);
        S->rowptrp[l] = ivector(1, N);
        S->ninrowp[l] = ivector(1, N);
        S->colindxp[l] = ivector(1, S->nnz[l]);
        S->Mrealp[l] = vector(1, S->nnz[l]);
        S->Mimagp[l] = vector(1, S->nnz[l]);
        fread(&S->colindxp[l][1], sizeof(integer), S->nnz[l], fp);
        j = 1;
        for (i = 1; i <= N; i++) {
            S->rowptrp[l][i] = j;
            S->ninrowp[l][i] = 0;
            while (j <= S->nnz[l] && S->colindxp[l][j] == i) {
                j++;
                S->ninrowp[l][i]++;
            }
        }
        fread(&S->colindxp[l][1], sizeof(integer), S->nnz[l], fp);
        fread(&S->Mrealp[l][1], sizeof(real), S->nnz[l], fp);
        fread(&S->Mimagp[l][1], sizeof(real), S->nnz[l], fp);
        /* Read info about which function to use */
        fread(&S->ftypes[l], sizeof(integer), 1, fp);
        fread(&S->fparamsn[l], sizeof(integer), 1, fp);
        if (S->fparamsn[l] != fpcheck[S->ftypes[l]]) {
            sprintf(errmsg, "Incorrect number of arguments for function %d.\n",
                    S->ftypes[l]);
            fatal_error(errmsg);
        }
        S->fparamsp[l] = vector(1, S->fparamsn[l]);
        /* Read in function parameters */
        fread(&S->fparamsp[l][1], sizeof(real), S->fparamsn[l], fp);
    }
}

void    operCorrAccum(real pl[], real corr1[], real q[], integer N, real t, integer indx)
{
    integer i;
    real    xnorm, ipr, ipi;
    xnorm = norm2(pl, N);
    for (i = 1; i <= nopers; i++) {
        FSmul(&opers[i], t, corr1, q);
        inprod(corr1, q, N, &ipr, &ipi);
        Ith(opr[i], indx) += ipr / xnorm;
        Ith(opi[i], indx) += ipi / xnorm;
    }
}

real    docollapse(real tl, real nl, real tr, real nr, real thresh)
/* Find the time of collapse, update the wave function and restart the integrator */
{
    integer j, k, flag;
    real    tc, nc, temp, sum, t;

    for (;;) {
        tc = tl + log(nl / thresh) / log(nl / nr) * (tr - tl);
        flag = CVode1(cvode_mem, tc, y, &t, NORMAL);
        if (flag != SUCCESS) {
            sprintf(errmsg, "CVode1 failed, flag=%d.\n", flag);
            fatal_error(errmsg);
        }
        nc = norm2(N_VDATA(y) - 1, N);
        if (fabs(thresh - nc) < THRESHTOL * fabs(thresh))
            break;
        else if (nc < thresh) {
            nr = nc;
            tr = tc;
        } else {
            nl = nc;
            tl = tc;
        }
    }
    /* Collapse occurs at tc, apply appropriate operator and restart
     * integrator */
    /* Propagate correlation to collapse time */
    flag = CVode1(cvode_mem_corr, tc, corr, &t, NORMAL);
    if (flag != SUCCESS) {
        sprintf(errmsg, "CVode1 failed, flag=%d.\n", flag);
        fatal_error(errmsg);
    }
    /* Decide which collapse occured */
    sum = 0.0;
    for (j = 1; j <= ncollapses; j++) {
        FSmul(&collapses[j], tc, N_VDATA(y) - 1, N_VDATA(q) - 1);
        sum += (Cprobs[j] = norm2(N_VDATA(q) - 1, N));
    }
    thresh = genunf(0.0, 1.0);  /* To determine which collapse occured */
    for (j = 1; j <= ncollapses; j++) {
        thresh -= Cprobs[j] / sum;
        if (thresh <= 0)
            break;
    }
    if (clrecflag) {            /* Write out classical record */
        fwrite(&tc, sizeof(real), 1, cp);
        temp = j;
        fwrite(&temp, sizeof(real), 1, cp);
    }
    /* Apply the collapse and normalize */
    FSmul(&collapses[j], tc, N_VDATA(y) - 1, N_VDATA(q) - 1);
    sum = sqrt(norm2(N_VDATA(q) - 1, N));
    for (k = 1; k <= 2 * N; k++)
        Ith(y, k) = Ith(q, k) / sum;
    /* Apply collapse to correlation */
    FSmul(&collapses[j], tc, N_VDATA(corr) - 1, N_VDATA(q) - 1);
    for (k = 1; k <= 2 * N; k++)
        Ith(corr, k) = Ith(q, k) / sum;

    /* Replace the integrator, since we have a new initial condition */
    CVodeFree(cvode_mem);
    cvode_mem = CVodeMalloc(2 * N, derivs, tc, y,
                            (method == 0) ? ADAMS : BDF,
                            (itertype == 0) ? FUNCTIONAL : NEWTON,
                            (nabstol == 1) ? SS : SV,
                     &reltol, abstolp, NULL, NULL, TRUE, iopt, ropt, NULL);
    if (cvode_mem == NULL) {
        fatal_error("CVodeMalloc failed.\n");
    }

    CVodeFree(cvode_mem_corr);
    cvode_mem_corr = CVodeMalloc(2 * N, derivs, tc, corr,
                            (method == 0) ? ADAMS : BDF,
                            (itertype == 0) ? FUNCTIONAL : NEWTON,
                            (nabstol == 1) ? SS : SV,
                     &reltol, abstolp, NULL, NULL, TRUE, iopt, ropt, NULL);
    if (cvode_mem_corr == NULL) {
        fatal_error("CVodeMalloc failed.\n");
    }

    /* Call CVDiag */
    CVDiag(cvode_mem);
    CVDiag(cvode_mem_corr);
    return tc;
}

void    mcwfalg(integer itraj, integer ntraj)
{
    integer i, N, exflag, flag;
    real    eps = 1.0e-6, t, temp;
    real    nl, nr, na, tl, tr, taim, thresh;
    double  sum = 0.0;

    N = RHS.N;
    for (i = 1; i <= 2 * N; i++) {
        Ith(y, i) = Ith(ystart, i);
	Ith(corr,i) = Ith(corrstart,i);
    }

    /* Initialize ODE solver */
    cvode_mem = CVodeMalloc(2 * N, derivs, Ith(tlist, 1), y,
                            (method == 0) ? ADAMS : BDF,
                            (itertype == 0) ? FUNCTIONAL : NEWTON,
                            (nabstol == 1) ? SS : SV,
                     &reltol, abstolp, NULL, NULL, TRUE, iopt, ropt, NULL);
    if (cvode_mem == NULL) {
        fatal_error("CVodeMalloc failed.\n");
    }

    cvode_mem_corr = CVodeMalloc(2 * N, derivs, Ith(tlist, 1), corr,
                            (method == 0) ? ADAMS : BDF,
                            (itertype == 0) ? FUNCTIONAL : NEWTON,
                            (nabstol == 1) ? SS : SV,
                     &reltol, abstolp, NULL, NULL, TRUE, iopt, ropt, NULL);
    if (cvode_mem_corr == NULL) {
        fatal_error("CVodeMalloc failed.\n");
    }

    /* Call CVDiag */
    CVDiag(cvode_mem);
    CVDiag(cvode_mem_corr);

    q = N_VNew(2 * N, NULL);
    thresh = genunf(0.0, 1.0);  /* Generate target value of norm^2 */
    if (nopers == 0)
        fwrite(&itraj, sizeof(integer), 1, op);
    if (clrecflag) {
        temp = itraj;
        fwrite(&temp, sizeof(real), 1, cp);
        temp = 0.0;
        fwrite(&temp, sizeof(real), 1, cp);
    }
    tr = Ith(tlist, 1);
    nr = norm2(N_VDATA(y) - 1, N);
    if (nopers == 0)
        fwrite(N_VDATA(y), sizeof(real), 2 * N, op);
    else
        operCorrAccum(N_VDATA(y) - 1, N_VDATA(corr) - 1, N_VDATA(q) - 1, N, tr, 1);

    for (i = 2; i <= ntimes;) {
        taim = Ith(tlist, i);
        tl = tr;
        nl = nr;
        flag = CVode1(cvode_mem, taim, y, &tr, ONE_STEP);
        if (flag != SUCCESS) {
            sprintf(errmsg, "CVode1 failed, flag=%d.\n", flag);
            fatal_error(errmsg);
        }
        nr = norm2(N_VDATA(y) - 1, N);
        for (; i <= ntimes;) {
            if (tr < taim) {
                if (nr < thresh) {
                    tr = docollapse(tl, nl, tr, nr, thresh);  /* A collapse has
                                                               * occured */
                    nr = 1.0;
					nr = norm2(N_VDATA(y)-1,N);
                    thresh = genunf(0.0, 1.0);  /* Generate target value of
                                                 * norm^2 */
                }
                break;
            } else {
                flag = CVode1(cvode_mem, taim, y, &t, NORMAL); /* Interpolate */
                if (flag != SUCCESS) {
                    sprintf(errmsg, "CVode failed, flag=%d.\n", flag);
                    fatal_error(errmsg);
                }
                na = norm2(N_VDATA(y) - 1, N);
                if (na < thresh) {
                    tr = docollapse(tl, nl, taim, na, thresh);  /* A collapse has
                                                                 * occured */
                    nr = 1.0;
					nr = norm2(N_VDATA(y)-1,N);
                    thresh = genunf(0.0, 1.0);  /* Generate target value of
                                                 * norm^2 */
                    break;
                } else {        /* Write out results */
                    tl = taim;
                    nl = na;
                    flag = CVode1(cvode_mem_corr, taim, corr, &t, NORMAL); /* Interpolate */
                    if (flag != SUCCESS) {
                        sprintf(errmsg, "CVode1 failed, flag=%d.\n", flag);
                        fatal_error(errmsg);
                    }
                    if (nopers == 0)
                        fwrite(N_VDATA(corr), sizeof(real), 2 * N, op);
                    else
                        operCorrAccum(N_VDATA(y) - 1, N_VDATA(corr) - 1, N_VDATA(q) - 1, N, taim, i);
                    i += 1;
                    progress += NHASH;
                    while (progress >= (ntimes - 1) * ntraj) {
                        fprintf(stderr, "#");
                        progress -= (ntimes - 1) * ntraj;
                    }
                    taim = Ith(tlist, i);
                }
            }
        }
    }
    CVodeFree(cvode_mem);
    CVodeFree(cvode_mem_corr);
}

void    clearaver()
/* Clears the averaging buffers for expectation values */
{
    integer i, j;
    real   *t1, *t2;

    for (i = 1; i <= nopers; i++) {
        t1 = N_VDATA(opr[i]);
        t2 = N_VDATA(opi[i]);
        for (j = 0; j < ntimes; j++) {
            t1[j] = 0.0;
            t2[j] = 0.0;
        }
    }
}


void    writeaver(integer itraj)
/* Writes out the averaging buffers to the output file */
{
    integer i, j;
    real   *t1, *t2;

    fwrite(&itraj, sizeof(integer), 1, op);
    for (i = 1; i <= nopers; i++) {
        t1 = N_VDATA(opr[i]);
        t2 = N_VDATA(opi[i]);
        for (j = 0; j < ntimes; j++) {
            t1[j] /= ftraj;
            t2[j] /= ftraj;
        }
        fwrite(N_VDATA(opr[i]), sizeof(real), ntimes, op);
        fwrite(N_VDATA(opi[i]), sizeof(real), ntimes, op);
    }
}


integer main(int argc, char *argv[])
{
    integer i, j, k, code, dummy;
    struct tm *newtime;
    time_t  long_time;

    remove("success.qo");
    remove("failure.qo");
    if (argc <= 2) {
        sprintf(errmsg, "Usage: %s infile outfile1 [outfile2]\n", argv[0]);
        fatal_error(errmsg);
    }
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        sprintf(errmsg, "Error reading problem definition file: %s\n", argv[1]);
        fatal_error(errmsg);
    }
    op = fopen(argv[2], "wb");
    if (op == NULL) {
        sprintf(errmsg, "Error writing output file: %s\n", argv[2]);
        fatal_error(errmsg);
    }
    clrecflag = (argc >= 4);    /* Flag indicating if classical record needed */
    if (clrecflag) {
        cp = fopen(argv[3], "wb");
        if (cp == NULL) {
            sprintf(errmsg, "Error writing output file: %s\n", argv[3]);
            fatal_error(errmsg);
        }
    }
    fread(&code, sizeof(integer), 1, fp);
    if (code != 4001) {
        sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 4001, code);
        fatal_error(errmsg);
    }
    fread(&N, sizeof(integer), 1, fp);  /* Size of sparse matrices */
    if (N <= 0) {
        fatal_error("Size of problem must be >0.\n");
    }
    RHS.N = N;
    fread(&RHS.nterms, sizeof(integer), 1, fp); /* Number of RHS terms */
    if (RHS.nterms <= 0) {
        fatal_error("Number of terms on RHS must be >0.\n");
    }
    fread(&ncollapses, sizeof(integer), 1, fp); /* Number of collapse
                                                 * operators */
    if (ncollapses < 0) {
        fatal_error("Number of collapse operators must be >=0.\n");
    }
    if (ncollapses > 0) {
        Cprobs = vector(1, ncollapses);
        collapses = (struct FS *) calloc(ncollapses, sizeof(struct FS));
        collapses--;
        for (i = 1; i <= ncollapses; i++) {
            collapses[i].N = N;
            fread(&collapses[i].nterms, sizeof(integer), 1, fp);
            if (collapses[i].nterms <= 0) {
                sprintf(errmsg, "Invalid number of terms for collapse operator %d.\n", i);
                fatal_error(errmsg);
            }
        }
    }
    fread(&nopers, sizeof(integer), 1, fp);
    opers = (struct FS *) calloc(nopers, sizeof(struct FS));
    opers--;
    for (i = 1; i <= nopers; i++) {
        opers[i].N = N;
        fread(&opers[i].nterms, sizeof(integer), 1, fp);
        if (opers[i].nterms <= 0) {
            sprintf(errmsg, "Invalid number of terms for average operator %d.\n", i);
            fatal_error(errmsg);
        }
    }

/* First read in terms on RHS of evolution equation */

    file2FS(fp, &RHS);

/* Next read in collapse operator terms */

    if (ncollapses > 0) {
        for (i = 1; i <= ncollapses; i++)
            file2FS(fp, &collapses[i]);
    }
/* Next read in operator terms for averages */

    if (nopers > 0) {
        for (i = 1; i <= nopers; i++)
            file2FS(fp, &opers[i]);
    }
    /* Read in intial conditions */
    /* State vector */
    fread(&code, sizeof(integer), 1, fp);
    if (code != 4003) {
        sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 4003, code);
        fatal_error(errmsg);
    }
    ystart = N_VNew(2 * N, NULL); /* Get memory for initial condition */
    if (ystart == NULL) {
        fatal_error("Memory allocation failure for initial condition.\n");
    }
    y = N_VNew(2 * N, NULL);    /* Get memory for dependent vector */
    if (y == NULL) {
        fatal_error("Memory allocation failure for state vector.\n");
    }
    fread(N_VDATA(ystart), sizeof(real), N, fp);  /* Read in real parts of
                                                   * initial value */
    fread(N_VDATA(ystart) + N, sizeof(real), N, fp);  /* Read in imaginary
                                                       * parts of initial
                                                       * value */
    /* Correlation */
    corrstart = N_VNew(2 * N, NULL); /* Get memory for initial correlation vector */
    if (corrstart == NULL) {
        fatal_error("Memory allocation failure for initial correlation vector.\n");
    }
    corr = N_VNew(2 * N, NULL);    /* Get memory for correlation vector */
    if (corr == NULL) {
        fatal_error("Memory allocation failure for correlation vector.\n");
    }
    fread(N_VDATA(corrstart), sizeof(real), N, fp);  /* Read in real parts of
                                                      * initial value */
    fread(N_VDATA(corrstart) + N, sizeof(real), N, fp);  /* Read in imaginary
                                                          * parts of initial
                                                          * value */

    /* Read in list of times */
    fread(&ntimes, sizeof(integer), 1, fp);
    tlist = N_VNew(ntimes, NULL); /* Get memory for time vector */
    if (tlist == NULL) {
        fatal_error("Memory allocation failure for time vector.\n");
    }
    fread(N_VDATA(tlist), sizeof(real), ntimes, fp);
    fread(&iseed, sizeof(integer), 1, fp);
    fread(&ntraj, sizeof(integer), 1, fp);  /* Number of trajectories to
                                             * compute */
    fread(&ftraj, sizeof(integer), 1, fp);  /* Frequency at which expectation */
    /* values are written */
    fread(&dummy, sizeof(integer), 1, fp);  /* Unused parameter */

/* Read in options for differential equation solver */

    method = 0;
    itertype = 0;
    reltol = RELTOL;
    abstol = ABSTOL;
    abstolp = &abstol;
    nabstol = 1;


    if (fread(&code, sizeof(integer), 1, fp) > 0) {
        if (code != 1001) {
            sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 1001, code);
            fatal_error(errmsg);
        }
        fread(&method, sizeof(integer), 1, fp);
        fread(&itertype, sizeof(integer), 1, fp);
        fread(&reltol, sizeof(real), 1, fp);
        fread(&nabstol, sizeof(integer), 1, fp);
        if (nabstol == 1)
            fread(&abstol, sizeof(real), 1, fp);
        else if (nabstol == N) {/* Vector of absolute tolerances */
            abstolv = N_VNew(2 * N, NULL);
            if (abstolv == NULL) {
                fatal_error("Memory allocation failure for absolute tolerance vector.\n");
            }
            fread(N_VDATA(abstolv), sizeof(real), N, fp);
            for (i = 1; i <= N; i++)
                Ith(abstolv, N + i) = Ith(abstolv, i);
            abstolp = abstolv;
        } else {
            fatal_error("Absolute tolerance vector has invalid length.\n");
        }
        fread(&iopt[MAXORD], sizeof(integer), 1, fp);
        fread(&iopt[MXSTEP], sizeof(integer), 1, fp);
        fread(&iopt[MXHNIL], sizeof(integer), 1, fp);
        fread(&ropt[H0],   sizeof(real), 1, fp);
        fread(&ropt[HMAX], sizeof(real), 1, fp);
        fread(&ropt[HMIN], sizeof(real), 1, fp);
    }
/* Allocate arrays for expectation values */

    if (nopers > 0) {
        opr = (N_Vector *) calloc(nopers, sizeof(N_Vector));
        opi = (N_Vector *) calloc(nopers, sizeof(N_Vector));
        if (opr == NULL || opi == NULL) {
            fatal_error("Allocation failure for expectation value array pointers.\n");
        }
        opr--;
        opi--;
        for (i = 1; i <= nopers; i++) {
            opr[i] = N_VNew(ntimes, NULL);
            opi[i] = N_VNew(ntimes, NULL);
            if (opr[i] == NULL || opi[i] == NULL) {
                fatal_error("Allocation failure for expectation value arrays.\n");
            }
        }
    }
/* Set up the random seeds */
    setall(abs(iseed ^ 1234567890L), abs(iseed ^ 987654321L));
    progress = 0;
    if (ncollapses > 0) {       /* Use quantum trajectory algorithm */
        fprintf(stderr, "Integrating differential equation, %d trajectories, %d times.\n", ntraj, ntimes);
        fprintf(stderr, "Progress: ");
        q = N_VNew(2 * N, NULL);/* Get memory for temporary storage */
        if (nopers == 0)        /* Calculate and store wave functions */
            for (i = 1; i <= ntraj; i++)
                mcwfalg(i, ntraj);
        else {                  /* Only store averages of specified operators */
            j = 0;
            while (j < ntraj) {
                clearaver();
                for (i = 1; i <= ftraj; i++) {
                    j++;
                    mcwfalg(j, ntraj);
                }
                writeaver(j);
            }
        }
        N_VFree(q);
    } else {
        sprintf(errmsg, "Cannot run MCCORR without collapse operators.");
        fatal_error(errmsg);
    }
    fprintf(stderr, "\n");

/* Tidy up at end of algorithm */

    if (nopers > 0) {
        for (i = 1; i <= nopers; i++) {
            N_VFree(opr[i]);
            N_VFree(opi[i]);
        }
        opr++;
        free(opr);
        opi++;
        free(opi);
    }
    N_VFree(tlist);
    N_VFree(y);
    N_VFree(ystart);
    N_VFree(corr);
    N_VFree(corrstart);


    fclose(fp);
    fclose(op);
    if (clrecflag)
        fclose(cp);

    /* Indicate successful completion */
    time(&long_time);           /* Get time as long integer. */
    newtime = localtime(&long_time);  /* Convert to local time. */
    fp = fopen("success.qo", "w");
    fprintf(fp, "SUCCESS\nMCCORR succeeded at %19s\n", asctime(newtime));
    fclose(fp);

    return 0;
}
