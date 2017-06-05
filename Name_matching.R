library(dplyr) 
library(DBI)
library(RSQLite)
library(ggplot2)
library(readr)
library(foreign)
library(stringi)
#assignee
assignee <- read_delim("C:/Users/Longxuan/OneDrive/Academics/Winter 2017/assignee/assignee.tsv", 
                       "\t", escape_double = FALSE, trim_ws = TRUE)



assignee <- rename(assignee, assignee_id=id)
assignee <- assignee%>%
  filter(!is.na(organization))%>%
  filter(!duplicated(organization))
organization <- assignee$organization

#remove non-english
index <- grep("Non-English", iconv(organization, "UTF-8","UTF-8", sub="Non-English"))
assignee <- assignee[-index,]

#capitalization
organization <- assignee$organization
for (k in seq_along(organization)){
  suppressWarnings(try(organization[k] <- toupper(organization[k]), silent = TRUE))
}


#remove white space
organization <- stri_replace_all_charclass(organization, "\\p{WHITE_SPACE}","")

#remove punctuation
organization <- gsub("[[:punct:]]","", organization)

#remove company identifiers
organization <- gsub("(AB|AG|BV|CENTER|CO|COMPANY|COMPANIES|CORP|CORPORATION|DIV|GMBH|GROUP|INC|INCORPORATED|KG|LC|LIMITED|LIMITEDPARTNERSHIP|LLC|LP|LTD|NV|PLC|SA|SARL|SNC|SPA|SRL|TRUST|USA)$",
                     "",organization)
organization <- gsub("(CO|COMPANY|CORP|CORPORATION|GROUP|LIMITED|MANUFACTURING|MFG|PTY|USA)$",
                     "",organization)
#done
assignee$organization <- organization

