#ifndef UTILS_H
#define UTILS_H
//make const
inline float pi();

struct gaussian{
  gaussian(float _mu, float _sigma): mu(_mu), sigma(_sigma){};
  
  float operator()(float y);
  
  float mu;
  float sigma;
};

float random_number();


#endif
