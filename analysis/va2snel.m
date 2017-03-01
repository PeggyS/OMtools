% va2snel.m: convert between VA decimal and Snellen fraction.% Usage: out = va2snel(va_or_snel, inputValue);%% where va_or_snel = 1 converts VA to NAF%                 = 2 converts NAF to VA% inputValue is the number to be converted.% snel = 0 returns 'out' as a decimal.%      = 1 returns 'out' as a Snellen fraction.%% Alternatively, you can simply type "va2naf" and follow the prompts% Written by:  Jonathan Jacobs%              May 1998 - October 1999 (last mod: 10/15/99)function out = va2snel(inpVal, va_or_snel)if nargin == 0   va_or_snel = -1;   inpVal=-1;   verbose=1; else   verbose=0;endwhile(va_or_snel<1) | (va_or_snel>2)   disp(' 1) Convert VA decimal to Snellen fraction')   disp(' 2) Convert Snellen fraction to VA decimal')   va_or_snel = input(' --> ');endif va_or_snel == 1   va=inpVal;   while (va<0) | (va>1.5)      va = input('Enter the visual acuity: ');   end   denom=20/va;   basedenom = fix(denom/5)*5;   remainder = denom-basedenom;   if remainder == 0      sneldenom = basedenom;      tweak = '';     elseif remainder < 2.5      sneldenom = basedenom;      tweak = '-';     else      sneldenom = basedenom+5;      tweak = '+';   end   if verbose      disp(['  Snellen Acuity:  20/' num2str(sneldenom) tweak...            '  (20/' num2str(round(denom)) ')' ])      return   end   if 1      out = ['20/' num2str(sneldenom) tweak];     else      out = va;   end else   temp=inpVal;   while (temp<0) | (temp>1.5)      temp = input('Enter the Snellen fraction: ');   end   if verbose      disp(['  VA calculated to be ' num2str(temp)])   end   end