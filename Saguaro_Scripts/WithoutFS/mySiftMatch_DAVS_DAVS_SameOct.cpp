#include"mexutils.c"
#include<stdlib.h>
#include<string.h>
#include<math.h>

//#ifdef WINDOWS
#undef min
#undef max
#undef abs
#undef greater
#undef sqrtf
#ifndef __cplusplus__
#define sqrtf(x) ((float)sqrt((double)x)
#define greater(a,b) (((double)a) > ((double)b))
#define min(a,b) ((((double)a)<((double)b))?((double)a):((double)b))
#define max(a,b) ((((double)a)>((double)b))?((double)a):((double)b))
#define abs(a) (((double)a>0)?((double)a):((-1.0)*(double)a))
#endif
//#endif


/*typedef struct
 * {
 * int k1 ;
 * int k2 ;
 * double score ; double accum ;
 * } Pair ;*/


typedef struct
{
    int k1 ;
    int k2 ;
    double matchingScore; double pruneScore ;
} Pair ;



void
        mexFunction(int nout, mxArray *out[],
        int nin, const mxArray *in[])
{
    int K1, K2, ND, KFeature1, KFeature2, NDFeature1, NDFeature2, maxTime1, minTime1, maxTime2, minTime2;
    double avgMinScope;
    double VDminScope1;
    double VDminScope2;
    double VDmaxScope1;
    double VDmaxScope2;
    
    
    double VTminScope1;
    double VTminScope2;
    double VTmaxScope1;
    double VTmaxScope2;
    
    
    
    double variateSize;
    double* L1_pt ;
    double* L2_pt ;
    double* Feature1_pt;
    double* Feature2_pt;
    double* amp1_pt;
    double* amp2_pt;
    //double thresh = 1.5 ;
    mxClassID data_class ;
    enum {L1=0,L2, F1, F2, maxT1, minT1, maxT2, minT2, minScope, IndexAmp1, IndexAmp2, DminScope1, DminScope2, DmaxScope1, DmaxScope2, TminScope1, TminScope2, TmaxScope1, TmaxScope2, MVariateSize} ;
    //enum {MATCHES=0,D} ;
    enum {MATCHES=0,D, K} ;
    
    
    
    
    
    
    /* ------------------------------------------------------------------
     **                                                Check the arguments
     ** --------------------------------------------------------------- */
    if (nin < 2) {
        mexErrMsgTxt("At least two input arguments required");
    } else if (nout > 3) {
        mexErrMsgTxt("Too many output arguments");
    }
    
    if(!mxIsNumeric(in[L1]) ||
            !mxIsNumeric(in[L2]) ||
            mxGetNumberOfDimensions(in[L1]) > 2 ||
            mxGetNumberOfDimensions(in[L2]) > 2) {
        mexErrMsgTxt("L1 and L2 must be two dimensional numeric arrays") ;
    }
    
    K1 = mxGetN(in[L1]) ;//column
    K2 = mxGetN(in[L2]) ;
    ND = mxGetM(in[L1]) ;//row
    KFeature1 = mxGetN(in[F1]) ;//KFeature1 = K1
    KFeature2 = mxGetN(in[F2]) ;//KFeature2 = K2
    NDFeature1 = mxGetM(in[F1]) ;//NDFeature1 = NDFeature2
    NDFeature2 = mxGetM(in[F2]) ;
    maxTime1 = (int)(*mxGetPr(in[maxT1])) ;
    minTime1 = (int)(*mxGetPr(in[minT1])) ;
    maxTime2 = (int)(*mxGetPr(in[maxT2])) ;
    minTime2 = (int)(*mxGetPr(in[minT2])) ;
    
    avgMinScope = (double)(*mxGetPr(in[minScope])) ;
    
    VDminScope1 = (double)(*mxGetPr(in[DminScope1])) ;
    VDminScope2 = (double)(*mxGetPr(in[DminScope2])) ;
    VDmaxScope1 = (double)(*mxGetPr(in[DmaxScope1])) ;
    VDmaxScope2 = (double)(*mxGetPr(in[DmaxScope2])) ;
    
    
    VTminScope1 = (double)(*mxGetPr(in[TminScope1])) ;
    VTminScope2 = (double)(*mxGetPr(in[TminScope2])) ;
    VTmaxScope1 = (double)(*mxGetPr(in[TmaxScope1])) ;
    VTmaxScope2 = (double)(*mxGetPr(in[TmaxScope2])) ;
    variateSize = (double)(*mxGetPr(in[MVariateSize])) ;
    
    amp1_pt = (double*)mxGetData(in[IndexAmp1]);
    amp2_pt = (double*)mxGetData(in[IndexAmp2]);
    
    if(mxGetM(in[L2]) != ND) {
        mexErrMsgTxt("L1 and L2 must have the same number of rows") ;
    }
    
    data_class = mxGetClassID(in[L1]) ;
    if(mxGetClassID(in[L2]) != data_class) {
        mexErrMsgTxt("L1 and L2 must be of the same class") ;
    }
    
    L1_pt = (double*)mxGetData(in[L1]) ;
    L2_pt = (double*)mxGetData(in[L2]) ;
    Feature1_pt = (double*)mxGetData(in[F1]) ;
    Feature2_pt = (double*)mxGetData(in[F2]) ;
    
    
    /* ------------------------------------------------------------------
     **                                                         Do the job
     ** --------------------------------------------------------------- */
    {
        
        Pair* pairs_begin = (Pair*) mxMalloc(sizeof(Pair) * (K1+K2)) ;
        /*   Pair* pairs_begin = (Pair*) mxMalloc(sizeof(Pair) * 2 * (K1+K2)) ;*/
        Pair* pairs_iterator = pairs_begin ;
        
        int k1, k2 ;
        double minval = (-1.0)*mxGetInf() ;
        for(k1 = 0 ; k1 < K1 ; ++k1, L1_pt += ND, Feature1_pt += NDFeature1,amp1_pt += 1)
        {
            double second_best = minval ;  double best = minval; int second_bestk = -1 ; 
            double bestAcc = 0; double bestTimeScore=0; double bestAmp1 = 0; double bestAmp2=0;double bestAmpSim=0;
            double bestTempScopet=0;
            
            double depd1 = Feature1_pt[0];
            double tcenter1 = Feature1_pt[1];  
            double dscope1 = 3*Feature1_pt[2];
            double tscope1 = 3*Feature1_pt[3];
            double depdOctave_1 = Feature1_pt[4];
            double timeOctave_1 = Feature1_pt[5];
            
            double bestPruneScore = 0;
            double amp1Value = amp1_pt[0];
            
            int bestk = -1 ;double accum = 0;
            double ts1 = tcenter1 - tscope1; double te1 = tcenter1+tscope1;
            
            /* For each point P2[k2] in the second image... */
            for(k2 =  0 ; k2 < K2 ; ++k2, L2_pt += ND, Feature2_pt += NDFeature1, amp2_pt += 1)
            {
                double depd2 = Feature2_pt[0];
                double tcenter2 = Feature2_pt[1];   
                double dscope2 = 3*Feature2_pt[2];
                double tscope2 = 3*Feature2_pt[3];
                double depdOctave_2 = Feature2_pt[4];
                double timeOctave_2 = Feature2_pt[5];
                
                double amp2Value = amp2_pt[0];
                double ts2 = tcenter2-tscope2; 
                double te2=tcenter2+tscope2;
                
                int dbin ;
                double acc = 0 ;
                for(dbin = 0 ; dbin < ND ; ++dbin) {
                    double delta =
                            (L1_pt[dbin]) -
                            (L2_pt[dbin]) ;
                    acc += delta*delta ;
                }
                double shapeDiff = 0;
                if((depdOctave_1 != depdOctave_2) || (timeOctave_1 != timeOctave_2))
                {
                    shapeDiff = 1;
                }
                acc = (1 - shapeDiff) /(1+sqrt(acc));
                
                double tempAmpValue = amp1Value - amp2Value;
                double ampSimlarity = 1/(1+abs(tempAmpValue));
                
                /*double sim = acc*ampSimlarity;
                double matchingScore = acc;*/
                double DS = (dscope1 + dscope2)/2;
                double matchingScore = acc * DS;
                
                double pruneScore = acc * DS;
                
                /* Filter the best and second best matching point. */
                if(matchingScore > best) {
                    second_best = best ; second_bestk = bestk ;
                    best = matchingScore ;
                    bestk = k2 ;
                    
                    bestPruneScore = pruneScore;
                    
                } else if(matchingScore > second_best) {
                    second_best = matchingScore ;
                }
                
            }
            /*jump back to BEGINNING to match the same one*/
            L2_pt -= ND*K2 ;
            Feature2_pt -= NDFeature1*K2;
            amp2_pt -= K2;
            /* Lowe's method: accept the match only if unique. */
            if(bestk != -1) {
                pairs_iterator->k1 = k1 ;
                pairs_iterator->k2 = bestk ;
                pairs_iterator->matchingScore = best ;
                pairs_iterator->pruneScore = bestPruneScore ;
                pairs_iterator++ ;
            }
        }
        
        /*return pairs_iterator ;  */
        /* ---------------------------------------------------------------
         *                                                        Finalize
         * ------------------------------------------------------------ */
        {
            Pair* pairs_end = pairs_iterator ;
            double* M_pt ;
            double* D_pt = NULL ;
            double* K_pt = NULL ;
            
            out[MATCHES] = mxCreateDoubleMatrix
                    (2, pairs_end-pairs_begin, mxREAL) ;
            
            M_pt = mxGetPr(out[MATCHES]) ;
            
            if(nout > 1) {
                out[D] = mxCreateDoubleMatrix(1,
                        pairs_end-pairs_begin,
                        mxREAL) ;
                D_pt = mxGetPr(out[D]) ;
                
                out[K] = mxCreateDoubleMatrix(2,
                        pairs_end-pairs_begin,
                        mxREAL) ;
                K_pt = mxGetPr(out[K]) ;   
            }
            for(pairs_iterator = pairs_begin ;
            pairs_iterator < pairs_end  ;
            ++pairs_iterator) {
                *M_pt++ = pairs_iterator->k1 + 1 ;
                *M_pt++ = pairs_iterator->k2 + 1 ;
                if(nout > 1) {
                    *D_pt++ = pairs_iterator->matchingScore ;
                    *K_pt++ = pairs_iterator->matchingScore ;
                    *K_pt++ = pairs_iterator->pruneScore ;
                }
            }
        }
        mxFree(pairs_begin) ;
    }
}