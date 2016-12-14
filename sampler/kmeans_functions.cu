#include "gmm.h"
#include "sampler.h"
#include <vector> 
#include <cassert>
#include <iostream>
#include <algorithm>
#include "utils.h"

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
void iterate_mu(float x, std::vector<float> mu, std::vector<float> &mu_new, std::vector<float> &sigma, std::vector<int> &count){
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
  sigma[i_k] += J;

 }


void sampler::cluster_kmeans(){
  //initialize r_nk, mu_k
  std::cout << "in cluster_kmeans" << std::endl;
  float J=0; //distance/cost function
  //  std::vector<float>mu(num_components);
  //  std::vector<int> count(num_components);
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
    std::fill(sigma.begin(), sigma.end(), 0);

  for(it=data.begin(); it!=data.end(); it++){
    iterate_mu(*it, mu, mu_new, sigma, count);
  }

  for(int i=0; i<num_components; i++){
    mu_new[i] = mu_new[i]/count[i];
  }

  mu = mu_new;

  for(int i=0; i<num_components; i++){
    sigma[i] = sigma[i]/count[i];
  }


  std::cout << " m " <<  mu_new[0] << " m " << mu_new[1] << " s " << sqrtf(sigma[0]) << " s " << sqrtf(sigma[1]) << " c " << count[0] << " c " << count[1] << std::endl;  


  }

  std::cout << "Done with cluster_kmeans" << std::endl;
}
  

void sampler::train_gmm(){
  //Assume two clusters 
  //step 1 
  //compute responsibilities 
  //gamma(z_nk) = w_k N(x_n|mu_k, sigma_k)/(sum_j w_j N(x_n|mu_j, sigma_j)


  std::cout << "Starting training gmm " << std::endl;

  float *gamma_nk;
  float *mu_k;
  float *sigma_k;
  float *weights_k;
  float *N_k;
  float *sum_gamma;


  gamma_nk = new float[num_components*num_points];
  mu_k = new float[num_components];
  sigma_k = new float[num_components];
  weights_k = new float[num_components];
  N_k = new float[num_components];
  sum_gamma = new float[num_points];


  //need to assume mu, sigma;
  /*  for(int i=0; i<num_components; i++){
    mu_k[i] = rand()/ (float) RAND_MAX;
    sigma_k[i] = rand()/(float) RAND_MAX;
    weights_k[i] = rand()/ (float) RAND_MAX;
    }*/


  mu_k[0] = 0.1;
  sigma_k[0] = 0.016;
  mu_k[1] = 0.6;
  sigma_k[1] = 0.55;

  weights_k[0] = 0.5;
  weights_k[1] = 0.5;
				      

  //normalize weights;
  float marginal = 0;
  for (int i=0; i<num_components; i++){
    marginal += weights_k[i];
  }


  for(int i=0; i<num_components; i++){
    weights_k[i]/=marginal;
  }

  //begin iterations
  for(int iter = 0; iter<200; iter++){


    for(int i=0; i<num_points; i++){
      sum_gamma[i] = 0;
    }

  //compute responsibilities;
  for(int i=0; i<num_points; i++){


    for(int j=0; j<num_components; j++){
      gaussian g(mu_k[j], sqrtf(sigma_k[j]));
      float y = data[i];
      gamma_nk[i*num_components+j] = weights_k[j]*g(y);
      sum_gamma[i] += weights_k[j]*g(y);


    }
  }

  for(int i=0; i<num_points; i++){
    for(int  j=0; j<num_components; j++){
            gamma_nk[i*num_components+j]/=sum_gamma[i];
    }
  }


  for(int i=0; i<num_components; i++){
    N_k[i] = 0;
  }


  for(int i=0; i<num_points; i++){
    for(int j=0; j<num_components; j++){
      N_k[j] += gamma_nk[i*num_components+j];
    }
  }

  for(int i=0; i<num_components; i++){
    mu_k[i] = 0;
  }


  for(int i=0; i<num_points; i++){
    for(int j=0; j<num_components; j++){
      mu_k[j] += 1.0/N_k[j] * gamma_nk[i*num_components+j]*data[i];
    }
  }

  for(int i=0; i<num_components; i++){
    sigma_k[i] = 0;
  }



  for(int i=0; i<num_points; i++){
    for(int j=0; j<num_components; j++){
      sigma_k[j] += 1.0/N_k[j]*gamma_nk[i*num_components+j]*(data[i]-mu_k[j])*(data[i]-mu_k[j]);
    }
  }

  for(int j=0; j<num_components; j++){
    weights_k[j] = N_k[j]/num_points;
  }

  std::cout << " N " <<  N_k[0] << " N " << N_k[1] << " N " << num_points << std::endl;
  std::cout << " w " <<  weights_k[0] << " w " << weights_k[1] << std::endl;
  std::cout << " m " << mu_k[0] << " m " << mu_k[1] << std::endl;
  std::cout << " s " << sqrtf(sigma_k[0]) << " s " << sqrtf(sigma_k[1]) << std::endl;

  }

  

  

  std::cout << "Done training gmm " << std::endl;
  
  delete[] gamma_nk;
  delete[] mu_k;
  delete[] sigma_k;
  delete[] N_k;
  delete[] weights_k;
  delete[] sum_gamma;
}
    

    


  

    


  
  
