/*
  Solution of a system of stochastic differential equations with sparse time-dependent
  coefficient matrices and a Stratonovich Quantum State Diffusion algorithm.

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

  Date:          9 March    1998	Initial release
                12 December 1998	Changed to use CVODE and RANLIB
                18 December 1998	Using modified CVODE
		28 Sep      1999	Added optional inputs to ODE solvers
 */

#define DEBUG
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>
#include "ranlib.h"
#include "llnltyps.h"
#include "cvodenew.h"
#include "cvdiag.h"
#include "vector.h"
#define PI (3.14159265358979)
#define RELTOL (1.0e-4)
#define ABSTOL (1.0e-4)

#define Ith(v,i)	N_VIth(v,i-1)
#define EXTRA 1
#define NHASH 69

extern void (*funclist[])(integer, real *, real, real *, real *);
extern integer fpcheck[];

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

real    ropt[OPT_SIZE];
long int iopt[OPT_SIZE];

static FILE *fp, *op, *cp, *php, *psip;

real    dxsav, *xp, **yp;       /* defining declarations */
integer kmax, kount;

integer N, Rnterms, Cnterms, Onterms, ntraj, ftraj;

struct FS {                     /* Define the function series structure */
    integer N;                  /* Size of sparse matrices */
    integer nterms;             /* Number of terms in series */
    integer *nnz;               /* Array storing number of non-zeros in each */
    /* sparse matrix */
    integer **rowptrp;          /* Sparse matrix pointers */
    integer **ninrowp;
    integer **colindxp;
    integer *ftypes;            /* Function types associated with terms */
    integer *fparamsn;          /* Number of parameters for each term */
    real  **fparamsp;           /* Function parameters */
    real  **Mrealp;             /* Real parts of sparse matrices */
    real  **Mimagp;             /* Imaginary parts of sparse matrices */
};

static struct FS RHS;
static struct FS *homodyne;
static integer nhomodyne;
static struct FS *heterodyne;
static integer nheterodyne;
static struct FS *collapses;
static integer ncollapses;
static struct FS *opers;
static integer nopers;

static integer photocurflag, clrecflag, psiflag;

static N_Vector tlist, ystart, y, abstolv;
static real *Cprobs, *psitlist;
static N_Vector *opr, *opi;
static real *heteror, *heteroi;
static N_Vector hetnoiser, hetnoisei;
static real *homo;
static N_Vector homnoise;
static real *pl, *q;
static long iseed;
static integer ntimes, refine, npsitimes;
static void *cvode_mem;
static integer method, itertype, nabstol;
static real reltol, abstol;
static void *abstolp;
static real deltat, dt, namplr, namplc, top;
static integer head;

void    FSmul(struct FS * S, real x, real y[], real Sy[])
{
    integer i, j, k, l, N, base, ft;
    real    sumr, sumi;
    integer nparams;
    real   *fparams;

    N = S->N;
    for (i = 1; i <= S->N; i++) {
        sumr = sumi = 0.0;
        for (l = 1; l <= S->nterms; l++) {
            real   *Mreal, *Mimag, fr, fi, tr, ti;
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

void    operAccum(real pl[], real q[], integer N, real t, integer indx)
{
    integer i;
    real    xnorm, ipr, ipi;

    xnorm = norm2(pl, N);
    for (i = 1; i <= nopers; i++) {
        FSmul(&opers[i], t, pl, q);
        inprod(pl, q, N, &ipr, &ipi);
        Ith(opr[i], indx) += ipr / xnorm;
        Ith(opi[i], indx) += ipi / xnorm;
    }
}

static void derivs(integer M, real x, N_Vector y, N_Vector dydx, void *f_data)
/* Calculates derivative for stochastic DE problem */
{
    integer k, l, N;
    real    xnorm2, temp, tempr, tempi;

    N = RHS.N;
    N_VLENGTH(dydx) = N_VLENGTH(y);

    /* Non-stochastic terms (effective Hamiltonian) */
    FSmul(&RHS, x, N_VDATA(y) - 1, N_VDATA(dydx) - 1);
    /* Calculate evolution due to homodyne terms */
    xnorm2 = norm2(N_VDATA(y) - 1, N);
    for (k = 1; k <= nhomodyne; k++) {
        /* Compute C_k |psi> for homodyne term */
        FSmul(&homodyne[k], x, N_VDATA(y) - 1, q);
        /* Find <psi|C_k|psi>/<psi|psi> + noise */
        inprod(N_VDATA(y) - 1, q, N, &tempr, &tempi);
        temp = 2 * tempr / xnorm2 + Ith(homnoise, k);
        /* Add into derivative */
        for (l = 1; l <= 2 * N; l++)
            Ith(dydx, l) += temp * q[l];
        /* Calculate Stratonovich correction */
        FSmul(&homodyne[k], x, q, pl);
        /* Subtract from derivative */
        for (l = 1; l <= 2 * N; l++)
            Ith(dydx, l) -= 0.5 * pl[l];
    }
    /* Calculate evolution due to heterodyne terms */
    for (k = 1; k <= nheterodyne; k++) {
        /* Compute C_k |psi> for homodyne term */
        FSmul(&heterodyne[k], x, N_VDATA(y) - 1, q);
        /* Find <psi|C_k'|psi>/<psi|psi> + noise */
        inprod(N_VDATA(y) - 1, q, N, &tempr, &tempi);
        tempr = tempr / xnorm2 + Ith(hetnoiser, k);
        tempi = -tempi / xnorm2 + Ith(hetnoisei, k);
        /* Add into derivative */
        for (l = 1; l <= N; l++) {
            Ith(dydx, l) += tempr * q[l] - tempi * q[l + N];
            Ith(dydx, l + N) += tempi * q[l] + tempr * q[l + N];
        }
    }
}

void    sdesim(integer itraj, integer ntraj)
/* Integrate a stochastic differential equation */
{
    integer flag, indx, i, j, k, l, m, N;
    real    t, xnorm2;
    real    temp, tempr, tempi, tl, tmp;

    top = Ith(tlist, 1);
    head = 0;
    N = RHS.N;
    for (j = 1; j <= 2 * N; j++)
        Ith(y, j) = Ith(ystart, j);

    /* Initialize ODE solver */
    ropt[HMAX] = dt;
    cvode_mem = CVodeMalloc(2 * N, derivs, Ith(tlist, 1), y,
                            (method == 0) ? ADAMS : BDF,
                            (itertype == 0) ? FUNCTIONAL : NEWTON,
                            (nabstol == 1) ? SS : SV,
                      &reltol, abstolp, NULL, NULL, TRUE, iopt, ropt, NULL);
    if (cvode_mem == NULL) {
        fatal_error("CVodeMalloc failed.\n");
    }
    /* Call CVDiag */
    CVDiag(cvode_mem);

    if (nopers == 0)
        fwrite(&itraj, sizeof(integer), 1, op);
    if (photocurflag)
        fwrite(&itraj, sizeof(integer), 1, php);
    if (clrecflag) {
        temp = itraj;
        fwrite(&temp, sizeof(real), 1, cp);
        temp = 0.0;
        fwrite(&temp, sizeof(real), 1, cp);
    }
    m = 1;
    tl = Ith(tlist, 1);
    if (nopers == 0)            /* Write the wave function */
        fwrite(N_VDATA(y), sizeof(real), 2 * N, op);
    else                        /* Record operator expectations in
                                 * accumulation buffer */
        operAccum(N_VDATA(y) - 1, q, N, tl, 1);


    for (i = 2; i <= ntimes; i++) {
        for (k = 1; k <= nhomodyne; k++)  /* Initialize buffers for
                                           * photocurrent records */
            homo[k] = 0;
        for (k = 1; k <= nheterodyne; k++)
            heteror[k] = heteroi[k] = 0;
        for (l = 1; l <= refine; l++) {
            for (k = 1; k <= nhomodyne; k++)
                Ith(homnoise, k) = gennor(0.0, namplr);
            for (k = 1; k <= nheterodyne; k++) {
                Ith(hetnoiser, k) = gennor(0.0, namplc);
                Ith(hetnoisei, k) = gennor(0.0, namplc);
            }
            tl = Ith(tlist, i - 1) + (l - 1) * dt;
            flag = CVodeRestart(cvode_mem, tl, y);
            if (flag != SUCCESS) {
                sprintf(errmsg, "CVodeRestart failed, flag=%d.\n", flag);
                fatal_error(errmsg);
            }
            flag = CVode(cvode_mem, tl + dt, y, &t, NORMAL);
            if (flag != SUCCESS) {
                sprintf(errmsg, "CVode failed, flag=%d.\n", flag);
                fatal_error(errmsg);
            }
            /* Evaluate photocurrent during the previous interval */
            xnorm2 = norm2(N_VDATA(y) - 1, N);
            for (k = 1; k <= nhomodyne; k++) {
                FSmul(&homodyne[k], tl, N_VDATA(y) - 1, q); /* Calculate homodyne
                                                             * terms */
                inprod(N_VDATA(y) - 1, q, N, &tempr, &tempi);
                temp = 2 * tempr / xnorm2;
                if (photocurflag) {
                    homo[k] += (temp + Ith(homnoise, k));
                    if (l == refine) {
                        tmp = homo[k] / refine;
                        fwrite(&tmp, sizeof(real), 1, php);
                    }
                }
            }
            for (k = 1; k <= nheterodyne; k++) {
                FSmul(&heterodyne[k], tl, N_VDATA(y) - 1, q); /* Calculate heterodyne
                                                               * terms */
                inprod(N_VDATA(y) - 1, q, N, &tempr, &tempi);
                tempr = tempr / xnorm2;
                tempi = -tempi / xnorm2;
                if (photocurflag) {
                    heteror[k] += (tempr + Ith(hetnoiser, k));
                    heteroi[k] += (tempi + Ith(hetnoisei, k));
                    if (l == refine) {
                        tmp = heteror[k] / refine;
                        fwrite(&tmp, sizeof(real), 1, php);
                        tmp = heteroi[k] / refine;
                        fwrite(&tmp, sizeof(real), 1, php);
                    }
                }
            }
        }
        /* Normalize the wave function */
        xnorm2 = 1. / sqrt(norm2(N_VDATA(y) - 1, N));
        for (j = 1; j <= 2 * N; j++)
            pl[j] = Ith(y, j) * xnorm2;

        if (nopers == 0)
            fwrite(&pl[1], sizeof(real), 2 * N, op);
        else
            operAccum(pl, q, N, tl, i);
        if (xnorm2 < 1e-6 || xnorm2 > 1e6) {  /* Restart integrator if norm
                                               * is too large or small */
            CVodeFree(cvode_mem);
            ropt[HMAX] = dt;
            for (j = 1; j <= 2 * N; j++)
                Ith(y, j) = pl[j];
            cvode_mem = CVodeMalloc(2 * N, derivs, Ith(tlist, 1), y,
                                    (method == 0) ? ADAMS : BDF,
                                    (itertype == 0) ? FUNCTIONAL : NEWTON,
                                    (nabstol == 1) ? SS : SV,
                      &reltol, abstolp, NULL, NULL, TRUE, iopt, ropt, NULL);
            if (cvode_mem == NULL) {
                fatal_error("CVodeMalloc failed.\n");
            }
            /* Call CVDiag */
            CVDiag(cvode_mem);
        }
        progress += NHASH;
        while (progress >= (ntimes - 1) * ntraj) {
            fprintf(stderr, "#");
            progress -= (ntimes - 1) * ntraj;
        }
    }
    CVodeFree(cvode_mem);
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

integer main(integer argc, char *argv[])
{
    integer i, j, l, code;
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
    photocurflag = (argc >= 4); /* Flag indicating if photocurrent record
                                 * needed */
    if (photocurflag) {
        php = fopen(argv[3], "wb");
        if (php == NULL) {
            sprintf(errmsg, "Error writing output file: %s\n", argv[3]);
            fatal_error(errmsg);
        }
    }
    fread(&code, sizeof(integer), 1, fp);
    if (code != 3001) {
        sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 3001, code);
        fatal_error(errmsg);
    }
    fread(&N, sizeof(integer), 1, fp);  /* Size of sparse matrices */
    RHS.N = N;
    fread(&RHS.nterms, sizeof(integer), 1, fp); /* Number of RHS terms */

    fread(&nhomodyne, sizeof(integer), 1, fp);  /* Number of homodyne
                                                 * operators */
    homodyne = (struct FS *) calloc(nhomodyne, sizeof(struct FS));
    homodyne--;
    for (i = 1; i <= nhomodyne; i++) {
        homodyne[i].N = N;
        fread(&homodyne[i].nterms, sizeof(integer), 1, fp);
    }

    fread(&nheterodyne, sizeof(integer), 1, fp);  /* Number of heterodyne
                                                   * operators */
    heterodyne = (struct FS *) calloc(nheterodyne, sizeof(struct FS));
    heterodyne--;
    for (i = 1; i <= nheterodyne; i++) {
        heterodyne[i].N = N;
        fread(&heterodyne[i].nterms, sizeof(integer), 1, fp);
    }

    fread(&ncollapses, sizeof(integer), 1, fp); /* Number of collapse
                                                 * operators */
    if (ncollapses > 0) {
        fatal_error("Jump processes are not currently supported.");
    }
    Cprobs = vector(1, ncollapses);
    collapses = (struct FS *) calloc(ncollapses, sizeof(struct FS));
    collapses--;
    for (i = 1; i <= ncollapses; i++) {
        collapses[i].N = N;
        fread(&collapses[i].nterms, sizeof(integer), 1, fp);
    }

    fread(&nopers, sizeof(integer), 1, fp); /* Number of operators for which
                                             * to calculate averages */
    opers = (struct FS *) calloc(nopers, sizeof(struct FS));
    opers--;
    for (i = 1; i <= nopers; i++) {
        opers[i].N = N;
        fread(&opers[i].nterms, sizeof(integer), 1, fp);
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

    fread(&code, sizeof(integer), 1, fp);
    if (code != 2003) {
        sprintf(errmsg, "Invalid code in %s, expected %d, found %d.\n", argv[0], 2003, code);
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

    fread(&ntimes, sizeof(integer), 1, fp);
    tlist = N_VNew(ntimes, NULL); /* Get memory for time vector */
    if (tlist == NULL) {
        fatal_error("Memory allocation failure for time vector.\n");
    }
    fread(N_VDATA(tlist), sizeof(real), ntimes, fp);

/* Check that the list of times is equally spaced */

    top = Ith(tlist, 1);
    deltat = (Ith(tlist, ntimes) - top) / (ntimes - 1);
    for (i = 1; i <= ntimes; i++) {
        if (fabs(Ith(tlist, i) - top - (i - 1) * deltat) > 0.01 * deltat) {
            fatal_error("List of times must be equally spaced.\n");
        }
    }

    fread(&iseed, sizeof(integer), 1, fp);
    fread(&ntraj, sizeof(integer), 1, fp);  /* Number of trajectories to
                                             * compute */
    fread(&ftraj, sizeof(integer), 1, fp);  /* Frequency at which expectation
                                             * values are written */
    fread(&refine, sizeof(integer), 1, fp); /* Substeps between entries in
                                             * tlist over which noise is
                                             * constant */

    /* Calculate internal step size and noise amplitudes */
    dt = deltat / refine;
    namplr = 1.0 / sqrt(dt);
    namplc = 1.0 / sqrt(2.0 * dt);
    head = 0;

/* Allocate memory for noise buffers */

    if (nhomodyne > 0) {
        homnoise = N_VNew(nhomodyne, NULL);
        if (homnoise == NULL) {
            fatal_error("Memory allocation failure for homodyne noise buffer.\n");
        }
    }
    if (nheterodyne > 0) {
        hetnoiser = N_VNew(nheterodyne, NULL);
        hetnoisei = N_VNew(nheterodyne, NULL);
        if (hetnoiser == NULL || hetnoisei == NULL) {
            fatal_error("Memory allocation failure for heterodyne noise buffer.\n");
        }
    }
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

    pl = vector(1, 2 * N);      /* Storage for complex wave function */
    q = vector(1, 2 * N);       /* Temporary complex storage */

    fprintf(stderr, "Integrating stochastic differential equation, %d trajectories, %d times:\n", ntraj, ntimes);
    progress = 0;
    fprintf(stderr, "Progress: ");

    if (nopers == 0)
        for (i = 1; i <= ntraj; i++)
            sdesim(i, ntraj);
    else {
        j = 0;
        while (j < ntraj) {
            clearaver();
            for (i = 1; i <= ftraj; i++) {
                j++;
                sdesim(j, ntraj);
            }
            writeaver(j);
        }
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

    fclose(fp);
    fclose(op);

    free_vector(q, 1, 2 * N);
    free_vector(pl, 1, 2 * N);

    if (photocurflag)
        fclose(php);
    if (clrecflag)
        fclose(cp);

    /* Indicate successful completion */
    time(&long_time);           /* Get time as long integer. */
    newtime = localtime(&long_time);  /* Convert to local time. */
    fp = fopen("success.qo", "w");
    fprintf(fp, "SOLVESDE succeeded at %19s\n", asctime(newtime));
    fclose(fp);

    return 0;
}
