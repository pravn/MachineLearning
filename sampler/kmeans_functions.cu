#include "gmm.h"
#include "sampler.h"
#include <vector> 
#include <cassert>
#include <iostream>
#include <algorithm>

void zero_out(std::vector<float> mu, std::vector<float> mu_new, std::vector<int> count, size_t num_components){
  assert((mu.size()==count.size())&&(mu.size()==num_components));
  for(size_t i=0; i<num_components; i++){
    mu[i] = 0.0f;
    mu_new[i] = 0.0f;
    count[i] = 0;
  }
}
    

void init_mu(std::vector<float> &mu, std::vector<float> data){
  float y = 0;
  for_each(data.begin(), data.end(), [&y](float t){
      y = (y>t)?y:t;
    });

  std::cout << "max " << y << std::endl;
      
  
 for_each(mu.begin(), mu.end(), [y](float &mu){
      mu = y * rand()/(float) RAND_MAX;
      });

  /*     mu[0] = 0.5;
	 mu[1] = 0.6;*/
    
  std::cout << "mu[0], mu[1] " << mu[0] <<  " " << mu[1] << std::endl;
  
}


inline float squared_distance(float x, float mu){
  return (x-mu)*(x-mu);
}

//iterative estimates of cluster means
//naturally, we will have to redo all this when we get to CUDA
void iterate_mu(float x, std::vector<float> mu, std::vector<float> &mu_new, std::vector<int> &count){
  float J=100.0;
  int i_k=0;
  float D;

  for(int i=0; i<mu.size(); i++){
    if((D = squared_distance(x,mu[i]))<J){
    
      J = D;
      i_k = i;

    }

  }


  count[i_k]++;
  mu_new[i_k] += x;

 }


void sampler::cluster_kmeans(){
  //initialize r_nk, mu_k
  std::cout << "in cluster_kmeans" << std::endl;
  float J=0; //distance/cost function
  std::vector<float>mu(num_components);
  std::vector<int> count(num_components);
  std::vector<float>mu_new(num_components);

  zero_out(mu, mu_new, count, num_components);
  init_mu(mu, data);

  for(int i=0; i<num_components; i++){
    std::cout << mu[i] << " r  " << mu_new[i] << std::endl; 
  }
  
  std::vector<float>::iterator it;

  for(int j=0; j<10; j++){

    std::fill(mu_new.begin(), mu_new.end(), 0);
    std::fill(count.begin(), count.end(), 0);

  for(it=data.begin(); it!=data.end(); it++){
    iterate_mu(*it, mu, mu_new, count);
  }

  for(int i=0; i<num_components; i++){
    mu_new[i] = mu_new[i]/count[i];
  }

  mu = mu_new;
  std::cout << mu_new[0] << " s " << mu_new[1] << " c " << count[0] << " c " << count[1] << std::endl;  

  }

  std::cout << "Done with cluster_kmeans" << std::endl;
}
  
 
