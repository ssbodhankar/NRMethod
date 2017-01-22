% Clearing of all the variables in the workspace. This done to reset the
% variables used in the entire programs
clear all;
% clc;
% We assume that the "Inpt.m" file in the same location as this file and is
% in the current directory of the MATLAB.

Inpt;

dimensions = size(bus);
numberOfBuses = dimensions(1,1); %Hardcoding it to 1 as the dimension Matrix is the is a 1x1 Matrix.

busDataMatrix = bus;
for currRow = 1:numberOfBuses
  if(Utilities.isGeneratorBus(busDataMatrix,currRow))    
    numOfGenBuses = currRow;
  end
end

% Make the PQThetaV buses
% Calculation of the Pspecified for each of the buses
Pg = busDataMatrix(:,BusDataConstants.PgColoumn);
Pl = busDataMatrix(:,BusDataConstants.PlColoumn);
Psp = (Pg - Pl)/Sb;

% Calculation of the Qspecified for each of the buses
Qg = busDataMatrix(:,BusDataConstants.QgColoumn);
Ql = busDataMatrix(:,BusDataConstants.QlColoumn);
Qsp = (Qg - Ql)/Sb;

% Creation of the Voltage Matrix. 
% The logic is setting all the Values as given for the Voltage controlled
% bus and as 1 for all the Load Buses.
Vbus = ones(numberOfBuses,1);
for currRow = 1: numberOfBuses
    if(Utilities.isGeneratorBus(busDataMatrix, currRow))
        Vbus (currRow,1) = busDataMatrix(currRow,BusDataConstants.KvRegColoumn)/busDataMatrix(currRow,BusDataConstants.KvNomColoumn);
    end
end

% Creating the YBus Matrix
yBusMatrix = createYBus(brnch,numberOfBuses);
% Defining the Thetas and the Pis and Qis
thetas = zeros(numberOfBuses,1);

for currItr = 1: mxitr
%   calculate the PiofX and QiofX
    PiofX = zeros(numberOfBuses,1);
    QiofX = zeros(numberOfBuses,1);

    for i = 1:numberOfBuses
        Vi = Vbus(i,1);
        for j = 1:numberOfBuses
            thetaij = Utilities.thetaij(thetas,i,j);
            Vj = Vbus(j,1);
            PiofX (i,1) = PiofX(i,1)+(Vj*(real(yBusMatrix(i,j))*cos(thetaij) + imag(yBusMatrix(i,j))*sin(thetaij)));
            QiofX (i,1) = QiofX(i,1)+(Vj*(real(yBusMatrix(i,j))*sin(thetaij) - imag(yBusMatrix(i,j))*cos(thetaij)));
        end
        PiofX (i,1) = Vi*PiofX (i,1);
        QiofX (i,1) = Vi*QiofX (i,1);
    end

    % Calculate the Mismatches
    deltaP = Psp - PiofX;
    deltaQ = Qsp - QiofX;

    % The deltaP and deltaQ and QiofX are for all the elements and not for the Unknowns.
    % Therefore finding out the delP and delQ for the Specific Unknowns.
    
    % delP defines the thetas. Thetas is known for the slack bus alone.
    % Therefore the number of Unknown thetas is n-1 (n=number of buses)
    delP = bsxfun(@rdivide, deltaP,Vbus);
    delP = Utilities.deleteRows(delP,BusDataConstants.numberOfSlackBuses);

    % delQ defines the Voltages. Voltages are known for the generator buses and the slack bus.
    % Therefore the number of Unknown Voltages is n-m (n=number of buses, m = number of generator buses.)
    delQ = bsxfun(@rdivide, deltaQ,Vbus);
    delQ = Utilities.deleteRows(delQ,numOfGenBuses);
    
    % check for the convergence of the matrices. If all the elements
    % converge then break the loop.
    if((Utilities.isConverged(delP,econv)))
        if((Utilities.isConverged(delQ , econv)))
            break;
        end
    end
    
    % Now Calculating the errors
    % Step 1: Find the B' and B". To find B' we use the following fact
    % B' = B1 = Matrix of the order (n-1) x (n-1) with the 1st row and coloumn of
    % the YBus Eliminated
    % B" = B2 = Matrix of the order of (n-m)x(n-m) with the first m rows and coloums
    % of the Ybus being eliminated (i.e. the PV or the Voltage controlled Buses)
    B1 = -imag(yBusMatrix);
    B1(1,:) = [];
    B1(:,1) = [];

    B2 = -imag(yBusMatrix);
    B2 = Utilities.deleteRows(B2,numOfGenBuses);


    % Step 2: This is the change in the deltaTheta and deltaV for the specific
    % buses for the next iteration.
    deltaTheta = B1\delP;
    deltaV = B2\delQ;
    
    %  Adding the 0s to the delta Matrix to make the matrix same as the
    %  Vbus and thetas matrix.
    deltaTheta = Utilities.addRows(deltaTheta,BusDataConstants.numberOfSlackBuses,0);
    deltaV = Utilities.addRows(deltaV,numOfGenBuses,0);
    
    %  Incrementing the Theta and the Vbus matrix
    thetas = thetas + deltaTheta;
    Vbus = Vbus + deltaV;
    
end
% Logic for displaying the results in an excel sheet and on the MATLAB
% command prompt window.
sheetTitles = {'Bus' 'Voltage' 'Theta(degrees)'};
output = [bus(:,1),Vbus,Utilities.rad2deg(thetas)];
% Calculate the range for displaying the results on an excel sheet
location = sprintf('A2:C%d',1 + numberOfBuses);
try
%     Print the coloumns headers in sheet one
    xlswrite('Outputs.xls',sheetTitles,'Sheet1');
%     Print the final output to the sheet with the location calculated
    xlswrite('Outputs.xls',output,'Sheet1',location);
catch ME
    disp('Following error occured while writing to output file.');
    disp(ME.message);
end
disp(sheetTitles);
disp(output);