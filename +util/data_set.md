This data set was created with PSDC.

Power system data set that is for machine learning.

The operating points are in the *_setpoints.csv file. Each row represents an operating point. Each column represents a decision variable. The colomns follow each other in natural order sorting, e.g., PG2,PG3,...,PGN,VG1,VG2,...,VGN where the system has N generators and PG1 is the active power output of the slack generator.

The binary classification of the operating points is in the *_labels.csv file. 1 - denotes feasbile/stable and 0 denotes infeasible/unstable oprating point. The first column of this file is the overall classification, the following columns are classifications per criterion. 

For more information about the data set and the generation methodology visit: [https://github.com/timonviola/PSDC](https://github.com/timonviola/PSDC).



Copyright (C) 2020 Timon Viola
For further information see the LICENSE file.