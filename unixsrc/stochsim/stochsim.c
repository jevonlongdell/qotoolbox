/*
  Solution of system of differential equations with sparse time-dependent
  coefficient matrices and Quantum Monte Carlo algorithm.

%% version 0.10 11-Jan-1999
%%
    Copyright (C) 1996-2002  Sze M. Tan

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

  Date:         4 March 1996    Modified from odesolve for time-independent coefficients
                6 March 1996    Wrote Gaussian pulse routines
        	24 April 1996   Modifications for quantum Monte Carlo
                20 June 1996    Modifications to compute expectation values
 */
#define DEBUG
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include "ranlib.h"
#include "llnltyps.h"

#define PI (3.14159265358979)

static FILE *fp, *op, *cp, *php, *psip;

float   dxsav, *xp, **yp;       /* defining declarations */
int     kmax, kount;

int     N, Rnterms, Cnterms, Onterms, ntraj, ftraj;

struct FS {                     /* Define the function series structure */
    int     N;                  /* Size of sparse matrices */
    int     nterms;             /* Number of terms in series */
    int    *nnz;                /* Array storing number of non-zeros in each
                                 * sparse matrix */
    int   **rowptrp;            /* Sparse matrix pointers */
    int   **ninrowp;
    int   **colindxp;
    int    *ftypes;             /* Function types associated with terms */
    int    *fparamsn;           /* Number of parameters for each term */
    float **fparamsp;           /* Function parameters */
    float **Mrealp;             /* Real parts of sparse matrices */
    float **Mimagp;             /* Imaginary parts of sparse matrices */
};

static struct FS RHS;
static struct FS *homodyne;
static int nhomodyne;
static struct FS *heterodyne;
static int nheterodyne;
static struct FS *collapses;
static int ncollapses;
static struct FS *opers;
static int nopers;

static int photocurflag, clrecflag, psiflag;

static float *tlist, *ystart, *Cprobs, *psitlist;
static float **opr, **opi;
static float *heteror, *heteroi;
static float *homo;
static long iseed;
static int ntimes, refine, npsitimes;

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
    fprintf(fp, "FAIL\nSOLVESDE failed at %s\n", asctime(newtime));
    fprintf(fp, "%s\n", msg);
    fprintf(stderr, "SOLVESDE FAILED.\n%s", msg);
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

void    func0(int n, float *params, float x, float *yr, float *yi)
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

void    FSmul(struct FS * S, float x, float y[], float Sy[])
{
    int     i, j, k, l, N, base, ft;
    float   sumr, sumi;
    int     nparams;
    float  *fparams;

    N = S->N;
    for (i = 1; i <= S->N; i++) {
        sumr = sumi = 0.0;
        for (l = 1; l <= S->nterms; l++) {
            float  *Mreal, *Mimag, fr, fi, tr, ti;
            void    (*func) (int, float *, float, float *, float *);
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

float   norm2(float *y, int N)
/* Calculates square of norm of the complex vector y */
{
    int     i;
    double  sum = 0.0;
    float  *yp1, *yp2;
    yp1 = &y[1];
    yp2 = &y[N + 1];
    for (i = 1; i <= N; i++) {
        sum += (*yp1) * (*yp1) + (*yp2) * (*yp2);
        yp1++;
        yp2++;
    }
    return sum;
}

void    inprod(float x[], float y[], int N, float *ipr, float *ipi)
/* Calculates inner product of the complex vector y */
{
    int     i;
    double  sumr = 0.0, sumi = 0.0;
    float  *xpr, *xpi, *ypr, *ypi;
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
    int     i, j, l, code, N, nterms;

    /* Allocate memory for sparse matrix data structures */

    N = S->N;
    nterms = S->nterms;
    S->nnz = (int *) calloc(nterms, sizeof(int));
    S->rowptrp = (int **) calloc(nterms, sizeof(int *));
    S->ninrowp = (int **) calloc(nterms, sizeof(int *));
    S->colindxp = (int **) calloc(nterms, sizeof(int *));
    S->ftypes = (int *) calloc(nterms, sizeof(int));
    S->fparamsn = (int *) calloc(nterms, sizeof(int));
    S->fparamsp = (float **) calloc(nterms, sizeof(float *));
    S->Mrealp = (float **) calloc(nterms, sizeof(float *));
    S->Mimagp = (float **) calloc(nterms, sizeof(float *));

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
        fread(&code, sizeof(int), 1, fp);
        if (code != 2002) {
            sprintf(errmsg, "Invalid code in file2FS, expected %d, found %d.\n", 2002, code);
            fatal_error(errmsg);
        }
        fread(&j, sizeof(int), 1, fp);
        if (j != N) {
            sprintf(errmsg, "Inconsistent matrix size passed to file2FS.\n");
            fatal_error(errmsg);
        }
        fread(&S->nnz[l], sizeof(int), 1, fp);
        S->rowptrp[l] = ivector(1, N);
        S->ninrowp[l] = ivector(1, N);
        S->colindxp[l] = ivector(1, S->nnz[l]);
        S->Mrealp[l] = vector(1, S->nnz[l]);
        S->Mimagp[l] = vector(1, S->nnz[l]);
        fread(&S->colindxp[l][1], sizeof(int), S->nnz[l], fp);
        j = 1;
        for (i = 1; i <= N; i++) {
            S->rowptrp[l][i] = j;
            S->ninrowp[l][i] = 0;
            while (j <= S->nnz[l] && S->colindxp[l][j] == i) {
                j++;
                S->ninrowp[l][i]++;
            }
        }
        fread(&S->colindxp[l][1], sizeof(int), S->nnz[l], fp);
        fread(&S->Mrealp[l][1], sizeof(float), S->nnz[l], fp);
        fread(&S->Mimagp[l][1], sizeof(float), S->nnz[l], fp);
        /* Read info about which function to use */
        fread(&S->ftypes[l], sizeof(int), 1, fp);
        fread(&S->fparamsn[l], sizeof(int), 1, fp);
        if (S->fparamsn[l] != fpcheck[S->ftypes[l]]) {
            sprintf(errmsg, "Incorrect number of arguments for function %d.\n",
                    S->ftypes[l]);
            fatal_error(errmsg);
        }
        S->fparamsp[l] = vector(1, S->fparamsn[l]);
        /* Read in function parameters */
        fread(&S->fparamsp[l][1], sizeof(float), S->fparamsn[l], fp);
    }
}

void    operAccum(float pl[], float q[], int N, float t, int indx)
{
    int     i;
    float   xnorm, ipr, ipi;

    xnorm = norm2(pl, N);
    for (i = 1; i <= nopers; i++) {
        FSmul(&opers[i], t, pl, q);
        inprod(pl, q, N, &ipr, &ipi);
        opr[i][indx] += ipr / xnorm;
        opi[i][indx] += ipi / xnorm;
    }
}

void    stochsim(int itraj, int ntraj)
{
    int     i, j, k, l, m, N;
    float   dt, xnorm2, namplr, namplc;
    float  *pl, *p, *q, temp, tempr, tempi, tl, tmp;

    N = RHS.N;
    if (nopers == 0)
        fwrite(&itraj, sizeof(int), 1, op);
    if (photocurflag)
        fwrite(&itraj, sizeof(int), 1, php);
    if (clrecflag) {
        temp = itraj;
        fwrite(&temp, sizeof(float), 1, cp);
        temp = 0.0;
        fwrite(&temp, sizeof(float), 1, cp);
    }
    m = 1;
    pl = vector(1, 2 * N);      /* Storage for complex wave function */
    p = vector(1, 2 * N);
    q = vector(1, 2 * N);       /* Temporary complex storage */
    for (j = 1; j <= 2 * N; j++)
        pl[j] = ystart[j];
    tl = tlist[1];
    if (nopers == 0)            /* Write the wave function */
        fwrite(&pl[1], sizeof(float), 2 * N, op);
    else                        /* Record in accumulation buffer */
        operAccum(pl, q, N, tl, 1);

    for (i = 2; i <= ntimes; i++) {

        dt = (tlist[i] - tlist[i - 1]) / refine;
        namplr = 1.0 / sqrt(dt);
        namplc = 1.0 / sqrt(2.0 * dt);
        for (k = 1; k <= nhomodyne; k++)
            homo[k] = 0;
        for (k = 1; k <= nheterodyne; k++)
            heteror[k] = heteroi[k] = 0;

        for (l = 1; l <= refine; l++) {
            tl = tlist[i - 1] + (l - 1) * dt;
            xnorm2 = norm2(pl, N);
            if (psiflag && m <= npsitimes && tl >= psitlist[m]) {
                fwrite(&itraj, sizeof(int), 1, psip);
                fwrite(&tl, sizeof(float), 1, psip);
                fwrite(&pl[1], sizeof(float), 2 * N, psip);
                m++;
            }
            FSmul(&RHS, tl, pl, q);
            for (j = 1; j <= 2 * N; j++)  /* Handle Hermitian part */
                p[j] = pl[j] + q[j] * dt;
            for (k = 1; k <= nhomodyne; k++) {
                FSmul(&homodyne[k], tl, pl, q); /* Calculate homodyne terms */
                inprod(pl, q, N, &tempr, &tempi);
                temp = 2 * tempr / xnorm2 + gennor(0.0, namplr);

                if (photocurflag) {
                    homo[k] += temp;
                    if (l == refine) {
                        tmp = homo[k] / refine;
                        fwrite(&tmp, sizeof(float), 1, php);
                    }
                }
                for (j = 1; j <= 2 * N; j++)
                    p[j] += temp * q[j] * dt;
            }
            for (k = 1; k <= nheterodyne; k++) {
                FSmul(&heterodyne[k], tl, pl, q); /* Calculate heterodyne
                                                   * terms */
                inprod(pl, q, N, &tempr, &tempi);
                tempr = tempr / xnorm2 + gennor(0.0, namplc);
                tempi = -tempi / xnorm2 + gennor(0.0, namplc);
                if (photocurflag) {
                    heteror[k] += tempr;
                    heteroi[k] += tempi;
                    if (l == refine) {
                        tmp = heteror[k] / refine;
                        fwrite(&tmp, sizeof(float), 1, php);
                        tmp = heteroi[k] / refine;
                        fwrite(&tmp, sizeof(float), 1, php);
                    }
                }
                for (j = 1; j <= N; j++) {
                    p[j] += (tempr * q[j] - tempi * q[j + N]) * dt;
                    p[j + N] += (tempr * q[j + N] + tempi * q[j]) * dt;
                }
            }

            for (k = 1; k <= ncollapses; k++) { /* Deal with jump processes */
                FSmul(&collapses[k], tl, pl, q);
                Cprobs[k] = norm2(q, N) * dt / xnorm2;
                if (genunf(0.0, 1.0) < Cprobs[k]) { /* Carry out jump */
                    if (clrecflag) {
                        fwrite(&tl, sizeof(float), 1, cp);
                        temp = k;
                        fwrite(&temp, sizeof(float), 1, cp);
                    }
                    FSmul(&collapses[k], tl, p, q);
                    temp = sqrt(norm2(q, N));
                    for (j = 1; j <= 2 * N; j++)
                        p[j] = q[j] / temp;
                }
            }
            temp = sqrt(norm2(p, N));
            for (j = 1; j <= 2 * N; j++)
                pl[j] = p[j] / temp;
        }
        if (nopers == 0)
            fwrite(&pl[1], sizeof(float), 2 * N, op);
        else
            operAccum(pl, q, N, tl, i);
        progress += NHASH;
        while (progress >= (ntimes - 1) * ntraj) {
            fprintf(stderr, "#");
            progress -= (ntimes - 1) * ntraj;
        }

    }
    if (psiflag) {
        fwrite(&itraj, sizeof(int), 1, psip);
        temp = tlist[ntimes];
        fwrite(&temp, sizeof(float), 1, psip);
        fwrite(&pl[1], sizeof(float), 2 * N, psip);
    }
    free_vector(q, 1, 2 * N);
    free_vector(pl, 1, 2 * N);
    free_vector(p, 1, 2 * N);
}

void    clearaver()
/* Clears the averaging buffers for expectation values */
{
    int     i, j;
    for (i = 1; i <= nopers; i++) {
        for (j = 1; j <= ntimes; j++) {
            opr[i][j] = 0.0;
            opi[i][j] = 0.0;
        }
    }
}

void    writeaver(int itraj)
/* Writes out the averaging buffers to the output file */
{
    int     i, j;

    fwrite(&itraj, sizeof(int), 1, op);
    for (i = 1; i <= nopers; i++) {
        for (j = 1; j <= ntimes; j++) {
            opr[i][j] /= ftraj;
            opi[i][j] /= ftraj;
        }
        fwrite(&opr[i][1], sizeof(float), ntimes, op);
        fwrite(&opi[i][1], sizeof(float), ntimes, op);

    }
}

int     main(int argc, char *argv[])
{
    int     i, j, l, code;
    struct tm *newtime;
    time_t  long_time;

    remove("success.qo");
    remove("failure.qo");
    if (argc <= 2) {
        sprintf(errmsg, "Usage: %s infile resultfile [photofile [clickfile]]\n", argv[0]);
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
    photocurflag = (argc >= 4); /* Flag indicating if photocurrent record
                                 * needed */
    if (photocurflag) {
        php = fopen(argv[3], "wb");
        if (php == NULL) {
            sprintf(errmsg, "Error writing photocurrent file: %s\n", argv[3]);
            fatal_error(errmsg);
        }
    }
    clrecflag = (argc >= 5);    /* Flag indicating if classical record needed */
    if (clrecflag) {
        cp = fopen(argv[4], "wb");
        if (cp == NULL) {
            sprintf(errmsg, "Error writing classical record file: %s\n", argv[4]);
            fatal_error(errmsg);
        }
    }
    psiflag = (argc >= 6);      /* Flag indicating if wave function needed */
    if (psiflag) {
        psip = fopen(argv[5], "wb");
        if (psip == NULL) {
            sprintf(errmsg, "Error writing state vector file: %s\n", argv[5]);
            fatal_error(errmsg);
        }
    }
    fread(&code, sizeof(int), 1, fp);
    if (code != 3001) {
        sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 3001, code);
        fatal_error(errmsg);
    }
    fread(&N, sizeof(int), 1, fp);  /* Size of sparse matrices */
    RHS.N = N;
    fread(&RHS.nterms, sizeof(int), 1, fp); /* Number of RHS terms */

    fread(&nhomodyne, sizeof(int), 1, fp);  /* Number of homodyne operators */
    homodyne = (struct FS *) calloc(nhomodyne, sizeof(struct FS));
    homodyne--;
    for (i = 1; i <= nhomodyne; i++) {
        homodyne[i].N = N;
        fread(&homodyne[i].nterms, sizeof(int), 1, fp);
    }

    fread(&nheterodyne, sizeof(int), 1, fp);  /* Number of heterodyne
                                               * operators */
    heterodyne = (struct FS *) calloc(nheterodyne, sizeof(struct FS));
    heterodyne--;
    for (i = 1; i <= nheterodyne; i++) {
        heterodyne[i].N = N;
        fread(&heterodyne[i].nterms, sizeof(int), 1, fp);
    }

    fread(&ncollapses, sizeof(int), 1, fp); /* Number of collapse operators */
    Cprobs = vector(1, ncollapses);
    collapses = (struct FS *) calloc(ncollapses, sizeof(struct FS));
    collapses--;
    for (i = 1; i <= ncollapses; i++) {
        collapses[i].N = N;
        fread(&collapses[i].nterms, sizeof(int), 1, fp);
    }

    fread(&nopers, sizeof(int), 1, fp); /* Number of operators for which to
                                         * calculate averages */
    opers = (struct FS *) calloc(nopers, sizeof(struct FS));
    opers--;
    for (i = 1; i <= nopers; i++) {
        opers[i].N = N;
        fread(&opers[i].nterms, sizeof(int), 1, fp);
    }

/* First read in terms on RHS of evolution equation */

    file2FS(fp, &RHS);

/* Next read in homodyne operator terms */

    if (nhomodyne > 0) {
        homo = vector(1, nhomodyne);
        for (i = 1; i <= nhomodyne; i++)
            file2FS(fp, &homodyne[i]);
    }
/* Next read in heterodyne operator terms */

    if (nheterodyne > 0) {
        heteror = vector(1, nheterodyne);
        heteroi = vector(1, nheterodyne);
        for (i = 1; i <= nheterodyne; i++)
            file2FS(fp, &heterodyne[i]);
    }
/* Next read in collapse operator terms */

    if (ncollapses > 0) {
        for (i = 1; i <= ncollapses; i++)
            file2FS(fp, &collapses[i]);
    }
/* Finally read in operator terms for averages */

    if (nopers > 0) {
        for (i = 1; i <= nopers; i++)
            file2FS(fp, &opers[i]);
    }
/* Read in intial conditions */

    fread(&code, sizeof(int), 1, fp);
    if (code != 2003) {
        sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 2003, code);
        fatal_error(errmsg);
    }
    ystart = vector(1, 2 * N);
    fread(&ystart[1], sizeof(float), N, fp);
    fread(&ystart[N + 1], sizeof(float), N, fp);

    fread(&ntimes, sizeof(int), 1, fp);
    tlist = vector(1, ntimes);
    fread(&tlist[1], sizeof(float), ntimes, fp);
    fread(&iseed, sizeof(int), 1, fp);

    fread(&ntraj, sizeof(int), 1, fp);  /* Number of trajectories to compute */
    fread(&ftraj, sizeof(int), 1, fp);  /* Frequency at which expectation
                                         * values are written */
    fread(&refine, sizeof(int), 1, fp); /* Substeps between entries in tlist */
    fread(&npsitimes, sizeof(int), 1, fp);
    psitlist = vector(1, npsitimes);

    fread(&psitlist[1], sizeof(float), npsitimes, fp);


/* Allocate arrays for expectation values */


    if (nopers > 0) {
        opr = (float **) calloc(nopers, sizeof(float *));
        opi = (float **) calloc(nopers, sizeof(float *));
        if (opr == NULL || opi == NULL) {
            fatal_error("Allocation failure for expectation value array pointers.\n");
        }
        opr--;
        opi--;
        for (i = 1; i <= nopers; i++) {
            opr[i] = vector(1, ntimes);
            opi[i] = vector(1, ntimes);

            if (opr[i] == NULL || opi[i] == NULL) {
                fatal_error("Allocation failure for expectation value array pointers.\n");
            }
        }
    }
/* Set up the random seeds */
    setall(abs(iseed ^ 1234567890L), abs(iseed ^ 987654321L));

    fprintf(stderr, "Starting stochastic simulation, %d trajectories, %d times:\n", ntraj, ntimes);
    progress = 0;
    fprintf(stderr, "Progress: ");

    if (nopers == 0)
        for (i = 1; i <= ntraj; i++)
            stochsim(i, ntraj);
    else {
        j = 0;
        while (j < ntraj) {
            clearaver();
            for (i = 1; i <= ftraj; i++) {
                j++;
                stochsim(j, ntraj);
            }
            writeaver(j);
        }
    }

    fprintf(stderr, "\n");
    fclose(fp);
    fclose(op);
    if (photocurflag)
        fclose(php);
    if (clrecflag)
        fclose(cp);
    if (psiflag)
        fclose(psip);

    /* Indicate successful completion */
    time(&long_time);           /* Get time as long integer. */
    newtime = localtime(&long_time);  /* Convert to local time. */
    fp = fopen("success.qo", "w");
    fprintf(fp, "STOCHSIM succeeded at %19s\n", asctime(newtime));
    fclose(fp);


    return 0;
}
