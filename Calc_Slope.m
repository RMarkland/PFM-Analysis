% Calculate averages and St. Dev
function SpotStruct = Calc_Slope(files, identifiers, coeff)
% Data is stored in struct with avg vals in first col and st.deviation in second
% 
%

    i = 1;
    j = 1;
    SpotStruct = struct(); 
    listSize = size(files);
    
    % Basically just sorting everything & calculating averages/variances.
        % Variances as they maintain their multiplicative property in case 
        % of later operations.
    while j < listSize(1)

        temp = struct(); voltage = []; amp_adj = []; omega = [];
        Q = []; background = []; 
        k = 1;
        while j < listSize(1) && isequal(identifiers(i,2), identifiers(j,2))

            tempvolt = identifiers(j,3);
            voltage(k,1) = str2double(tempvolt{1})/10;
            amp_adj(k,:) = [mean(coeff(j:j+2,1)./coeff(j:j+2,3)),...
                var(coeff(j:j+2,1)./coeff(j:j+2,3))];
            omega(k,:) = [mean(coeff(j:j+2,2)),var(coeff(j:j+2,2))];
            background(k,:) = [mean(coeff(j:j+2,4)),var(coeff(j:j+2,4))];
            k = k+1;
            j = j+3;
        end
        
        % Coeffs of linear fit [slope, y_intercept] for d33 then error 
        [valFit, S] = polyfit(voltage,amp_adj(:,1), 1);
        %err = polyparci(valfit, S);

        % Calc St. Deviation from errFit
        %stDeviation = errFit(1)^0.5;


        % Saving into big struct for output
        temp.voltage = voltage; temp.amp_adj = amp_adj; temp.omega = omega;
        temp.background = background; temp.finalVals = [valFit, S.normr];

        name = identifiers(i,2);
        SpotStruct.(name{1}) = temp;
        i=j;
    end

    % Bad sorting alg to sort SpotStruct to increasing numerical spot no.
    SpotNo = fieldnames(SpotStruct);
    nums = str2num(char(erase(SpotNo,'s')));
    i = 2;
    while i <= length(SpotNo)

        SpotNo = fieldnames(SpotStruct);
        nums = str2num(char(erase(SpotNo,'s')));
        if nums(i-1) > nums(i)

            temp2 = SpotStruct.(char(SpotNo(i-1)));
            SpotStruct = rmfield(SpotStruct, char(SpotNo(i-1)));
            SpotStruct.(char(SpotNo(i-1))) = temp2;
            i = 2;
        else

            i = i+1;
        end
    end
    
end

