%% Load MSIT Data
% data: Ii, Ini, Iin, Yk_1 , Yk
load('mg106_state2.mat');
%id=find(TrialDet(:,12)>0);
tr=1:size(TrialDet,1);
RT=TrialDet(tr,12);
N = length(RT);
% Yn - log of reaction time
Yn = log(RT);
% Yb - correct/incorrect not used here
Yb = ones(N,1);
% Input, 1 xi
In = zeros(N,2);
In(:,1)=1;
In(find(TrialDet(tr,10)==2),2)=1;
% Input, Ib equal to In
Ib = In;
% Uk, which is zero
Uk = zeros(N,1);
% Valid, which is valid for observed point
Valid = zeros(N,1);
Valid(find(isfinite(RT)))=1;


%% Set Behavioral Model and Learning Procedure
Param = ay_create_state_space(2,1,2,2,eye(2,2),[1 2],[0 0],[1 2],[0 0]);
% set learning parameters
Iter  = 200;
Param = ay_set_learning_param(Param,Iter,0,1,1,0,1,0,1,2,1);
Param = ay_set_censor_threshold_proc_mode(Param,log(2),1,1);

%% Format the Data
[XSmt,SSmt,Param,XPos,SPos,ML,YP,~]=ay_em([1 0],Uk,In,Ib,Yn,Yb,Param,Valid);



%% Extra Script
figure(1)
plot(Yn,'LineWidth',2);hold on;
plot(YP,'LineWidth',2);
plot(find(In(:,2)==1),Yn(find(In(:,2)==1)),'o'); 
hold off;
axis tight
legend('RT','Yp','Interfernece Trial')
xlabel('Trial');
ylabel('RT(sec)');

figure(2)
K  = length(Yn);
xm = zeros(K,1);
xb = zeros(K,1);
for i=1:K
    temp=XSmt{i};xm(i)=temp(1);
    temp=SSmt{i};xb(i)=temp(1,1);
end
ay_plot_bound(1,(1:K),xm,(xm-2*sqrt(xb))',(xm+2*sqrt(xb))');
ylabel('x_k(1)');
xlabel('Trial');
axis tight
grid minor

figure(12)
K  = length(Yn);
xm = zeros(K,1);
xb = zeros(K,1);
for i=1:K
    temp=XPos{i};xm(i)=temp(1);
    temp=SPos{i};xb(i)=temp(1,1);
end
ay_plot_bound(1,(1:K),xm,(xm-2*sqrt(xb))',(xm+2*sqrt(xb))');
ylabel('x_k(1)');
xlabel('Trial');
axis tight
grid minor


figure(3)
K  = length(Yn);
xm = zeros(K,1);
xb = zeros(K,1);
for i=1:K
    temp=XSmt{i};xm(i)=temp(2);
    temp=SSmt{i};xb(i)=temp(2,2);
end
ay_plot_bound(1,(1:K),xm,(xm-2*sqrt(xb))',(xm+2*sqrt(xb))');
ylabel('x_k(2)');
xlabel('Trial');
axis tight
grid minor


figure(4)
ml=[];
for i=1:Iter
    ml(i)=ML{i}.Total;
end
plot(ml,'LineWidth',2);
ylabel('ML')
xlabel('Iter');

