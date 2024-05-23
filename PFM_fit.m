% Fit harmonic

function [files, identifiers, modelf, coeff, error_R, xdata, ydata] = PFM_fit()
% Loads data and fits a model to freq vs voltage graph. Saves a list of
% file names, file identifiers, model coefficients, and R^2 errors of
% models.
%
    
    files=dir('**/*.ibw'); % Import ibw files
    listSize = size(files);

    for j = 1:listSize(1) % Number of data in a folder

        s=IBWread(files(j).name);

        % Create hierarchy cell array for classification
        cut = strsplit(files(j).name,{'_','.'});
        identifiers(j,:) = cut(1:4);

        % Get freq(kHz) and amplitude(V) data
        data=[s.y(:,1) s.y(:,2)];

        % Subtract polynomial background
        % bg_data=detrend(data(:,2));

        % Converting V to nm using deflection sensitivity for each sample
        if isequal(identifiers(j,1), {'A'})
            raw=[data(:,1)*0.001 data(:,2)*134.18]; % Make Units: Hz, nm
        elseif isequal(identifiers(j,1), {'B3'})
            raw=[data(:,1)*0.001 data(:,2)*130.18]; % Make Units: Hz, nm
        elseif isequal(identifiers(j,1), {'D1'}) || isequal(identifiers(j,1), {'D2'})
            raw=[data(:,1)*0.001 data(:,2)*138.08]; % Make Units: Hz, nm
        else
            error("Files can't be identified as belonging to set A or B")
        end
        

        % Fitting eq=F-F0=(----)(z'-z0)
        x=raw(:,1);  % freq (Hz)
        y=raw(:,2);  % Amp (converted to nm)

        xdata(:,j)=raw(:,1);  % freq (Hz)
        ydata(:,j)=raw(:,2);  % Amp (converted to nm)

        % P=[Amax, w0, Q, bkgd]
        modelf = @(P,x) P(1).*P(2).^2./P(3)./(sqrt((P(2).^2-x.^2).^2 ...
            + (P(2).*x./P(3)).^2)) + P(4);
        
        % [Amax, w0, Q, bkgd]
        P0 = [1 400 10 0];  % Chosen to fit at reasonable speed
        P = fitnlm(x,y,modelf,P0);
        
        % Storing results for output
        coeff(j,1:4) = P.Coefficients{:, 'Estimate'};
        error_R(:,j) = P.Rsquared;
    end
end

