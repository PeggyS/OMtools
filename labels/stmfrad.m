% stmfrad.m Plots +/-0.5 dashed lines on stmtemp = line([t', NaN, t'],[(stm+0.5)', NaN, (stm-0.5)']);set(temp,'color',[0.5 0.5 0.5]);set(temp,'linestyle',':');clear temp