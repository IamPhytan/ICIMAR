function [out,Done] = PlannerRRRRRRR_1(CurrentJointAngles,J,Obstacles,xyThetaDot)
%PLANIFICATEURRRRRRRR_1 Summary of this function goes here
%   Detailed explanation goes here

%Fonction Objective
out=CurrentJointAngles+pinv(J)*xyThetaDot;

%out=CurrentJointAngles;
end

