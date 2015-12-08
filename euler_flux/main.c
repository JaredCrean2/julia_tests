#include <cstdlib>
#include <iostream>
#include <cmath>
#include <sys/time.h>
#include <sys/resource.h>

// get time with microsection accuracy
double get_time()
{
  struct timeval t;
  struct timezone tzp;
  gettimeofday(&t, &tzp);
  return t.tv_sec + t.tv_usec*1e-6;
}  

int getInd(const int i, const int j, const int k, const int imax, const int jmax, const int kmax)
{
  return i + j*imax + imax*jmax*k;
}


void calcEulerFlux(double* q, double* dir, double* F)
{

//  std::cout << "entered calcEulerFlux" << std::endl;
  const int gamma = 1.4;
  const int gamma_1 = 0.4;

  double press = gamma_1*(q[3] - 0.5*(q[1]*q[1] + q[2]*q[2])/q[0]);
  double U = (q[1]*dir[0] + q[2]*dir[1])/q[0];
  
  F[0] = q[0]*U;
  F[1] = q[1]*U + dir[0]*press;
  F[2] = q[2]*U + dir[1]*press;
  F[3] = (q[3] + press)*U;

}

void getEulerFlux(double* q_arr, double* nrm,  int ndofPerNode, int nnodesPerElement, int numEl, double* flux)
{
  int idx_q = 0; // hold starting index of current node's q values
  int idx_nrm = 0; // hold starting index of current node's nrm values
  for (int k=0; k < numEl; k++)
  {
    for (int j=0; j < nnodesPerElement; j++)
    {
      idx_q = getInd(0, j, k, ndofPerNode, nnodesPerElement, numEl);
      idx_nrm = getInd(0, j, k, 2, nnodesPerElement, numEl);
      calcEulerFlux(q_arr + idx_q, nrm + idx_nrm, flux + idx_q);
    }
  }

} // end function getEulerFlux
      

int main()
{
  std::cout << "Hello World" << std::endl;

  const int imax = 4;  // ndofPerNode
  const int jmax = 3;  // nnodesPerEl
  const int kmax = 4000;  // numEl

  double* arr = (double *) malloc(sizeof(double)*imax*jmax*kmax);
  double* flux = (double *) malloc(sizeof(double)*imax*jmax*kmax);
  double* nrm = (double *) malloc(sizeof(double)*2*jmax*kmax);
/*
  std::cout << "arr = " << arr << std::endl;
  std::cout << "arr + 0 = " << arr + 0 << std::endl;
  std::cout << "arr + 1 = " << arr +1 << std::endl;
  std::cout << "arr + 2 = " << arr + 2 << std::endl;
  std::cout << "flux = " << flux << std::endl;
  std::cout << "nrm = " << nrm << std::endl;
*/
  for (int k = 0; k < kmax; k++)
  {
    for (int j=0; j < jmax; j++)
    {
//        std::cout << "j, k = " << j << ", " << k << std::endl;
        int idx = getInd(0, j, k, imax, jmax, kmax);
//        std::cout << "arr idx = " << idx << std::endl;
        arr[idx] = 1.0;
        arr[idx+1] = 2.0;
        arr[idx+2] = 3.0;
        arr[idx+3] = 7.0;

        flux[idx] = 0.0;
        flux[idx+1] = 0.0;
        flux[idx+2] = 0.0;
        flux[idx+3] = 0.0;


       idx = getInd(0, j, k, 2, jmax, kmax);
//       std::cout << "nrm idx = " << idx << std::endl;
       nrm[idx] = sqrt(2.0)/2.0;
       nrm[idx+1] = sqrt(2.0)/2.0;
      
      
    }
  }

  double t1 = get_time();
  double t2;  // hold final time
  getEulerFlux(arr, nrm, imax, jmax, kmax, flux);
  t2 = get_time();

  std::cout << "elapsed time = " << t2 - t1 << std::endl;
/*
  std::cout << "printing results: " << std::endl;
  for (int k = 0; k < kmax; k++)
  {
    for (int j=0; j < jmax; j++)
    {
      int idx = getInd(0, j, k, imax, jmax, kmax);
      std::cout << "arr idx = " << idx << std::endl;
      std::cout << "arr[:," << j << "," << k << "] = " << arr[idx] << ", " << arr[idx+1] << ", " << arr[idx+2] << ", " << arr[idx+3] << std::endl;
 
      std::cout << "flux[:," << j << "," << k << "] = " << flux[idx] << ", " << flux[idx+1] << ", " << flux[idx+2] << ", " << flux[idx+3] << std::endl;

      idx = getInd(0, j, k, 2, jmax, kmax);
      std::cout << "nrm idx = " << idx << std::endl;
      std::cout << "nrm = " << nrm[idx] << "," << nrm[idx+1] << std::endl;

    }
  }

*/
  
  return 0;
}
