   %pr.imageformats = {'jpeg','png','tiff','gif'};
   %pr.imageformatstr = pr.imageformats{pr.imageformat};
   
   %{
   % save the movie(s)
   % if neither wf nor eye movies are selected, 'start' remains > 'stop'
   start = 2; stop = 1;
   if make_e_movie,  start=1; which_movie{1}='e_movie';  end
   if make_wf_movie, stop=2;  which_movie{2}='wf_movie'; end
   
   prompt{1}='Save the eyeball movie as:';
   prompt{2}='Save the waveform movie as:';
   
   for m = start:stop  %% if start>stop, nothing is executed
      [fn,pn]=uiputfile({'*.mov;*.avi;*.*'},prompt{m});
      if fn==0, return, end
      [fn,~]=strtok(fn,'.');
      if pn
         %map=get(wfig,'colormap');
         tempmap=colormap; %#ok<NASGU>
         cd(pn)
         switch lower(moviemode(1))
            case 'q'                              
               moviename = [fn '.mov']; %#ok<NASGU>
               eval([ 'qtwrite(' which_movie{m} ', tempmap, moviename, ' ...
                  '[fps/pr.movie_speed, pr.qtcompressor, pr.spatialqual])' ]);
                              
            otherwise
               % save the movie frames as individual images and use QuickTime
               % to turn them into a real movie, not this AVI shit.
               % First, make sure that we are writing frames to new folder
               if pr.make_stills
                  framefold=[fn '_frames'];
                  temp=dir; maxnum=0;
                  foldname=framefold;  %% our inital & default condition
                  for i=1:length(temp)
                     % name already exists?  maybe more than one?  append a number to
                     % the name e.g. 'test_frames1', ... 'test_frames_10',...
                     % the created folder name will be one higher than the previous
                     % highest. will NOT fill in gaps below highest number
                     tempname = temp(i).name;
                     if contains(tempname,framefold)  % name DOES already exist
                        % look for appended number
                        %num = str2double(tempname(find(isdigit(tempname))));
                        num = str2double(tempname(isdigit(tempname)));
                        if isempty(num), num=0; end
                        if num>=maxnum, maxnum=num+1; end
                        foldname=[framefold num2str(maxnum)];
                        
                     else  % name DOES NOT exist
                           % do nothing
                     end
                  end
                  mkdir(foldname); cd(foldname)
                  
                  % write the individual frames. We can use QuickTime Pro's nifty
                  % "Open Image Sequence..." to make a movie from these frames.
                  for i=1:numframes
                     eval([ 'temp_frame = frame2im(' which_movie{m} '(i));' ]);
                     temp_name = ['frame_' num2str(i) '.' pr.imageformatstr];
                     imwrite(temp_frame,temp_name,pr.imageformatstr);
                  end
               end
               
               if pr.make_avi
                  eval([ 'movie2avi(' which_movie{m} ',fn,''Colormap'', tempmap,' ...
                     ' ''fps'', fps/pr.movie_speed);' ]);
               end
               
         end % switch lower(moviemode(1))
      end % if pn
      cd(old_dir)
   end % for m
   %}
