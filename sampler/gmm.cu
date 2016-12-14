#include <cuda.h>
#include <cmath>
#include <vector>
#include <algorithm>
#include <iostream>
#include <cstdlib>

#include <fstream>
#include <iomanip>
#include "gmm.h"
#include "utils.h"

void GMM::generate_gmm_data(){
  gaussian u = gaussian(0.2, 0.1);
  std::vector<float2>::iterator it;
  size_t count = 0;

  for(it=data.begin(),count=0; count<size/2; it++, count++){
    it->x = 0 + (0.5)*rand()/(float) RAND_MAX;
    it->y = u(it->x);
  }

  gaussian v = gaussian(0.8, 0.05);
  for(;it!=data.end(); it++){
    it->x = 0.5+ (1-0.5)*rand()/(float) RAND_MAX;
    it->y = v(it->x);
  }

  //normalize
  float marginal = 0;
  for_each(data.begin(), data.end(), 
	   [&marginal](float2 t){
	     marginal +=t.y;
	     });


  for_each(data.begin(), data.end(),[marginal](float2 &t){
      t.y/=marginal;
    });

}

void GMM::print_gmm_data(){
  std::vector<float2>::iterator it;
  for(it=data.begin(); it!=data.end(); it++){
    std::cout << it->x << " " << it->y << std::endl;
  }

}

void GMM::write_gmm_data(){
  std::vector<float2>::iterator it;
  std::ofstream fout;
  fout.open("data.txt");
  for(it=data.begin(); it!=data.end(); it++){
    fout << it->x << " " << it->y << std::endl;
  }
  fout.close();
}
  


/*
int main(){
  const int num_components=2;
  const int num_points = 1000;
  GMM gmm(num_points, num_components);
    gmm.generate_gmm_data();
    //    gmm.print_data();
    gmm.write_gmm_data();
    //    std::cout << "yes yes " << std::endl;
    //    gmm.cluster_kmeans();
  }
  */
 

