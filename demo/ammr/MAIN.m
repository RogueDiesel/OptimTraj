p.fe = 1000; p.ts = 10; p.fc = 100; Nc = 10;

problem.func.dynamics =  @(t,x,u)( dynamics(x,u,p) );

problem.func.pathObj = @(t,x,u)( pathOjective(x) );

problem.func.pathCst = @(t,x,u)( pathConstraint(x,u) );

problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = 10;
problem.bounds.finalTime.upp = 10;

problem.bounds.state.low = [-0.52; -inf; 0];
problem.bounds.state.upp = [0.52; inf; 20];
problem.bounds.initialState.low = [0;0;0];
problem.bounds.initialState.upp = [0;0;20];
problem.bounds.finalState.low = [-0.52;-inf;0];
problem.bounds.finalState.upp = [0.52;inf;20];


problem.bounds.control.low = [0; 0]; 
problem.bounds.control.upp = [1; 1];

% t0 = linspace(0,10,Nc);
% problem.guess.time = linspace(0,10,Nc);
% x10 = 0.52*sin(t0);  x20 = 0.52*cos(t0); x30 = 10*ones(size(t0));
% problem.guess.state = [x10; x20; x30];
% up0 = rand(size(t0)); uq0 = rand(size(t0));
% problem.guess.control = [up0; uq0];
problem.guess = soln.grid;

% method = 'trapezoid';
% method = 'trapGrad';   
% method = 'hermiteSimpson';
% method = 'hermiteSimpsonGrad';   
% method = 'chebyshev'; 
% method = 'multiCheb';
method = 'rungeKutta';  
% method = 'rungeKuttaGrad';
% method = 'gpops';

% problem.options(1).nlpOpt = optimset(...
%     'Display','iter',...   % {'iter','final','off'}
%     'TolFun',1e-3,...
%     'MaxFunEvals',inf);   %options for fmincon
problem.options(1).nlpOpt = optimset('Algorithm','sqp','Diagnostics','on','Display','iter',...
'MaxFunEvals',inf,'MaxIter',inf,...
'PlotFcns',{'optimplotfval','optimplotconstrviolation','optimplotstepsize','optimplotfirstorderopt'},...
'TolFun',1e-6,'TolCon',1e-6,'TolX',1e-14,'GradObj','off','GradConstr','off','DerivativeCheck','off',...
'FinDiffType','central');
% problem.options(2).nlpOpt = optimset('Algorithm','sqp','Diagnostics','on','Display','iter',...
% 'MaxFunEvals',inf,'MaxIter',inf,...
% 'PlotFcns',{'optimplotfval','optimplotconstrviolation','optimplotstepsize','optimplotfirstorderopt'},...
% 'TolFun',1e-5,'TolCon',1e-5,'TolX',1e-12,'GradObj','off','GradConstr','off','DerivativeCheck','off',...
% 'FinDiffType','central');
% problem.options(3).nlpOpt = optimset('Algorithm','sqp','Diagnostics','on','Display','iter',...
% 'MaxFunEvals',inf,'MaxIter',inf,...
% 'PlotFcns',{'optimplotfval','optimplotconstrviolation','optimplotstepsize','optimplotfirstorderopt'},...
% 'TolFun',1e-7,'TolCon',1e-7,'TolX',1e-12,'GradObj','off','GradConstr','off','DerivativeCheck','off',...
% 'FinDiffType','central');
% problem.options(4).nlpOpt = optimset('Algorithm','sqp','Diagnostics','on','Display','iter',...
% 'MaxFunEvals',inf,'MaxIter',inf,...
% 'PlotFcns',{'optimplotfval','optimplotconstrviolation','optimplotstepsize','optimplotfirstorderopt'},...
% 'TolFun',1e-9,'TolCon',1e-9,'TolX',1e-12,'GradObj','off','GradConstr','off','DerivativeCheck','off',...
% 'FinDiffType','central');
% problem.options(5).nlpOpt = optimset('Algorithm','sqp','Diagnostics','on','Display','iter',...
% 'MaxFunEvals',inf,'MaxIter',inf,...
% 'PlotFcns',{'optimplotfval','optimplotconstrviolation','optimplotstepsize','optimplotfirstorderopt'},...
% 'TolFun',1e-111,'TolCon',1e-11,'TolX',1e-12,'GradObj','off','GradConstr','off','DerivativeCheck','off',...
% 'FinDiffType','central');
% problem.options(6).nlpOpt = optimset('Algorithm','sqp','Diagnostics','on','Display','iter',...
% 'MaxFunEvals',inf,'MaxIter',inf,...
% 'PlotFcns',{'optimplotfval','optimplotconstrviolation','optimplotstepsize','optimplotfirstorderopt'},...
% 'TolFun',1e-12,'TolCon',1e-12,'TolX',1e-12,'GradObj','off','GradConstr','off','DerivativeCheck','off',...
% 'FinDiffType','central');


switch method
    
    case 'trapezoid'
        problem.options(1).method = 'trapezoid'; % Select the transcription method
        problem.options(1).trapezoid.nGrid = 25;  %method-specific options
        
        problem.options(2).method = 'trapezoid'; % Select the transcription method
        problem.options(2).trapezoid.nGrid = 50;  %method-specific options
        
    case 'trapGrad'  %trapezoid with analytic gradients
        
        problem.options(1).method = 'trapezoid'; % Select the transcription method
        problem.options(1).trapezoid.nGrid = 10;  %method-specific options
        problem.options(1).nlpOpt.GradConstr = 'on';
        problem.options(1).nlpOpt.GradObj = 'on';
        problem.options(1).nlpOpt.DerivativeCheck = 'off';
        
        problem.options(2).method = 'trapezoid'; % Select the transcription method
        problem.options(2).trapezoid.nGrid = 45;  %method-specific options
        problem.options(2).nlpOpt.GradConstr = 'on';
        problem.options(2).nlpOpt.GradObj = 'on';
        
    case 'hermiteSimpson'
        
        % First iteration: get a more reasonable guess
        problem.options(1).method = 'hermiteSimpson'; % Select the transcription method
        problem.options(1).hermiteSimpson.nSegment = 25;  %method-specific options
        
        % Second iteration: refine guess to get precise soln
        problem.options(2).method = 'hermiteSimpson'; % Select the transcription method
        problem.options(2).hermiteSimpson.nSegment = 50;  %method-specific options
        
    case 'hermiteSimpsonGrad'  %hermite simpson with analytic gradients
        
        problem.options(1).method = 'hermiteSimpson'; % Select the transcription method
        problem.options(1).hermiteSimpson.nSegment = 6;  %method-specific options
        problem.options(1).nlpOpt.GradConstr = 'on';
        problem.options(1).nlpOpt.GradObj = 'on';
        problem.options(1).nlpOpt.DerivativeCheck = 'off';
        
        problem.options(2).method = 'hermiteSimpson'; % Select the transcription method
        problem.options(2).hermiteSimpson.nSegment = 15;  %method-specific options
        problem.options(2).nlpOpt.GradConstr = 'on';
        problem.options(2).nlpOpt.GradObj = 'on';
        
        
    case 'chebyshev'
        
        % First iteration: get a more reasonable guess
        problem.options(1).method = 'chebyshev'; % Select the transcription method
%         problem.options(2).method = 'chebyshev';problem.options(3).method = 'chebyshev';problem.options(4).method = 'chebyshev';
%         problem.options(5).method = 'chebyshev';problem.options(6).method = 'chebyshev';
        problem.options(1).chebyshev.nColPts = Nc;  %method-specific options
%         problem.options(2).chebyshev.nColPts = 8;
%         problem.options(3).chebyshev.nColPts = 16;
%         problem.options(4).chebyshev.nColPts = 32;
%         problem.options(5).chebyshev.nColPts = 64;
%         problem.options(6).chebyshev.nColPts = 128;
        
    case 'multiCheb'
        
        % First iteration: get a more reasonable guess
        problem.options(1).method = 'multiCheb'; % Select the transcription method
        problem.options(1).multiCheb.nColPts = 6;  %method-specific options
        problem.options(1).multiCheb.nSegment = 4;  %method-specific options
        
        % Second iteration: refine guess to get precise soln
        problem.options(2).method = 'multiCheb'; % Select the transcription method
        problem.options(2).multiCheb.nColPts = 9;  %method-specific options
        problem.options(2).multiCheb.nSegment = 4;  %method-specific options
        
    case 'rungeKutta'
        problem.options(1).method = 'rungeKutta'; % Select the transcription method
        problem.options(1).defaultAccuracy = 'medium';
%         problem.options(2).method = 'rungeKutta'; % Select the transcription method
%         problem.options(2).defaultAccuracy = 'medium';
    
    case 'rungeKuttaGrad'
      
        problem.options(1).method = 'rungeKutta'; % Select the transcription method
        problem.options(1).defaultAccuracy = 'low';
        problem.options(1).nlpOpt.GradConstr = 'on';
        problem.options(1).nlpOpt.GradObj = 'on';
        problem.options(1).nlpOpt.DerivativeCheck = 'off';
        
        problem.options(2).method = 'rungeKutta'; % Select the transcription method
        problem.options(2).defaultAccuracy = 'medium';
        problem.options(2).nlpOpt.GradConstr = 'on';
        problem.options(2).nlpOpt.GradObj = 'on';
        
    case 'gpops'
        problem.options = [];
        problem.options.method = 'gpops';
        problem.options.defaultAccuracy = 'high';
        problem.options.gpops.nlp.solver = 'snopt';  %Set to 'ipopt' if you have GPOPS but not SNOPT
        
    otherwise
        error('Invalid method!');
end

soln = optimTraj(problem);
t = soln(end).grid.time;
x2 = soln(end).grid.state(2,:);
x3 = soln(end).grid.state(3,:);
up = soln(end).grid.control(1,:);
uq = soln(end).grid.control(2,:);


% % Plot the solution:
% figure(1); clf;
% 
% subplot(3,1,1)
% plot(t,q)
% ylabel('q')
% title('Single Pendulum Swing-Up');
% 
% subplot(3,1,2)
% plot(t,dq)
% ylabel('dq')
% 
% subplot(3,1,3)
% plot(t,u)
% ylabel('u')
