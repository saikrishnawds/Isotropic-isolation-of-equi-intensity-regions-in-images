# Isotropic-isolation-of-equi-intensity-regions-in-images
This repository has my group's implementation of Laplacian Blob detection from scratch 

PROJECT STATEMENT:
-----------------
Implementing Blob detection by designing all functions from scratch.

ALGORITHM:
----------
1. Convert image to grayscale if the image is in RGB scale initially.
2. Generate a scale space of laplacian. We have performed the scalespace generation with a function “gen_scalespace(image)”.
3. Next, we perform non maximum suppression on the various scales that have been generated. This is done by a function “nms(image,sigma)”.
4. After suppressing the non maxima values, we plot circles in the regions that have no intensity changes using the different sigma values as radii.
5. Thus the output after step 4 results in the image with the blobs being detected.

FUNCTIONS CREATED :
-----------------------
1. gen_scalespace(image):
Input: Image
Output: Scale space of input image
Working:
The function evaluates the scalespace by taking different sigma values and applying the LOG kernel on it. The kernel size depends on the sigma for each scale. Here, we have taken a single size image and varied over the range of sigma values.

2. nms(image,sigma):
Input: Scalespace image, sigma values
Working:
The function considers three layers of the scalespace at once to compare and eliminate the non maxima values. Once maximas are found, the circles are directly drawn at that position in correspondence to the sigma value as radii.
Radii = square_root(2)* sigma

The function for convolution was reused from project 2.

PROBLEM FACED DURING IMPLEMENTATION AND RESOLVING THEM:
Occurrence of concentric circles:
We compared all layers for non-maximum suppression, but this detected only one maximum in all the layers. So, the detection of blobs wasn’t efficient and only very limited number of blobs were detected. So, we changed the code style to consider 3 layers at a time; rather than considering all the layers at a time.

GROUP MEMBERS:
1. SURENDAR (UNITY ID :skotte)
2. SUDHARSHANA(UNITY ID :skrish28)
3. SAI KRISHNA W.D.S(UNITY ID :swupadr)
