% whatpt.m:  Click on a data point and find what % written by:  Jonathan Jacobs%              October 2000 (last mod: 10/09/00)function whatpt( null )pt = get(gca,'Current');x_pt = pt(1,1);y_pt = pt(1,2);[x_pt, y_pt]whichline = gco;x_dat = get(whichline, 'XData');y_dat = get(whichline, 'YData');x_sort = sort(x_dat);x_tmp1 = [NaN x_sort]; x_tmp2 = [x_sort NaN]; x_min_sep = min(x_tmp2-x_tmp1);y_sort = sort(y_dat);y_tmp1 = [NaN y_sort]; y_tmp2 = [y_sort NaN]; y_min_sep = min(y_tmp2-y_tmp1);x_ind = find( abs(x_dat-x_pt) == min(abs(x_dat-x_pt)) )y_ind = find( abs(y_dat-y_pt) == min(abs(y_dat-y_pt)) )[x_dat(x_ind), y_dat(x_ind)][x_dat(y_ind), y_dat(y_ind)]%x_near = find( abs(x_dat-x_pt)<= x_min_sep )%x_near = abs(x_dat-x_pt)<x_min_sep%find( (x_dat>=x_pt-x_min_sep) & (x_dat<=x_pt+x_min_sep) )%find( (x_dat>=x_pt-x_min_sep) & (x_dat<=x_pt+x_min_sep) ) 