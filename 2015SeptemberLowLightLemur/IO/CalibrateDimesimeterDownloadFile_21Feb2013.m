function [time,Lux,CLA,Activity] = CalibrateDimesimeterDownloadFile_21Feb2013(fileName,varargin)
% Calibrates the data downloaded from the Boston Atlantic client software.
% Input arguements:
% fileName: the file name of the downloaded Daysimeter file from the 
%   Boston Atlantic client program.
% varargin: If provided, this will save the calibrated data to the filename
%   specified in varargin(1).
% Output:
%   time: column vector of Matlab serial date numbers (days since Jan-1-0000)
%   Rlux, Glux, Blux: column vectors of the RGB sensor readings in units 
%       equivalent to lux for CIE Illuminant A.
%   Lux: column vector of photopic lux readings
%   CLA: Circadian light using the post-Berlin Model with melanopsin peaking
%       at 484 nm (October 2012)
%   Activity: column vector of activity index values (rms delta g-force)

%get start time and logging interval from data file

f = fopen(fileName);
fscanf(f, '%s', 1);
ID = fscanf(f, '%d', 1);
year = fscanf(f, '%d', 1);
month = fscanf(f, '%d', 1);
day = fscanf(f, '%d', 1);
hour = fscanf(f, '%d', 1);
minute = fscanf(f, '%d', 1);
% int = fscanf(f, '%d', 1); % logging interval in seconds
int = 10*60; % 10 minute logging interval
display(['Interval: ',num2str(int)]);
start = [num2str(month), '/', num2str(day), '/20', num2str(year), ' ', num2str(hour), ':', num2str(minute)];
frewind(f);

if (ID == 0) % ID is over 255 so ID = 256*byte(15) + byte(16)
    Bytes = fscanf(f,'%d',16);
    ID = 256*Bytes(15) + Bytes(16);
    display(['ID: ',num2str(ID)]);
end
fclose(f);

%get data
raw = textread(fileName, '%d');

% Convert byte data to integer values of r,g,b, and activity
for i = 24:8:length(raw) % first 24 bytes are header information
    if (raw(i-7:i)==255) % end of log marked by all values = 255
        break;
    end
    time(i/8 - 2) = datenum(start) + (int/86400)*(i/8 - 3);
    red(i/8 - 2) = 256*raw(i - 7) + raw(i - 6);
    green(i/8 - 2) = 256*raw(i - 5) + raw(i - 4);
    blue(i/8 - 2) = 256*raw(i - 3) + raw(i - 2);
    Activity(i/8 - 2) = 256*raw(i - 1) + raw(i);
    
    if(mod(Activity(i/8 - 2), 2) > 0) % LSB of Activity is range indicator: 0 = normal, 1 = low range
        red(i/8 - 2) = red(i/8 - 2)/140; % low range uses interation period 140 times normal range
        green(i/8 - 2) = green(i/8 - 2)/140;
        blue(i/8 - 2) = blue(i/8 - 2)/140;
    end
    Activity(i/8 - 2) = Activity(i/8 - 2)/2; % remove LSB from Activity
end
time = time(1:end-1);
red = red(1:end-1);
green = green(1:end-1);
blue = blue(1:end-1);
Activity = Activity(1:end-1);

%remove resets
resets = 0;
j = 1;
total = length(red);
for i = 1:length(red)
    if(i >= (total))
        break;
    end
    if((red(i) > 10000) && (green(i) == 0) && (blue(i) > 10000))
        
        %every other reset, remove the point so that the time is more
        %accurate
        
        %replace reset with previous value on even # of resets
        if(mod(resets,2) ~= 1)
            if (i > 3)
                red(i) = red(i - 3);
                green(i) = green(i - 3);
                blue(i) = blue(i - 3);
                Activity(i) = Activity(i - 3);
            else
                red(i) = 0;
                green(i) = 0;
                blue(i) = 0;
                Activity(i) = 0;
            end
            
        %delete reading on odd # of resets
        else
            time(i) = [];
            for count = i:length(time)
                time(count) = time(count) - (time(3) - time(2));
            end
            red(i) = [];
            green(i) = [];
            blue(i) = [];
            Activity(i) = [];
            i = i - 1;
            total = total - 1;
        end
       
        resets = resets + 1;        %keep track of number of resets
        reset(j) = i;               %keep track of location of resets
        j = j + 1;
    end
end

% I have no idea why Robert had these next 4 lines. Andrew Bierman 27-Nov-2012
% red(find((red < max(red)) & (red > 10000))) = red(find((red < max(red)) & (red > 10000)) - 1);
% green(find((red < max(red)) & (red > 10000))) = green(find((red < max(red)) & (red > 10000)) - 1);
% blue(find((red < max(red)) & (red > 10000))) = blue(find((red < max(red)) & (red > 10000)) - 1);
% Activity(find((red < max(red)) & (red > 10000))) = Activity(find((red < max(red)) & (red > 10000)) - 1);

%display number of resets, and when they occured
display(['Number of resets: ',num2str(resets)]);
if(resets > 0)
    display('Reset times:');
    display(datestr(time(reset)));
end

%convert Activity to rms g
%raw Activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
%from four right shifts in the source code
Activity = (sqrt(Activity))*.0039*4;

% Read RGB cal file and pick values having matching ID
g = fopen('RGB Calibration Values.txt');

for i = 1:ID % Read lines up to ID line and discard
    fgetl(g);
end
fscanf(g, '%d', 1); % Read RGB cal constants
cal = zeros(3,1);
for i = 1:3 
    cal(i) = fscanf(g, '%f', 1);
end
%calibrate to illuminant A
Rlux = red*cal(1);
Glux = green*cal(2);
Blux = blue*cal(3);

% Read file containing spectral calibration coefficients
f = fopen('spectralCalCoefficients_27Nov2012.txt');
fgetl(f); % read first line (header) and discard
%Scone
fscanf(f, '%s', 1);
for i = 1:3
    Sm(i) = fscanf(f, '%f', 1);
end
%Vlamda (macula)
fscanf(f, '%s', 1);
for i = 1:3
    Vm(i) = fscanf(f, '%f', 1);
end
%Melanopsin
fscanf(f, '%s', 1);
for i = 1:3
    M(i) = fscanf(f, '%f', 1);
end
%Vprime
fscanf(f, '%s', 1);
for i = 1:3
    Vp(i) = fscanf(f, '%f', 1);
end
%Vlamda
fscanf(f, '%s', 1);
for i = 1:3
    V(i) = fscanf(f, '%f', 1);
end
fgetl(f) ; % Read to end of line and discard
fgetl(f); % Read empty line
fgetl(f); % Read header line and discard
fscanf(f, '%s', 1); % Read line of coefficients
%CLA
for i = 1:4
    C(i) = fscanf(f, '%f', 1);
end
fclose(f);

% Lux and CLA calculations
Lux = V(1)*Rlux + V(2)*Glux + V(3)*Blux;

for i = 1:length(Rlux)
    RGB = [Rlux(i) Glux(i) Blux(i)];
    Scone(i) = sum(Sm.*RGB);
    Vmaclamda(i) = sum(Vm.*RGB);
    Melanopsin(i) = sum(M.*RGB);
    Vprime(i) = sum(Vp.*RGB);
    
%     C(4)*Melanopsin
%     C(4)*C(1)*(Scone(i) - C(3)*Vmaclamda(i))
%     C(4)*C(2)*683*(1 - exp(-(Vprime(i)/(683*6.5))))
    
    if(Scone(i) > C(3)*Vmaclamda(i))
        CLA(i) = Melanopsin(i) + C(1)*(Scone(i) - C(3)*Vmaclamda(i)) - C(2)*683*(1 - 2.71^(-(Vprime(i)/(683*6.5))));
    else
        CLA(i) = Melanopsin(i);
    end
    
    CLA(i) = C(4)*CLA(i);
end
CLA = CLA';
%{
% Save the processed data in a file if a second filename was passed to the
% function
if(length(varargin) > 0)
    fid = fopen(varargin{1},'w');
    fprintf(fid, 'time\tRlux\tGlux\tBlux\tLux\tCLA\tActivity\r\n');
    for i = 1:length(time)
        fprintf(fid,'%.6f\t%f\t%f\t%f\t%f\t%f\t%f\r\n',time(i),Rlux(i),Glux(i),Blux(i),Lux(i),CLA(i),Activity(i));
    end
    fclose(fid);
end
%}
% save calibrated data to file
newFileName = [fileName(1:end-4) 'Calibrated.txt'];
fid = fopen(newFileName,'w');
fprintf(fid, 'time\tRlux\tGlux\tBlux\tLux\tCLA\tActivity\r\n');
for i = 1:length(time)
    fprintf(fid,'%.6f\t%f\t%f\t%f\t%f\t%f\t%f\r\n',time(i),Rlux(i),Glux(i),Blux(i),Lux(i),CLA(i),Activity(i));
end
fclose(fid);

% % Plot results
% figure(1)
% plot(time,Lux,'k-')
% datetick2('x');
% ylabel('Illuminance (lux)')
% 
% figure(2)
% %semilogy(time,Lux,'k-')
% %datetick2('x');
% LuxLimit = Lux;
% LuxLimit(LuxLimit<0.004) = 0.004;
% %hold on
% semilogy(time,LuxLimit,'k-')
% datetick2('x');
% hold off
% ylabel('Illuminance (lux)')
% title(['ID# ' num2str(ID,'%.0f')]);
% 
% figure(3)
% plot(time,Rlux,'r')
% hold on
% plot(time,Glux,'g')
% plot(time,Blux,'b')
% hold off
% datetick2('x');
% ylabel('RGB values')
% 
% figure(4)
% plot(time,Activity,'k-')
% datetick2('x');
% ylabel('Activity')

%{
% Calibration Factors
Lux = 298.6;
figure(3)
disp('Zoom figure 2 as necessary')
pause
[x,y] = ginput(2);
index1 = find(time>x(1),1,'first');
index2 = find(time>x(2),1,'first');
Rcount = mean(red(index1:index2))
Gcount = mean(green(index1:index2))
Bcount = mean(blue(index1:index2))
REDcalFactor = Lux/mean(red(index1:index2))
GREENcalFactor = Lux/mean(green(index1:index2))
BLUEcalFactor = Lux/mean(blue(index1:index2))
fprintf(1,'%s  %.4f  %.4f  %.4f\n',num2str(ID),REDcalFactor,GREENcalFactor,BLUEcalFactor);
%}

end
