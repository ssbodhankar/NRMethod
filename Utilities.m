classdef Utilities < handle
% Contains the frequently used methods in the PF calculations. The methods
% used are 
% isGeneratorBus(busData, currRow)
% thetaij(thetaMatrix, irow, jrow)
% deleteRows (theMatrix, rowsToDelete)
% addRows(theMatrix, rowsToAdd, valueToAdd)
% isConverged(theMatrix,errorTolerance)
% rad2deg(angleInRadians)
    methods (Static)
        function isGenbus = isGeneratorBus(busData, currRow)
            isGenbus = true;
            if (busData(currRow,BusDataConstants.KvRegColoumn) == 0)
                    isGenbus = false;
            end
        end
        function theta = thetaij(thetaMatrix, irow, jrow)
            theta = thetaMatrix(irow,2) - thetaMatrix(jrow,2);
            sprintf('Theta IthRow is %d \n',thetaMatrix(irow,1))
            sprintf('Theta JthRow is %d \n',thetaMatrix(jrow,1))
        end
        function newMatrix = deleteRows (theMatrix, rowsToDelete)
%             Contains the logic for deleting of the rows in a Matrix.
%             Returns a square matrix.
            newMatrix = theMatrix;
            dimensions = size (newMatrix);
            rowCount = rowsToDelete;
            for currRow = 1:rowCount
                newMatrix(1,:) = [];
                if(dimensions (1,2) >1)
                    newMatrix(:,1) = [];
                end
            end
        end
        function newMatrix = addRows(theMatrix, rowsToAdd, valueToAdd)
% Attributes 
%            theMatrix = The matrix to which the rows are to be added
%            rowsToAdd = Number of Rows to add
%            valueToAdd = The value that should be added to the Matrix
% This method adds rows to theMatrix. The rows added have the
% same value as that of the valueToAdd. Used in the NRMethod
% for adding new rows to the delta Matrices.
              newMatrix = theMatrix;
              rowCount = rowsToAdd;
              if(rowCount>0)
                  for currRow = 1: rowCount
                      newMatrix = [valueToAdd;newMatrix];
                  end
              end
        end
        
        function isConverged = isConverged(theMatrix,errorTolerance)
%             This method checks for the convergence of the given Matrix.
              isConverged = true;
              dimensions = size(theMatrix);
              for currRow = 1: dimensions(1,1)
                  for currCol = 1: dimensions(1,2)
                      if(abs(theMatrix(currRow, currCol)) > errorTolerance)
                          isConverged = false;
                      end
                  end
              end
        end
        
        function angleInDeg = rad2deg(angleInRadians)
%             Function for converting radians to degrees
            angleInDeg = (180/pi)*(angleInRadians);
        end
    end
end