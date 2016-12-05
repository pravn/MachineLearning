Machine Learning Experiments

1) sampler: Creates a fake gaussian mixture of two components. We then sample from this mixture to create our data.
   The sampler works such that the number of points generated for a given x is proportional to its probability, 
   given by the Gaussian mixture formulation. To verify, we record the data in a file called "histogram.txt" with 
   which we can read the number of occurrences of a given value x. Depending on how we tune the histogramming (binning needs some work, and depends on the number of points in the input distribution and the output data spawned from it), we will get picture that may or may not match visual inspection tests.

