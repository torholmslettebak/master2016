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


On furter research:
To identify as correct influence lines as possible, try to isolate the locomotive in the strain signal, and use that to calculate influence lines.
This will if possible provide a way to calculate the influence lines without actually weighing the train beforehand. THis because the locomotive will vary less in weight than the passengerwagon.. However many locomotives also carries passengers, which may throw this method off as well..
