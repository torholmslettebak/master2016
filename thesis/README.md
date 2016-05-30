# master2016
Master Thesis Bridges - by Tor Holm Slettebak
to compile:
Due to very big figure files this thesis should be compiled with lualatex.
If you dont want that you need to increase memory size and such...



NOTES TO SELF:
TODO:
Filter the signal before applying matrix method.
Compare results found..

Ananlysis... DIscuss dynamic part..
The influence lines should not include dynamic, so discuss how to remove this from the found influence lines..
Either by cutting the found influence line, or by making it zero where it should be zero..

Look at the dynamics, identify frequency of waves.. Comparable with bridge eigenfrequency and so on

Look into optimization if time allows...


RESEARCH QUESTION:

How to find the influence line of a bridge through a BWIM system.
Accurately determining a bridge's influence line through a strain gauge.


To compare errors the strain signals should be of about the same length.
Create two error table one where the signal has been smoothed for 600 samples before and after
And one where the signal has not been smoothed beforehand, like what exists now. But with 600 samples before and after.

commit:
continue where you left off, that is fix plots corresponding to the two different versions of the influence lines.. Create a table showing the found axle weights for the different influence lines.. do this for all sensors and influence lines.. And all train signals..
Point at error in estimation of axle weights to begin with.. espacially carriage vagon seems to be wrong.. test with severar trains
Explain more in method chapter on how influence lines are placed...

On furter research:
To identify as correct influence lines as possible, try to isolate the locomotive in the strain signal, and use that to calculate influence lines.
This will if possible provide a way to calculate the influence lines without actually weighing the train beforehand. THis because the locomotive will vary less in weight than the passengerwagon.. However many locomotives also carries passengers, which may throw this method off as well..















continue where you left off, that is fix plots corresponding to the two different versions of the influence lines.. Create a table showing the found axle weights for the different influence lines.. do this for all sensors and influence lines.. And all train signals..
Point at error in estimation of axle weights to begin with.. espacially carriage vagon seems to be wrong.. test with severar trains
Explain more in method chapter on how influence lines are placed...

FIx plots in method chapter, scale them correctly and such..

Fix stupid table lines..



Filter value in Hz to identify all peaks..
train   - sensor1           - sensor2 - sensor3
Train 3 - 21 Hz,                                                                minpeakheight important
train 4 - 22 Hz,                                                                minpeakdistance important 'MinPeakDistance' = 80)
train 5 - 20 Hz,                                                                'MinPeakDistance', 40... Very hard to find peaks, and they are also very wrong.. bad signal
train 6 - 20 Hz,                                                                     'MinPeakDistance', 50)
train 7
train 8 - 20 Hz,                                                                     'MinPeakDistance', 50)



TRAIN 5 is a shittty train... actually calculates negative axle weights... maybe sensorplacement becomes very wrong with the trains that prove difficult to find axle peaks in strain.. placement of the influence line becomes all wrong

Ive put some work into identify frequencies for filtering and placements of influence lines.. works well for some cases bad for others... especially train 5 and train 3 the other 3 works very well...
Try looking into the speed of train 3 and 5, might be something bad with that... try to identify speed by looking at axle samples..

If all else fails look at how the influence line places along with the first axle peak in plot.. if its far off somethings very wrong...
try possibly to plot all influence lines along with peaks.. Might give a good image of what could be wrong.. also a good plot for thesis..

Further the other sensors also needs to be worked on, might give a better image of speed,, you could try the old fashioned speed method..





Problemstilling
Hvordan bygge et BWIM system for ei jernbanebru i stål med tøyningssensorer plassert langs en langbærer
How to build a BWIM program for a steel railway bridge with strain sensors along it stringers.  
