close all, clear all, clc

%load data from Scan1
load scan1.mat
r1=r;
theta1=theta;

%eliminate zeros
index1=find(r1~=0);
r1_clean=r1(index1);
theta1_clean=theta1(index1);
figure;
polarplot(deg2rad(theta1_clean),r1_clean,'ks','MarkerSize',6,'MarkerFaceColor','m')

[x1,y1]=pol2cart(deg2rad(theta1_clean),r1_clean);
figure;
plot(x1,y1,'ks')
title('Scan 1- Clean Data')
xlabel('[m]')
ylabel('[m]')


%We can use linear regression to find the best fit line
X1=[x1 ones(length(x1),1)];
beta1=(X1'*X1)\(X1'*y1);

y1_fit=x1*beta1(1)+beta1(2);

%fit using Matlab's polynomial fit
p1=polyfit(x1,y1,1);
y1_poly=polyval(p1,x1);

figure;
plot(x1,y1,'ks')
hold on
plot(x1,y1_fit,'r','linewidth',2)
plot(x1,y1_poly,'b--')
legend('Clean Data','Linear Regression','Polyval')
title('Scan 1- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')


%Use PCA to fit a line
x1_centered=x1-mean(x1);

%PCA function from Matlab 
PCA1=pca([x1,y1]);
slope1=PCA1(2,1)/PCA1(1,1);
y1_PCA=x1_centered.*slope1 + mean(y1);

figure;
plot(x1,y1,'ks')
hold on
plot(x1,y1_fit,'r','linewidth',2)
plot(x1,y1_PCA,'g--','linewidth',2)
legend('Clean Data','Linear Regression','PCA')
title('Scan 1- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')

%%
load scan2.mat
r2=r;
theta2=theta;

index2=find(r2~=0);
r2_clean=r2(index2);
theta2_clean=theta(index2);
figure;
polarplot(deg2rad(theta2_clean),r2_clean,'ks','MarkerSize',6,'MarkerFaceColor','m')

[x2,y2]=pol2cart(deg2rad(theta2_clean),r2_clean);
figure;
plot(x2,y2,'ks')
title('Scan 2- Clean Data')
xlabel('[m]')
ylabel('[m]')
axis equal

%We can use linear regression to find the best fit line
X2=[x2 ones(length(x2),1)];
beta2=(X2'*X2)\(X2'*y2);

y2_fit=x2*beta2(1)+beta2(2);

%fit using Matlab's polynomial fit
p2=polyfit(x2,y2,1);
y2_poly=polyval(p2,x2);

figure;
plot(x2,y2,'ks')
hold on
plot(x2,y2_fit,'r','linewidth',2)
% plot(x2,y2_poly,'b--')
legend('Clean Data','Linear Regression','Polyval')
legend('Clean Data','Linear Regression')
title('Scan 2- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')
axis equal

%Use PCA to fit a line
x2_centered=x2-mean(x2);

%PCA function from Matlab 
PCA2=pca([x2,y2]);
slope2=PCA2(2,1)/PCA2(1,1);
y2_PCA=x2_centered.*slope2 + mean(y2);

figure;
plot(x2,y2,'ks')
hold on
plot(x2,y2_fit,'r','linewidth',2)
plot(x2,y2_PCA,'g--','linewidth',2)
legend('Clean Data','Linear Regression','PCA')
title('Scan 2- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')
axis equal
%%
load scan3.mat
r3=r;
theta3=theta;

index3=find(r3~=0);
r3_clean=r3(index3);
theta3_clean=theta(index3);
figure;
polarplot(deg2rad(theta3_clean),r3_clean,'ks','MarkerSize',6,'MarkerFaceColor','m')

[x3,y3]=pol2cart(deg2rad(theta3_clean),r3_clean);
figure;
plot(x3,y3,'ks')
title('Scan 3- Clean Data')
xlabel('[m]')
ylabel('[m]')


%We can use linear regression to find the best fit line
X3=[x3 ones(length(x3),1)];
beta3=(X3'*X3)\(X3'*y3);

y3_fit=x3*beta3(1)+beta3(2);

%fit using Matlab's polynomial fit
p3=polyfit(x3,y3,1);
y3_poly=polyval(p3,x3);

figure;
plot(x3,y3,'ks')
hold on
plot(x3,y3_fit,'r','linewidth',2)
plot(x3,y3_poly,'b--')
legend('Clean Data','Linear Regression','Polyval')
title('Scan 3- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')


%Use PCA to fit a line
x3_centered=x3-mean(x3);

%PCA function from Matlab 
PCA3=pca([x3,y3]);
slope3=PCA3(2,1)/PCA3(1,1);
y3_PCA=x3_centered.*slope3 + mean(y3);

figure;
plot(x3,y3,'ks')
hold on
plot(x3,y3_fit,'r','linewidth',2)
plot(x3,y3_PCA,'g--','linewidth',2)
legend('Clean Data','Linear Regression','PCA')
title('Scan 3- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')

%%
load scan4.mat
r4=r;
theta4=theta;

index4=find(r4~=0);
r4_clean=r4(index4);
theta4_clean=theta(index4);
figure;
polarplot(deg2rad(theta4_clean),r4_clean,'ks','MarkerSize',6,'MarkerFaceColor','m')

[x4,y4]=pol2cart(deg2rad(theta4_clean),r4_clean);
figure;
plot(x4,y4,'ks')
title('Scan 4- Clean Data')
xlabel('[m]')
ylabel('[m]')


%We can use linear regression to find the best fit line
X4=[x4 ones(length(x4),1)];
beta4=(X4'*X4)\(X4'*y4);

y4_fit=x4*beta4(1)+beta4(2);

%fit using Matlab's polynomial fit
p4=polyfit(x4,y4,1);
y4_poly=polyval(p4,x4);

figure;
plot(x4,y4,'ks')
hold on
plot(x4,y4_fit,'r','linewidth',2)
plot(x4,y4_poly,'b--')
legend('Clean Data','Linear Regression','Polyval')
title('Scan 4- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')


%Use PCA to fit a line
x4_centered=x4-mean(x4);

%PCA function from Matlab 
PCA4=pca([x4,y4]);
slope4=PCA4(2,1)/PCA4(1,1);
y4_PCA=x4_centered.*slope4 + mean(y4);

figure;
plot(x4,y4,'ks')
hold on
plot(x4,y4_fit,'r','linewidth',2)
plot(x4,y4_PCA,'g--','linewidth',2)
legend('Clean Data','Linear Regression','PCA')
title('Scan 4- Clean Data and Fit Lines')
xlabel('[m]')
ylabel('[m]')
