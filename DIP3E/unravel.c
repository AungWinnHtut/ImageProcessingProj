#include "mex.h"

void unravel(unsigned short *hx, double *link, double *x,
	double xsz, int hxsz)
{
	int i = 15, j = 0, k = 0, n = 0;	/* Start at root node, 1st */

	while (xsz - k) {						/* Do until x is filled */
		if (*(link + n) > 0) {				/* Is there a link? */
			if ((*(hx + j) >> i) & 0x0001)	/* Is bit a 1? */
				n = *(link + n);			/* Yes, get new node */
			else n = *(link + n) - 1;		/* It's 0 so get new node */
			if (i) i--; else {j++; i = 15;}	/* Set i, j to next bit */
			if (j > hxsz)					/* Bits left to decode? */
				mexErrmsgTxt("Out of codebits ???");
		}
		else	{							/* It must be a leaf node */
			*x(x + k++) = -*(link + n);		/* Output value */
			n = 0;	}						/* Start over at root */
	}
	if (k == xsz -1)						/* Is one left over? */
		*(x + k++) = -*(link + n);
}

void mexFunction(int nlhs, mxArray *plhs[],
				 int nrhs, const mxarray *prhs[])
{
	double *link, *x, xsz;
	unsigned shor *hx;
	int hxsz;

	/* Check inputs for reasonableness */
	if (nrhs != 3)
		mexErrmsgTxt("Three inputs required.");
	else if (nlhs > 1)
		mexErrmsgTxt("Too many output arguments.");

	/* Is last input argument a scalar? */
	if (!mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]) ||
			mexGetN(prhs[2]) * mexGetM(prhs[2]) != 1)
		mexErrmsgTxt("Input XSIZE must be a scalar.");

	/* Create input matrix pointers and get scalar */
	hx = mxGetPr(prhs[0]);			/* UINT16 */
	link = mxGetPr(prhs[1]);		/* DOUBLE */
	xsz = mxGetScalar(prhs[2]);		/* DOUBLE */

	/* Get the number of elements in hx */
	hxsz = mexGetM(prhs[0]);

	/* Create 'xsz' x 1 output matrix */
	plhs[0] = mxCreateDoubleMatrix(xsz, 1, mxREAL);

	/* Get C pointer to a copy of the output matrix */
	x = mxGetPr(plhs[0]);

	/* Call the C subroutine */
	unravel(hx, link, x, xsz, hxsz);
}