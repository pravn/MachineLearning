#include <iostream>
#include <vector>
#include <algorithm>
#include "sampler.h"
#include <fstream>
#include <cuda.h>


int main(){
  // ask for 100000 points to be sampled from distribution
  // we create a mixture distribution consisting of two gaussian components
  sampler S(100000, 1000, 2);
  S.generate_samples();
  S.write_samples();
  S.write_gmm_data();
  S.cluster_kmeans();

}



