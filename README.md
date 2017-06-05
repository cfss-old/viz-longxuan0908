# Intro

This project examines the patenting behavior of firms during the dot-com bubble. 

Relevant data can be downloaded [here](http://www.patentsview.org/download/). They are too large for uploading to github. 

To run reproduce our results, you will need to download the following data sets from the link above: "application", "assignee", "ipcr", "nber", "patent", and "usapplicationcitation". 

After you download the data, you should change the path to your local path. Then you should first run the Name_matching.R, then HHI.R, and finally Final_project.Rmd. You should be able to get all the graphs this way. Had the data been smaller I would have made this project much more easier to reproduce.   

Our final product is an HTML file of our research paper.

## Special note on the Rmd file. 

You won't get all the grpahs by simply running the Rmd file because some of the graphs are produced by HHI.R and then pasted to the Rmd file. Running those codes take too much time so those graphs are not feasible to be coded directly in Rmd. 

