%Hate Based Rhetoric Project Experiment 1

%This section taken From Jonas Kaplan Psych 599 Course Materials

%Find DAQ device number
devices = PsychHID('devices');
USBdeviceNum = 0;
DAQFound = 0;

for i=1:length(devices)
    if strcmp(devices(i).product, 'USB-1024LS')
        USBdeviceNum = i;
    end
end

%Let user know device is found
if (USBdeviceNum < 1)
    fprintf('Error: Could not locate USB device.\n');
else
    fprintf('FOUND DAQ device at %d', USBdeviceNum);
    DAQFound = 1;
end

% set biopac output value to zero-will be baseline for other triggers to
% appear in
%Configuring port determines if it will be output (third value = 0), or
%input(third value = 1)
if (DAQFound) 
    DaqDConfigPort(USBdeviceNum,1,0);
    DaqDConfigPort(USBdeviceNum,4,0);
end

 
%% Hate Based Rhetoric Project trigger values

%By Erin Ryan 2019,2020

%set biopac NULL trigger value (between events/fixed across tasks)
biopac_trigger_null = 0;
biopac_trigger_time_align =1;
practice_stimuli = 1;
stimuli_presentation = 1;

 
%% present stimuli for hate based rhetoric project

%By Erin Ryan 2019,2020
 
Screen('Preference', 'SkipSyncTests', 1);
%get subject number
%getSubjectNumber
%Make Screen
 
%send start triggers to align analog and digital channels
 if (DAQFound)
        %start experiment clock 
       tstart = datetime('now');
       start_time = tstart;
       DaqDOut(USBdeviceNum,1,biopac_trigger_time_align);
       DaqDOut(USBdeviceNum,4,biopac_trigger_time_align);
       DaqDOut(USBdeviceNum,1,biopac_trigger_null);
       DaqDOut(USBdeviceNum,4,biopac_trigger_null);
 end

 
[subNumber,rect0] = Screen('OpenWindow',0,[],[]);
 
%screen parameters
textColor = 20;%dark grey
Screen('TextFont', subNumber, 'Arial');
Screen('TextSize', subNumber, 40);
wrapAt = 150; %characters per line
[subnum,startRT0,endRT0] = GetEchoStringFreeResponse(subNumber,'What is your subject number? Press enter when finished',1150,600,20,20,20,25);
[VBLTimestamp_subnum, StimulusOnsetTimestamp_subnum, FlipTimestamp_subnum]=Screen('Flip',subNumber);
 
start_time_clock = "start of experiment clock time";
char [*subnum,*start_time];    
f = fopen([subnum '.txt'], 'a');
fprintf(f, '%s\n',start_time_clock,start_time);
fclose(f);
%present instructions
 
%send instruction triggers
 if (DAQFound)
         tpracticeinstructions = datetime('now');
         practiceq_time = tpracticeinstructions-tstart;
         practiceq_time_ms = milliseconds(practiceq_time);
         practiceq_time_ins = "clock time before start of practice q's:";
         practiceq_time_ins_s = "time from start in s:";
         practiceq_time_ins_ms = "time from start in ms:";
         char [*subnum,*practiceq_time,*practiceq_time_ins,*practiceq_time_ms,practiceq_time_ins_ms];    
         f = fopen([subnum '.txt'], 'a');
         fprintf(f, '%s,%s,%s,%s,%s,%d\n',practiceq_time_ins,tpracticeinstructions,practiceq_time_ins_s,practiceq_time,practiceq_time_ins_ms,practiceq_time_ms);
         fclose(f);
         DaqDOut(USBdeviceNum,1,biopac_trigger_time_align);
         DaqDOut(USBdeviceNum,1,biopac_trigger_null);
 end
  
DrawFormattedText(subNumber, 'Thank you for participating in this study! This study is investigating how people respond to different types of posts taken from the social media platform “Gab.” All of the posts you will read were actually posted online by a real person, with no affiliation to the Zevin Lab. Some of the posts you will be shown will contain examples of hate based rhetoric, and some will not. Hate based rhetoric is speech that incites hatred or violence toward someone/a group of people based on a characteristic of their identity, such as race, gender, orientation, disability, religion, etc.',400,400,textColor,wrapAt);
DrawFormattedText(subNumber, 'Trigger warning: by participating in this sudy, you will be exposed to mentions of rape, graphic violence, and the use of slurs.',400,650,textColor,wrapAt);
DrawFormattedText(subNumber, 'While you read each post, we will take physiological recordings to measure your emotional, cognitive, and stress responses. Additionally, you will be asked to assess how offensive you think each post is on a scale of 1-7. If at any time during this study you become uncomfortable or distressed, or want to stop participating for any reason, please alert one of our lab assistants. You may stop participating for any reason at any time.',400,800,textColor,wrapAt);
DrawFormattedText(subNumber, 'You will now complete some practice examples. Press “Enter” when you are ready to continue to the practice section.',400,1000);
%transition to practice questions    
[VBLTimestamp_ins, StimulusOnsetTimestamp_ins, FlipTimestamp_ins]=Screen('Flip', subNumber);
KbStrokeWait;

%present practice questions
 
%read in file containing practice questions
[~,~,Y] = xlsread(['practice_questions.csv']);

%present practice q's and record answers

for i=1:length(Y)
    %how matlab should read in file
    myText = Y{i, 1}; % text is in the first column
    quenum = Y{i, 2};% question IDs are in the second column
    stimgroupid = Y{i, 3}; %ID of group number of stimuli, to indicate whether stim. is target hate, 
    %non-target hate, neutral, or provocative neutral
    biopac_stim_quenum=quenum; %define trigger as question number read in
    
    %send practice triggers
 if (DAQFound)
          practice_q_presentation = datetime('now');
          practice_q_presentation = practice_q_presentation-tstart;
          practice_q_presentation_ms = milliseconds(practice_q_presentation);
          DaqDOut(USBdeviceNum,4,practice_stimuli);
          DaqDOut(USBdeviceNum,4,biopac_trigger_null);
       
 end
 
   %present questions
    DrawFormattedText(subNumber, myText,'center',400,textColor,wrapAt);
    DrawFormattedText(subNumber, '(Not Offensive)   1        2        3        4        5        6        7   (Extremely Offensive)',900,800,textColor);
    DrawFormattedText(subNumber, 'Press Enter When Finished',1350,1200,textColor,wrapAt);
    [response1] = GetEchoStringDisplay(subNumber,'Using the scale of 1-7 shown above, how offensive is this post? Answer:',1000,1000,20,[]);
   %transition to next question/section at end of loop
    [VBLTimestamp_practiceq, StimulusOnsetTimestamp_practiceq, FlipTimestamp_practiceq]=Screen('Flip',subNumber,[.5]);
    
        
%save response to txt.
%add strings for each additional stimuli response.to add 3+ strings, add to
%line fprintf(f,"more:%s\n", str3, str4...);
 
    char [*subnum, *response1, *response2,*practice_q_presentation,*practice_q_presentation_ms];
%FILE *f;

   % output is subject number, then question ID, then Likert response, then
   % timestamps
    %to add a response to the saved output file, be sure to also add a "%s"
    %at the beginning
    %Responses will be saved in a document named with participant number
    f = fopen([subnum '.txt'], 'a');
    fprintf(f, '%s,%i,%s,%s,%d\n', num2str(quenum),stimgroupid, response1,practice_q_presentation,practice_q_presentation_ms);
    fclose(f);
 
 
end
 
%Notice that actual stimuli are about to be presented
%send instruction triggers
 if (DAQFound)
         DaqDOut(USBdeviceNum,1,biopac_trigger_time_align);
         DaqDOut(USBdeviceNum,1,biopac_trigger_null);
         end_practice_align = datetime('now');
         end_of_practice_time = end_practice_align-tstart;
         end_of_practice_ms = milliseconds(end_of_practice_time);
         practice_end_clock_time = "End of Practice Clock Time";
         practice_end_clock_s = "time since start in s:";
         practice_end_clock_ms = "time since start in ms:";
         char [*subnum,*end_of_practice_time,*practice_end_clock_time];    
         f = fopen([subnum '.txt'], 'a');
         fprintf(f, '%s,%s,%s,%s,%s,%d\n',practice_end_clock_time,end_practice_align,practice_end_clock_s,end_of_practice_time,practice_end_clock_ms,end_of_practice_ms);
         fclose(f);
              
end

DrawFormattedText(subNumber,'The practice session is over. The study is about to begin. Press Enter when you are ready to begin.',700,600,textColor,wrapAt);
[VBLTimestamp_ins2, StimulusOnsetTimestamp_ins2, FlipTimestamp_ins2]=Screen('Flip',subNumber);
KbStrokeWait; 

% derive the version number from the subject number-which randomized
% stimuli set will they get? (Not needed for standard practice q's seen
% previously)
vernum = mod(str2num(subnum), 3); % where 3 is the number of different orders of questions you have
%read in text to present stimuli. Replace 'stimcsvtest.csv' placeholder with actual
%excel file with stimuli
[~, ~, Y] = xlsread(['stimcsvtest_' num2str(vernum) '.csv']);
%Present Test stimuli and record answers
 for i=1:length(Y)
   wrapAt2 = 100; %shorter number of characters per line in this section to prevent cutting off
   myText = Y{i, 1}; % text is in the first column
   quenum = Y{i, 2}; % question IDs are in the second column
   stimgroupid = Y{i, 3}; %ID of group number of stimuli, to indicate whether stim. is target hate, 
   %non-target hate, neutral, or provocative neutral
   biopac_stim_quenum=quenum; %define trigger as question number read in
   
   %send stimulus being presented triggers
   if (DAQFound)
         stimuli_presentation_time = datetime('now');
         stimuli_presentation_time = stimuli_presentation_time-tstart;
         stimuli_presentation_time_ms = milliseconds(stimuli_presentation_time);
         DaqDOut(USBdeviceNum,4,stimuli_presentation);
         DaqDOut(USBdeviceNum,4,biopac_trigger_null);
  
   end
   
   DrawFormattedText(subNumber, myText,'center',400,textColor,wrapAt2);
   DrawFormattedText(subNumber, '(Not Offensive)   1        2        3        4        5        6        7   (Extremely Offensive)',900,800,textColor);
   DrawFormattedText(subNumber, 'Press Enter When Finished',1300,1200,textColor,wrapAt);
   [response1] = GetEchoStringDisplay(subNumber,'Using the scale of 1-7 shown above, how offensive is this post? Answer:',950,1000,20,[]);
   
   [VBLTimestamp_stimuli, StimulusOnsetTimestamp_stimuli, FlipTimestamp_stimuli]=Screen('Flip',subNumber,[.5]);
    
%save response to txt.
%add strings for each additional stimuli response.to add 3+ strings, add to
%line fprintf(f,"more:%s\n", str3, str4...);
 
    char [*subnum, *response1, *response2, *stimuli_presentation_time,*stimuli_presentation_time_ms];
%FILE *f;
 
%Responses will be saved in a document named with participant number
    %f = fopen([subnum '.txt'], 'a');
    % output is subject number, then question ID, then Likert response
    %to add a response to the saved output file, be sure to also add a "%s"
    %at the beginning
    f = fopen([subnum '.txt'], 'a');
    fprintf(f, '%s,%i,%s,%s,%d\n', num2str(quenum),stimgroupid, response1,stimuli_presentation_time,stimuli_presentation_time_ms);
    fclose(f);
   
  end
 
 
 %send end triggers
if DAQFound
         endtime = datetime('now');
         end_of_study_time = endtime - tstart;
         end_of_study_time_ms = milliseconds(end_of_study_time);
         end_time_clock = "end_of_study_clock";
         end_time_clock_s = "time since start in s:";
         end_time_clock_ms = "time since start in ms:";
         
         char [*subnum, *end_time_clock,*end_time_clock_s,*end_time_clock_ms,*end_of_study_time,*endtime,*end_of_study_time,*end_of_study_time_ms];    
         f = fopen([subnum '.txt'], 'a');
         fprintf(f, '%s,%s,%s,%s,%s,%d\n',end_time_clock,endtime,end_time_clock_s,end_of_study_time,end_time_clock_ms,end_of_study_time_ms);
         fclose(f);
         DaqDOut(USBdeviceNum,1,biopac_trigger_time_align);
         DaqDOut(USBdeviceNum,4,biopac_trigger_time_align);
         DaqDOut(USBdeviceNum,1,biopac_trigger_null);
         DaqDOut(USBdeviceNum,4,biopac_trigger_null);
 end

%present end of study message

DrawFormattedText(subNumber,'The study is now over. Thank you for your participation! Please go tell the researcher you are finished.',700,600,textColor,wrapAt);
[VBLTimestamp_endtime, StimulusOnsetTimestamp_endtime, FlipTimestamp_endtime]=Screen('Flip',subNumber);
KbStrokeWait; 

Screen('Close', subNumber);


 