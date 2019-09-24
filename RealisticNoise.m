clear
close all
clc
fh = figure('Menu','none','ToolBar','none'); 
fuLevel = 2;

noiseResistance = 1;

n = 199;
% empirically determined to be a very good value:
fps = 13.749999999999948;

signalFreq = 110;

% Ticks per second in generated data
tickFreq = (signalFreq*n)/2;

% Ticks per second in sampled data
% This will determine (among other things) the pitch of the noise
Fs = 10945;


ticksPerSampleTick = round(tickFreq/Fs);

echoFactor = 4;
periodsNeededForSound = round(tickFreq/(fps*n))*echoFactor;

x = linspace(0,4*pi*periodsNeededForSound,n*periodsNeededForSound);
xPlot = x(1:n);
level = 0;
noise = normrnd(0,level,1,n*periodsNeededForSound);
noisePlot = noise(1:n);
signal= sin(x)/2;
signalPlot = signal(1:n);
a = plot(xPlot,signalPlot+noisePlot,'LineWidth',2,'color',[0 1 0]);

ah = axes('Units','Normalize','Position',[0 0 1 1]);
axis([0 4*pi -1.2 1.2])
set(gca,'Color','k')
hold on
t = 0;
start = tic;
start2 = tic;

while true
    fuckedUpLevel = [1 cos(t*.1)*4 sin(cos(t*.1)*4)*4 (sin(cos(t*.1)*4)*4)^2];
    v = fuckedUpLevel(fuLevel);
    signal= sin(x*v)/2;
    signalPlot = signal(1:n);
%     noiseResistance = 1/((abs(sin(t/40))+.001)*1);
    t = t + 1;
    delete(a)
    walksteps = .02;
    pDown = (1./(1+exp(-level*noiseResistance)));
    level = level+(round(.5+.5*(rand-pDown))*2-1)*walksteps;
    noise = normrnd(0,abs(level),1,n*periodsNeededForSound);
    noisePlot = noise(1:n);
    
    r = abs((1./(1+exp(-level*22)))-.5)*2;
    g = 1-r;
%     b = (1./(1+exp(-(1-1/noiseResistance-0.5)*22)));
    b=0;
    a = plot(xPlot,signalPlot+noisePlot,'LineWidth',r*8+2,'color',[r g b]);
    soundData = signal+noise;
    sampledSoundData = soundData(1:ticksPerSampleTick:end);
    sound(sampledSoundData,Fs)
    stop2 = toc(start2); %this times an actual pass
    start2 = tic;
    stop = toc(start);   %this is to adjust the wait time
    pause(max(1/fps-stop,0))
    start =tic;
end