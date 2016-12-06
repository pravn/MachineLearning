#ifndef SAMPLER_H
#define SAMPLER_H

#include "gmm.h"
#include <iostream>
#include <vector>

class sampler: public GMM{
 public: 
  sampler(size_t _num_points, size_t gmm_points, size_t gmm_components): 
  num_points(_num_points), GMM(gmm_points, gmm_components)
{
    data.resize(num_points);
    histogram.resize(gmm_points*gmm_components);
  }
    
  void  generate_samples();
  void print_samples();
  void write_samples();
  void cluster_kmeans();
  
 private:
  std::vector<float> data;
  std::vector<float2> histogram;
  size_t num_points;
};
  
#endif //SAMPLER_H
