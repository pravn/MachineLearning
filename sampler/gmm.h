#ifndef GMM_H
#define GMM_H
#include <vector>

class GMM{
public:
  GMM(size_t _size, size_t _num_components):size(_size), num_components(_num_components){
    data.resize(num_components*size);
  }
    
  void generate_gmm_data();
  void print_gmm_data();
  void write_gmm_data();
  void train_gmm();
  //  void cluster_kmeans();

  std::vector<float2> get_gmm_data(){
    return data;
  }

  size_t num_components;

private:
  std::vector<float2> data;
  size_t size;

  


};
#endif
