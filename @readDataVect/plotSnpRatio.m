function plotSnpRatio(obj, KERNEL, varargin)
% the third argument is
if nargin>3 && isprop(obj, varargin{2})
    selStr = {'select', obj.(varargin{2}) };
else
    selStr = {};
end

if nargin>2 && isscalar(varargin{1})
    chr0 = varargin{1};
    fieldPlotFun = @(x)obj.plotOneChromosome(chr0, x{:}, 'yscale', 'lin', selStr{:});
else
    fieldPlotFun = @(x)obj.plotChromosomes(x{:}, 'yscale', 'lin', selStr{:});
end

% colorPaleRed = [1, 0.4, 0.4];
colorPaleRed = [1, 0, 0];
MarkerSize = 8;
% addpath(fullfile(USERFNCT_PATH, 'fastmedfilt1d'));
hfMtemp = fieldPlotFun({'f', 'figure', 'new', 'plotfun', @(x,y)plot(x,y, 'r.' , 'MarkerSize', MarkerSize, 'color', colorPaleRed )});
%             hf = obj.plotChromosomes('f', 'yscale', 'lin', 'figure', 'new',  'plotfun', @(x,y)plot(x,y, 'r.' , 'color', [1, 0.4, 0.4]));
hfM = hfMtemp(1);
obj.f0 = 0.25;
fieldPlotFun({'f0',  'figure', 'old', 'plotfun', @(x,y)plot(x,y, '-', 'color', [.3, 0.85, 0.85])});
%             obj.plotChromosomes('f0', 'yscale', 'lin', 'figure', 'old', 'plotfun', @(x,y)plot(x,y, '-', 'color', [.3, 0.85, 0.85]));
obj.f0 = 0.5;
fieldPlotFun({'f0',  'figure', 'old', 'plotfun', @(x,y)plot(x,y, '-', 'color', [0.6, 0.6, 1])});
%             obj.plotChromosomes('f0', 'yscale', 'lin', 'figure', 'old', 'plotfun', @(x,y)plot(x,y, '-', 'color', [0.6, 0.6, 1]));

if KERNEL>0
    obj.filterF( KERNEL)
end

if obj.flagWT
    hfw = fieldPlotFun({'fw', 'figure', 'old', 'plotfun', @(x,y)plot(x,y, 'g.', 'MarkerSize', MarkerSize, 'color', [ 0.4, 1, 0.4])} );
    %                 obj.plotChromosomes('fw', 'yscale', 'lin', 'figure', 'old', 'plotfun', @(x,y)plot(x,y, 'gx', 'color', [ 0.4, 1, 0.4]));
    legendTextWt = { 'SNP ratio (wt)'};
    if KERNEL>0
        legendTextWt = { legendTextWt{:}, sprintf('median filter (wt), k=%u', KERNEL),  sprintf('mean filter (wt), k=%u', KERNEL) };
    end

    if KERNEL>0
        zeroFwInds = find( (diff(obj.fwMedianF) == 0) & (obj.fwMedianF(1:end-1) == 0 ) );
        
        zerosStrtEnd = zeros( sum(diff(zeroFwInds)~= 1) +1, 2);
        zerosStrtEnd(1, 1) = zeroFwInds(1);
        
        jj = 1;
        for ii = 1:numel(zeroFwInds)-1
            if zeroFwInds(ii)+1 ~= zeroFwInds(ii+1)
                zerosStrtEnd(jj, 2) = zeroFwInds(ii); % end
                zerosStrtEnd(jj+1, 1) = zeroFwInds(ii+1); % start
                jj = jj+1;
            end
        end
        zerosStrtEnd(end, 2) = zeroFwInds(end);
        clusterLength = diff(zerosStrtEnd, 1, 2)+1;
        
        iBigClusters = zerosStrtEnd(clusterLength>KERNEL, :);
        fprintf('boundaries of the zero-SNP-ratio  regions in WT pools:\n')
        for ii = 1:size(iBigClusters,1)
            fprintf('number of SNPs within the region:\t%u\t chr:\t%u\t x:\t%u\t--\t%u\n',diff(iBigClusters(ii,:)), obj.chromosome(iBigClusters(ii,1)),  obj.x(iBigClusters(ii,1)), obj.x(iBigClusters(ii,2))  )
        end
        
        hfwMd = fieldPlotFun({'fwMedianF',  'figure', 'old',...
            'plotfun', @(x,y)plot(x,y, '-', 'color', [ 0, .6, 0], 'linewidth', 3)});
        %                 obj.plotChromosomes('fwMedianF', 'yscale', 'lin', 'figure', 'old', 'yThr', 0,...
        %                     'plotfun', @(x,y)plot(x,y, '-', 'color', [ 0, .6, 0], 'linewidth', 3));
        
        hfwMn = fieldPlotFun({'fwMeanF', 'figure', 'old',...
            'plotfun', @(x,y)plot(x,y, '-', 'color', [ 0, .8, 0], 'linewidth', 1.5)} );
        %                 obj.plotChromosomes('fwMeanF', 'yscale', 'lin', 'figure', 'old', 'yThr', 0,...
        %                     'plotfun', @(x,y)plot(x,y, '-', 'color', [ 0, .8, 0], 'linewidth', 1.5));
    end
end

if KERNEL>0
    hfMtemp = fieldPlotFun({'fmMedianF',  'figure', 'old', ...
        'plotfun', @(x,y)plot(x,y, '-', 'color', [.6, 0, 0], 'linewidth', 3) });
    %             hfMedian = obj.plotChromosomes('fmMedianF', 'yscale', 'lin', 'figure', 'old', 'yThr', 0,...
    %                 'plotfun', @(x,y)plot(x,y, '-', 'color', [.6, 0, 0], 'linewidth', 3));
    hfM(2) = hfMtemp(1);
    
    hfMtemp = fieldPlotFun({'fmMeanF', 'figure', 'old', ...
        'plotfun', @(x,y)plot(x,y, '-', 'color', [1, 0, 0], 'linewidth', 1.5)} );
    %             hfMean = obj.plotChromosomes('fmMeanF', 'yscale', 'lin', 'figure', 'old', 'yThr', 0,...
    %                 'plotfun', @(x,y)plot(x,y, '-', 'color', [1, 0, 0], 'linewidth', 1.5));
    hfM(3) = hfMtemp(1);
end
set(obj.prevAxes(:,end), 'box','on')
legendText = { 'SNP ratio'};
if KERNEL>0
    legendText = [ legendText, {sprintf('median filter, k=%u', KERNEL),  sprintf('mean filter, k=%u', KERNEL) }];
end

if obj.flagWT
    legendText =  [legendText, legendTextWt];
    ll = legend([hfM, hfw(1), hfwMd(1), hfwMn(1),], legendText );
else
    ll = legend(hfM, legendText );
end


if ~( nargin>2 && isscalar(varargin{1}) )
    set(ll, 'Position', [0.68    0.6280    0.25    0.1243] );
end
end