#include "utils.h"
inline float pi() { return std::atan(1)*4.0;}

  float gaussian::operator()(float y){
    return 1.0/sqrtf(2.0f*pi()*sigma*sigma)*exp(-(y-mu)*(y-mu)/(2*sigma*sigma));
   }

float random_number(){
  float u = rand();
  return u/(float) RAND_MAX;
};
