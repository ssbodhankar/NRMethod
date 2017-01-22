function Ybus = createYBus(branchMatrix, numOfBuses)
Ybus = zeros(numOfBuses);
givenMatrix = branchMatrix;
dimensions = size(branchMatrix);
numOfRows = dimensions(1,1);

% Logic for finding the YBus formation.
% The logic is we will traverse the entire branch Matrix and we will keep
% on updating the YBus row and coloumn based on the from and to.
% We start assuming that there are only one 
for currRowCount = 1: numOfRows
    ithBus = givenMatrix (currRowCount,BusDataConstants.fromBusColoumn); % the 1 is from the data mapping given in the Input.m file
    jthBus = givenMatrix (currRowCount,BusDataConstants.toBusColoumn); % the 2 is from the data mapping given in the Input.m file
    tapRatio = givenMatrix (currRowCount,BusDataConstants.tapRatioColoumn);
%     If the tap ratio is 0, then find the admittances as normal. Else use
%     the tap ratio to find the admittances
    if( tapRatio == 0)
        z = givenMatrix (currRowCount,BusDataConstants.rpu) +i*givenMatrix (currRowCount,BusDataConstants.xpu);
        yii = i*givenMatrix (currRowCount,BusDataConstants.bpu)/2;
        yjj = i*givenMatrix (currRowCount,BusDataConstants.bpu)/2;
    %   Calculate the Off Diagonal Elements
        Ybus(ithBus,jthBus) = Ybus(ithBus,jthBus)+ -(1/z);
        Ybus(jthBus,ithBus)=Ybus(ithBus,jthBus);
    %   Calculate the Diagonal Elements
        Ybus(ithBus,ithBus) = Ybus(ithBus,ithBus)+1/z + yii; %Y11 = Y10+Y12+Y13+Y14
        Ybus(jthBus,jthBus) = Ybus(jthBus,jthBus)+1/z + yjj; %Y11 = Y10+Y12+Y13+Y14

    else
        z = i*givenMatrix (currRowCount,BusDataConstants.xpu);
    %   Calculate the Off Diagonal Elements
        Ybus(ithBus,jthBus) = Ybus(ithBus,jthBus)+ -1*tapRatio*(1/z);
        Ybus(jthBus,ithBus)=Ybus(ithBus,jthBus);

        yii = tapRatio*(tapRatio-1)/z;
        yjj = (1-tapRatio)/z;
    %   Calculate the Diagonal Elements
        Ybus(ithBus,ithBus) = Ybus(ithBus,ithBus)+tapRatio*1/z + yii; %Y11 = Y10+Y12+Y13+Y14
        Ybus(jthBus,jthBus) = Ybus(jthBus,jthBus)+tapRatio*1/z + yjj; %Y11 = Y10+Y12+Y13+Y14
    end
end
% xlswrite('../Output/YBusNew',Ybus);