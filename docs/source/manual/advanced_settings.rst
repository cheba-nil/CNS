Advanced settings for WMH segmentation
======================================

DARTEL Template
---------------

UBO Detector offers three options for DARTEL templates:

 - *Existing templates for 65 to 75 years old* - The templates were generated from Older Australian Twins Study (OATS) with participants aged 65-75 years. The templates have been embedded in the release of UBO Detector.

 - *Existing templates for 70 to 80 years old* - The templates were from Sydney Memory and Ageing Study (Sydney MAS) with older adults aged 70 to 80 years. The templates have been included in the release of UBO Detector.

 - *Creating templates* - This option will generate sample-specific templates. This option will take longer time than the existing templates options.

k for kNN
---------

The number of neighbours to search for in the n-dimension space, where n is the number of features. A 'k=5' works well from our experiences.

kNN training set
-----------------

UBO Detector includes a built-in training set of manually selected WMH and non-WMH clusters from five Sydney MAS participants. A larger training set will be included in future release of UBO Detector.

Probability threshold
---------------------

The output from the kNN step includes a probability map indicating the ratio of the number of the 'WMH' votes in the nearest k neighbours to k, the total number of neighbours involved in the voting. From our experiences, a probability threshold of 0.7 works well with k=5, i.e. in the five nearest neighbours, at least four voting ‘WMH’ indicates that the enquiry cluster is likely to be a WMH region.
