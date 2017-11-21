# AFM_glycocalyx
Matlab coding for AFM raw data post-processing > glycocalyx stiffness fitting

This repository contains Matlab codes to process Atomic Force Microscopy raw force spectroscopy data obtained on cells with a spherical indenter.
The focus is on the cell glycocalyx (a proteoglycan-rich layer on the outer cell membrane), which should be detected by the indenter for shallow indentations.

Two models were used to obtain information on glycocalyx mechanical properties:
1. the _Hertz model_ for a spherical indenter over a half space,
2. a _non-Hertzian pointwise approach_ (see [O'Callaghan R. et al 2011](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3174749/?tool=pmcentrez))

All codes were tested on Matlab R2016a version

#### Raw data
The raw data are force-spectroscopy .txt files from AFM experiments. They contain four columns: cantilever height [m], cantilever vertical deflection [N], series time [s], segment time [s].
All the experiments in this context were carried out with a Nanowizard 3 microscope from JPK. The built-in software provide .txt files in this form (comments are preceded by #)

#### Pre-processed data
Raw data (_input_) are processed individually with the Matlab code AFM1_contactpoint.m.
This code is needed to:
* fit the contact point with the ratio-of-variance method (see [Gavara N. 2016](https://www.nature.com/articles/srep21267)),
* ask the user if happy with the contact point fitting,
* correct the drift between extend and retract baselines,
* correct for tip-sample separation.
Pre-processed data are obtained as _output_.

#### Glycocalyx properties
Two models were used to obtain the glycocalyx properties from the pre-processed data.
The first model is the Hertz model for a spherical indenter over a half space (_output_: Young's modulus for increasing indentation dephts); the second model uses the point-wise approach (_output_: pointwise Young's modulus for increasing indentation dephts).

1. _Hertz model_ for a spherical indenter on a half space to obtain Young's modulus for increasing indentation depths
Pre-processed data are fitted individually with the Matlab code AFM2a_youngmodulus.m.
This code does the following:
    * takes as _input_ the pre-processed data,
    * calculates the Young's modulus for increasing indentation depths by Hertz fitting (through the function createFitHertz.m),
    * gives as _output_ a summary .xslx file containing the Young's modulus for each indentation depth for each file.
2. _Non-Hertzian pointwise approach_ to obtain pointwise Young's modulus
Pre-processed data are fitted individually with the Matlab code AFM2b_pointwise.m.
This code does the following:
    * takes as _input_ the pre-processed data,
    * calculates the pointwise Young's modulus,
    * gives as _output_ a summary .xslx file containing the Young's modulus for each indentation depth for each file.

#### Detailed code description
##### AFM1_contactpoint.m
This algorithm takes raw file from AFM microscope (.txt) as input and fit the contact point, correct retract drift and tip-sample separation.
New .txt files are saved as output in a folder of choice containing cantilever height, vertical deflection, time and segment.

1. _INPUT_ - information about the performed AFM experiment need to be entered by the user (spring constant of the cantilever used, input folder and Matlab working folder)   
2. open input folder and list file names for next step
3. FOR cycle which opens one file at the time from the input folder and perform post-processing steps
    1. open file
    2. save data from file into arrays
    3. fit contact point on extend curve
    4. plot data after fitting the CP for user verification
    5. save pre-processed file as .txt files in the output folder

##### AFM2a_youngmodulus.m
This algorithm fits the Hertz model for a spherical indenter on a half space for increasing indentation depths.
It takes the files saved with AFM1_contactpoint.m as input and give as output the Young's modulus for each indentation depth for each file (saved as .xslx file).

1. _INPUT_ - information about the performed AFM experiment need to be entered by the user (indenter radius, input folder and Matlab working folder)
2. open input folder and list file names for next step
3. initialize output arrays
4. FOR cycle which opens one file at the time and perform post-processing steps
    1. open file
    2. save data from file into arrays
    3. find **Young's modulus for increasing indentation depths** (calls createFitHertz.m)
    4. save output for opened file
5. save summary output file for all files

##### AFM2b_pointwise.m
This algorithm fits the Hertz model for a spherical indenter on a half space for increasing indentation depths.
It takes the files saved with AFM1_contactpoint.m as input and give as output the Young's modulus for each indentation depth for each file (saved as .xslx file).

1. _INPUT_ - information about the performed AFM experiment need to be entered by the user (indenter radius, input folder and Matlab working folder)
2. open input folder and list file names for next step
3. initialize output arrays
4. FOR cycle which opens one file at the time and perform post-processing steps
    1. open file
    2. save data from file into arrays
    3. find **pointwise Young's modulus for increasing indentation depths**
    4. save output for opened file
5. save summary output file for all files
