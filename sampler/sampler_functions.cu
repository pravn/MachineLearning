#include <iostream>
#include <vector>
#include <algorithm>
#include "sampler.h"
#include <fstream>
#include <cuda.h>

void sampler::generate_samples(){
  generate_gmm_data();
  std::vector<float2> gmm_data = get_gmm_data();
  size_t c=0;


  for_each(gmm_data.begin(), gmm_data.end(), 
	   [this, &c](float2 t){
	     float epsilon = 100.0f;
	     std::vector<float> &data = this->data;
	     
	     int n = this->num_points*t.y;
	     //	     std::cout << t.y << std::endl;
	     auto x = t.x;
	     std::fill(data.begin()+c, data.begin()+c+n, x);
	     c +=n;
	     histogram.push_back(make_float2(x, n));

	   });

}

void sampler::print_samples(){
  for(int i=0; i<data.size(); i++){
    std::cout << data[i] << std::endl;
  }
}

void sampler::write_samples(){
  std::ofstream fout;
  fout.open("samples.txt");
  for(int i=0; i<data.size(); i++){
    fout << data[i] << std::endl;
  }
  fout.close();

  fout.open("histogram.txt");
  std::vector<float2>::iterator it;
  for(it=histogram.begin(); it!=histogram.end(); it++){
    fout << it->x << " " << it->y << std::endl;
  }
  fout.close();

}
    

