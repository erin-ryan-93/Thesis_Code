
   
%From Padideh Nasseri Mather Lab 2021
%test if biopac is connected

biopac = 'Y'
 
 if biopac == 'Y' || biopac == 'y'
    bp = 1;
elseif biopac == 'N' || biopac == 'n'
    bp = 0;
else
    bp = 0;
end

%setup and check parallel port connection
%biopac_address = 'DFF8'; % port address
biopac_address = 493974080
if bp == 1
   ioObj = io64;
   status = io64(ioObj);
   if status ~= 0 
       error('Biopac connection is not working.')
   end
end

%By Erin Ryan 2019, 2020, 2021

%% present stimuli for hate based rhetoric project
%Erin Ryan 2019-2021

%Make Screen
Screen('Preference', 'SkipSyncTests', 1);
%get subject number
%getSubjectNumber

%Sends Trigger to signal start of experiment

%opens serial port for communication
s = serial('COM4');
 set(s,'BaudRate', 115200, 'DataBits',8,'StopBits',1,'Parity','none');
% %sets ip session to be able to send signals through serial connections.
% %Each term and following entry (eg: BaudRate:115200) are read as one
% %concept; thus 115200 is the baudrate, 8 is the numbe of databits, etc. For
% %a binary signal like this (on vs off) 8 databits should be used. Parity
% %checks whether a signal was recorded or not. This is not needed here. Do
% %StopBits cannot be set below one-tells transmitter that signal is
% %completely sent after sending one bit of data. This is what on-off data
% %falls under. Keep at 1.
%These lines only need to be set once

%Begins signal sending (opens data 'flow')
fopen(s);
%which channel to send thru (FF) defined by hex code
fprintf(s,'01');
%turns signal on
fprintf(s,'04');
%turns signal off
fprintf(s,'00');    
%closes 'flow' of signal-need this for "stick" peak marker
fclose(s);



[subNumber,rect0] = Screen('OpenWindow',0,[],[]);
 
%screen parameters
textColor = 20;%dark grey
Screen('TextFont', subNumber, 'Arial');
Screen('TextSize', subNumber, 40);
wrapAt = 150; %characters per line
[subnum,startRT0,endRT0] = GetEchoStringFreeResponse(subNumber,'What is your subject number? Press enter when finished',500,400,20,20,20,25);
[VBLTimestamp_subnum, StimulusOnsetTimestamp_subnum, FlipTimestamp_subnum]=Screen('Flip',subNumber);
 
start_time_clock = "start of experiment clock time";
start_time = datetime('now');
tstart = datetime('now')
char [*subnum,*start_time];    
f = fopen([subnum '.txt'], 'a');
fprintf(f, '%s\n',start_time_clock,start_time);
fclose(f);
%present instructions

%signal to mark presentation of instruction-send on same channel as start
%and end times, send presentation markers on different channel;

fopen(s);
fprintf(s,'01');
fprintf(s,'04');
fprintf(s,'00');    
fclose(s);

%send instruction triggers
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
 
wrapAt = 95; %characters per line
DrawFormattedText(subNumber, 'Thank you for participating in this study! This study is investigating how people respond to different types of posts taken from social media. All of the posts you will read were actually posted online by a real person, with no affiliation to the Zevin Lab. Some of the posts you will be shown will contain examples of hate based rhetoric, and some will not. Hate based rhetoric is speech that incites hatred or violence toward someone/a group of people based on a characteristic of their identity, such as race, gender, orientation, disability, religion, etc.',150,100,textColor,wrapAt);
DrawFormattedText(subNumber, 'Trigger warning: by participating in this sudy, you will be exposed to mentions of rape, graphic violence, and the use of slurs.',150,450,textColor,wrapAt);
DrawFormattedText(subNumber, 'While you read each post, we will take physiological recordings to measure your emotional, cognitive, and stress responses. Additionally, you will be asked to assess how offensive you think each post is on a scale of 1-7. If at any time during this study you become uncomfortable or distressed, or want to stop participating for any reason, please alert one of our lab assistants. You may stop participating for any reason at any time.',150,600,textColor,wrapAt);
DrawFormattedText(subNumber, 'You will now complete some practice examples. Press “Enter” when you are ready to continue to the practice section.',150,900,textColor, wrapAt);
[VBLTimestamp_ins, StimulusOnsetTimestamp_ins, FlipTimestamp_ins]=Screen('Flip', subNumber);
KbStrokeWait;

%present practice questions
 
%read in file containing practice questions. xlsread is used here because
%it keeps row information together- in this case, stimuli text, stimuli
%category ID, stimuli individual ID. readcsv and realted functions do not
%do this at the time of writing. You will need to use Windows 7 to use this
%function as Windows 10 now heavily restircts access to .dll's
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
      practice_q_presentation = datetime('now');
      practice_q_presentation = practice_q_presentation-tstart;
      practice_q_presentation_ms = milliseconds(practice_q_presentation);
     
      
fopen(s);
fprintf(s,'04');
fprintf(s,'00');    
fclose(s);

%present questions
pause_time = 5;
DrawFormattedText(subNumber, myText,'center',400,textColor,wrapAt);
DrawFormattedText(subNumber, '(Not Offensive)   1        2        3        4        5        6        7   (Extremely Offensive)',300,700,textColor);
DrawFormattedText(subNumber, 'Press Enter When Finished',1350,1200,textColor,wrapAt);
[response1] = GetEchoStringDisplay(subNumber,'Using the scale of 1-7 shown above, how offensive is this post? Answer:',300,900,20,[]);
%transition to next question/section at end of loop
[VBLTimestamp_practiceq, StimulusOnsetTimestamp_practiceq, FlipTimestamp_practiceq]=Screen('Flip',subNumber,[.5]);
WaitSecs(pause_time);
    
        
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


fopen(s);
fprintf(s,'01');
fprintf(s,'04'); 
fprintf(s,'00');
fclose(s);

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
         
         DrawFormattedText(subNumber,'The practice session is over. The study is about to begin. Press Enter when you are ready to begin.',200,300,textColor,wrapAt);
[VBLTimestamp_ins2, StimulusOnsetTimestamp_ins2, FlipTimestamp_ins2]=Screen('Flip',subNumber);
KbStrokeWait; 

% derive the version number from the subject number-which randomized
% stimuli set will they get? (Not needed for standard practice q's seen
% previously)
vernum = mod(str2num(subnum), 3); % where 3 is the number of different orders of questions you have
%read in text to present stimuli. Replace 'stimcsvtest.csv' placeholder with actual
%excel file with stimuli
[~, ~, Y] = xlsread(['stimcsvtest_' num2str(vernum) '.csv']);

%Present Experiment stimuli and record answers
 for i=1:length(Y)
   wrapAt2 = 100; %shorter number of characters per line in this section to prevent cutting off
   myText = Y{i, 1}; % text is in the first column
   quenum = Y{i, 2}; % question IDs are in the second column
   stimgroupid = Y{i, 3}; %ID of group number of stimuli, to indicate whether stim. is target hate, 
   %non-target hate, neutral, or provocative neutral
   biopac_stim_quenum=quenum; %define trigger as question number read in
   
   %send stimulus being presented triggers
  stimuli_presentation_time = datetime('now');
  stimuli_presentation_time = stimuli_presentation_time-tstart;
  stimuli_presentation_time_ms = milliseconds(stimuli_presentation_time);
  
fopen(s);
fprintf(s,'04');
fprintf(s,'00');    
fclose(s);
        
pause_time = 5;
DrawFormattedText(subNumber, myText,'center',400,textColor,wrapAt2);
DrawFormattedText(subNumber, '(Not Offensive)   1        2        3        4        5        6        7   (Extremely Offensive)',300,700,textColor);
DrawFormattedText(subNumber, 'Press Enter When Finished',1300,1200,textColor,wrapAt);
[response1] = GetEchoStringDisplay(subNumber,'Using the scale of 1-7 shown above, how offensive is this post? Answer:',300,900,20,[]);
[VBLTimestamp_stimuli, StimulusOnsetTimestamp_stimuli, FlipTimestamp_stimuli]=Screen('Flip',subNumber,[.5]);
WaitSecs(pause_time);

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
         
fopen(s);
fprintf(s,'01');
fprintf(s,'04');
fprintf(s,'00');    
fclose(s);

%present end of study message

DrawFormattedText(subNumber,'The study is now over. Thank you for your participation! Please go tell the researcher you are finished.',200,400,textColor,wrapAt);
[VBLTimestamp_endtime, StimulusOnsetTimestamp_endtime, FlipTimestamp_endtime]=Screen('Flip',subNumber);
KbStrokeWait; 


Screen('Close', subNumber); 


 
 
    