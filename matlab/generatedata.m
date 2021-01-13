%
% This generates data as described in the Dube, Fox, Su (2009) paper
% from the section "Fake data example"
% 
% This dataset structure can be used in a number of different estimation
% routines
%
% blpsimple - a fixed point / GMM estimator similar to the original Berry,
% Levinsohn, Pakes (1995) paper and the Nevo (2000) paper.
%
% blpmpec - an MPEC formulation of the constrained BLP-GMM estimator as
% defined in Dube, Fox, and Su (2009)
%
% elblp - an MPEC formulation of the constrained BLP-EL estimator as
% defined in Conlon (2009)
%
% Note: you need to modify ds.Z to match the appropriate interactions of
% the instrumental variables.
% 
% Also note: in low dimensions of integration (K<=5) I suggest using the
% sparse grid quadrature points of Heiss and Winschell (2007).  Available
% on http://sparse-grids.de/ (just set the w and the nu).


% from Chris Conlon's BLP teaching code

function [ds]=generatedata(ns)

rng(312606);

J=25; T=50; k=3; D=6; K=k+2; sigma=1;

V=[1 -0.8  0.3; -0.8  1 0.3; 0.3 0.3 1];

mubeta=[-1 1.5 1.5 0.5 -3.0];
vbeta=[0.5 0.5 0.5 0.5 0.0]; % remove random coef on price 

X=mvnrnd(zeros(J*T,k),V);
ds.xi=randn(J*T,1)*sigma;
u1=5*rand(J*T,1);
u2=rand(J*T,D);
ds.p = 3 + ds.xi *1.5 + u1 + sum(X,2);   
z = u2 + repmat(0.25 * abs(u1+ 1.1* sum(X,2)),[1 D]);
ds.x = [ones(J*T,1) X ds.p ];
ds.nu = randn(ns,K);
%ds.subs = [repmat(reshape(repmat(1:T,[J 1]),T*J,1),[ns 1]) reshape(repmat(1:T*J,1,ns),T*J*ns,1)];
ds.mktid = reshape(repmat([1:T],[J 1]),[T*J 1]);
ds.prodid = reshape(repmat([1:J],[1 T]),[T*J 1]);
ds.subs = [repmat(ds.mktid,[ns 1]) reshape(repmat(1:ns,[J*T 1]),J*T*ns,1)  repmat(ds.prodid,[ns 1])];
ds.w = repmat(1/ns,[ns 1]);
ds.Z = [ones(J*T,1) X z];

tic
utils = exp(repmat(ds.x*mubeta'+ds.xi,[1 ns]) + ds.x*(ds.nu .* repmat(vbeta,[ns 1]))');
t2=toc;

denom =zeros(T,ns);
pijt =zeros(T*J,ns);
for i=1:T,
    u=utils(i*J-J+1:i*J,:);
    denom(i,:)=1+sum(u);
    pijt(i*J-J+1:i*J,:)=u./repmat(denom(i,:),[J 1]);
end
ds.sjt = mean(pijt,2);
end