################################################################################
###             %TEZPUR UNIVERSITY MODEL TO GENERATE RTN                     ###
###     %Developed by Deepjyoti Deb, Rupam Goswami, Ratul Kr. Baruah         ###
################################################################################

%%%   START PROGRAM   %%%

% Prompt the user to enter the following values:
%Ef = Fermi energy level (eV)
%Et = Single trap level (eV)
%SID(max) = Maximum drain current NSD (A^2/Hz)
%x = frequency (Hz)

Ef = input('Enter the value of Ef:');
Et = input('Enter the value of Et:');
SIDmax = input('Enter the value of SIDmax:');

% Values of Log10(SID/SID_max)--> Yaxis vs Frequency---> Xaxis
y = [0, -0.012339473, -0.050316861, -0.961754026,-2.416836035, -8.16317984, -11.10923329,-18.73852323, -22.71845136, -34.85478102, -40.77068585, -54.71516925, -60.73466196, -74.71371756, -80.73429812, -94.7136982, -100.7342904, -114.7136789,-120.7342439];
x = [1.00E+01, 5.00E+01, 1.00E+02, 5.00E+02, 1.00E+03, 5.00E+03, 1.00E+04, 5.00E+04, 1.00E+05, 5.00E+05, 1.00E+06, 5.00E+06, 1.00E+07, 5.00E+07, 1.00E+08, 5.00E+08, 1.00E+09, 5.00E+09, 1.00E+10];


% Interpolate x-values for a given y-value (finding roll-off frequency, fc)
interp_func = @(y_new) interp1(y, x, y_new, 'linear');

% Find the x-value for a given y-value
y_new = -3;
x_new = interp_func(y_new);


% Display the value of roll-off frequency measured at 3dB w.r.t. SID(max)
fprintf('The x-value for y=%f is approximately %f.\n', y_new, x_new);
fc = x_new;
tau=1/(2*pi*fc);

% Display the value of average time constant
fprintf('The value of tau=%e.\n',tau);

kT=0.026;
pff=exp((Ef-Et)/kT);
pff1=exp(-(Ef-Et)/kT);
tauc=tau*(1+pff1);
taue=tau*(1+pff);


% Display the value of average emission time constant
fprintf('The value of taue=%e.\n',taue);

% Display the value of average capture time constant
fprintf('The value of tauc=%e.\n',tauc);

% SIDmax is the linear value (A^2/Hz)
SID = 10.^(-3)*SIDmax;

% Calculate RTN amplitude (May be normalized to 1: it does not impact the randomness)
del_ID = (((SID*(taue+tauc)*((((1/taue)+(1/tauc)).^2)+((2*pi*fc).^2))).^0.5)/2);
fprintf('The value of DelID=%e.\n',del_ID);

% Initiate the initial values instantaneous capture and emission time constant
tu(1)=0;
td(1)=0;
T=8; %May result in 'out of bounds' error if not set within limits. It depends on Ef-Et difference. Can be set through trial and error.
for i=1:T-1
  i=i+1;
  % Find instantaneous capture/emission  time constant by using cumulatively distribution function of inter-arrival  times of poissson process
  % tup can be taue or tauc
  tu(i)=-(taue*log(1-rand));
end
for j=1:T-1
  j=j+1;
   % Find instantaneous emission /capture  time constant by using cumulatively distribution function of inter-arrival  times of poissson process
   % tup can be tauc or taue
  td(j)=-(tauc*log(1-rand));
end
for k=0:T-1
  m=2*k+1;
  k=k+1;
  n=2*k;
  tmix(m)=tu(k);
  tmix(n)=td(k);

  % delid(m)value is the amplitude of RTN i.e del(ID)value
  delid(m)=del_ID;
  delid(n)=0.1;
end
tfinal(1)=tmix(1);
for p=1:(2*T)-1
  p=p+1;
  % Clubing all the instantaneous values of capture and emission time one
  % after another to generate the curve
  tfinal(p)=tmix(p)+tfinal(p-1);
end
% Plot the RTN graph using step curve {plot(tfinal,delid)}
figure, stairs(tfinal,delid)

################################################################################
###             %TEZPUR UNIVERSITY MODEL TO GENERATE RTN                     ###
###     %Developed by Deepjyoti Deb, Rupam Goswami, Ratul Kr. Baruah         ###
################################################################################
