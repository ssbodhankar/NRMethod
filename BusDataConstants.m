classdef BusDataConstants
    properties (Constant = true)
        numberOfSlackBuses = 1;
%         Constants for the bus data matrix coloumns
        busColoumn = 1; %The first coloumn of the Bus Data Matrix indicating the Bus Number.
        PgColoumn = 2; %The second coloumn of the Bus Data Matrix indicating the Real Power generated at a bus.
        QgColoumn = 3; %The third coloumn of the Bus Data Matrix indicating the Reactive Power generated at a bus.
        PlColoumn = 4; %The fourth coloumn of the Bus Data Matrix indicating the Real Power of the load at a bus.
        QlColoumn = 5; %The fifth coloumn of the Bus Data Matrix indicating the Reactive Power of the load at a bus.
        KvNomColoumn = 6; %The sixth coloumn of the Bus Data Matrix indicating the Nominal Voltage of the bus.
        KvRegColoumn = 7; %The seventh coloumn of the Bus Data Matrix indicating the Regulated Voltage of the bus.
%         Constants for the branch data matrix
        fromBusColoumn = 1; %The first coloumn of the brnch data matrix indicating the from bus.
        toBusColoumn = 2; %The second coloumn of the brnch data matrix indicating the to bus.
        rpu = 3; %The three coloumn of the brnch data matrix indicating the resistance between the from and two bus.
        xpu = 4; %The fourth coloumn of the brnch data matrix indicating the reactance between the from and two bus.
        bpu = 5; %The fifth coloumn of the brnch data matrix indicating the shunt admittance.
        tapRatioColoumn = 6; %The sixth coloumn of the brnch data matrix indicating the tap ratio.
    end
end