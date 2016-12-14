#ifndef GMM_H
#define GMM_H
#include <vector>

class GMM{
public:
  GMM(size_t _size, size_t _num_components):size(_size), num_components(_num_components){
    data.resize(num_components*size);
    mu.resize(num_components);
    sigma.resize(num_components);
    count.resize(num_components);
  }
    
  void generate_gmm_data();
  void print_gmm_data();
  void write_gmm_data();
  //  void train_gmm();
  //  void cluster_kmeans();

  std::vector<float2> get_gmm_data(){
    return data;
  }

  size_t num_components;
  std::vector<float> mu;
  std::vector<float> sigma;
  std::vector<int> count;

private:
  std::vector<float2> data;
  size_t size;

  


};
#endif
