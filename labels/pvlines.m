% plotPV.m: plot the PV relationships over existing data% written by:   Jonathan Jacobs%               November 2000 - December 2001 (last mod: 12/05/01)function plotPV(r,c)if nargin < 2   r=1; c=1;endxlims = get(gca,'XLim');max_ampl = xlims(2);ampl_vec = 0:0.1:max_ampl;% From Becker: "Metrics" in "Neurobiology of saccadic eye movements"% edited by Wurtz & Goldberg% (Becker got it wrong! Yarbus should be '0.4', not '0.2')%dur_yar = (ampl_vec .^ 0.2)  * 21;dur_yar = (ampl_vec .^ 0.4)  * 21;dur_bah = (ampl_vec .^ 0.15) * 26;PV_ZS   = (ampl_vec .^ 1.0)  * 60;PV_Bah  = (ampl_vec .^ 0.9)  * 80;% from JBJ RSR study%ampl2 = 0:0.1:11;%PV_jac  = -1.9613*(ampl2.^ 2.0) + (50.599*ampl2);ampl2  = [0 2.8902 6.05 11.07];PV_jac = [9.537 139.2277 227.1982 337.13];% PV from BeckerPV_Bec = 608*(ampl_vec./(ampl_vec+7.6));% PV relationship from Boghen et al. (IOVS Aug 74)bog_x   = [  0   1   5  10  20  30];PV_bog  = [NaN  65 189 288 385 428];PV_bogl = [NaN NaN 145 196 213 227];PV_bogh = [NaN NaN 213 377 555 625];w=1;for i = 1:r   for j = 1:c      if nargin == 2         subplot(r,c,w)      end      hold on      temp=plot(ampl_vec, PV_Bec);      set(temp,'Color',[0.5 0.5 0.5]);      set(temp,'LineStyle','-.');         temp=line([bog_x NaN bog_x NaN bog_x],...                [PV_bog NaN PV_bogl NaN PV_bogh]);      set(temp,'Color',[0.75 0.75 0.75]);      set(temp,'LineStyle','--');      temp=plot(ampl2, PV_jac);      set(temp,'Color',[1 1 1]);      set(temp,'LineStyle','-');      w=w+1;   endend