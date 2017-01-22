# NRMethod
NRmethod for Load Flow analysis



**************************List of Files*******************************************************
The NRMethod code has 4 files.They are listed as below
1) NRmethod - This is the main function that is used to calculate the power flow. This function internally uses the following 3 files
2) creatYBus - This is function that is invoked for creating the Y-Bus matrix. This function takes the branch data matrix and the number
of buses as the input and outputs the Y-bus taking into consideration of the tap ratios.
3) Utilities - This MATLAB class is a static implementation. It has some public methods to assist the power flow algorithm calculations.
The methods are
	a) isGeneratorBus(busData, currRow) - To identify if the current bus is a generator bus or not.
	b) thetaij(thetaMatrix, irow, jrow) - To calc the difference between thetai nad thetaj
	c) deleteRows (theMatrix, rowsToDelete) - To delete some rows
	d) addRows(theMatrix, rowsToAdd, valueToAdd) - To add some rows
	e) isConverged(theMatrix,errorTolerance) - to check convergence
	f) rad2deg(angleInRadians) - radians to degree conversion.
4) BusDataConstants - Has a set of constants that act as a data mapping... if there is a change in the order of the coloumns, simply change the constants here.

**************************How to execute*****************************************************
Open MATLAB command window. Select a current working directory and put the above four files to the current working directory with the input data in the file by the name "Inpt.m".
On the command prompt type in NRMethod and press enter.
The code will read the input file and display the values calculated on the command prompt. Also the results are written to an excel sheet. The values that are displayed are the bus numbers, the voltages and the angle thetas.

*********************************************************************************************
