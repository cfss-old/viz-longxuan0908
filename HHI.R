library(dplyr) 
library(DBI)
library(RSQLite)
library(ggplot2)
library(readr)
library(foreign)
library(lubridate)

#ipc
ipc <- read_delim("C:/Users/Longxuan/OneDrive/Academics/Winter 2017/ipcr/ipcr.tsv", 
                  "\t", escape_double = FALSE, trim_ws = TRUE)%>%
  select(patent_id, section, ipc_class, subclass)

#patent
application <- read_delim("C:/Users/Longxuan/OneDrive/Academics/Winter 2017/application/application.tsv", 
                          "\t", escape_double = FALSE, trim_ws = TRUE)%>%
  select(patent_id, date)

#nber
nber <- read_delim("C:/Users/Longxuan/OneDrive/Academics/Winter 2017/nber/nber.tsv", 
                   "\t", escape_double = FALSE, trim_ws = TRUE)

#assignee
assignee <- read_delim("C:/Users/Longxuan/OneDrive/Academics/Winter 2017/assignee/assignee.tsv", 
                       "\t", escape_double = FALSE, trim_ws = TRUE)
#concordance
patent_assignee <- read_delim("C:/Users/Longxuan/OneDrive/Academics/Winter 2017/patent_assignee/patent_assignee.tsv", 
                              "\t", escape_double = FALSE, trim_ws = TRUE)

#HHI
HHI <- as.data.frame(matrix(ncol = 38, nrow = 35 ))
HHI[,1] <- c(1980:2014)
k <- 1
for (i in c(11:15, 19, 21:25, 31:33, 39, 41:46, 49, 51:55, 59, 61:69)){
  k <- k+1
patent_i <- nber%>%
  filter(subcategory_id==i)%>%
  select(patent_id)

i_application <- merge(patent_i, application)

#merge
ipc_date <- merge(ipc, i_application)

#HHI
ipc_class <- ipc_date%>%
  mutate(ipc=paste(section, ipc_class))%>%
  select(patent_id, ipc, date)

class_count <- ipc_class%>%
  filter(date>=as.Date("1980-01-01"))%>%
  mutate(year=format(date, "%Y"))%>%
  group_by(year)%>%
  count(ipc)

total <- ipc_date%>%
  filter(date>=as.Date("1980-01-01"))%>%
  filter(date<as.Date("2015-01-01"))%>%
  mutate(year=format(date, "%Y"))%>%
  group_by(year)%>%
  summarize(total=n())

HHI[,k] <- merge(class_count, total)%>%
  mutate(ratio=(n/total)^2)%>%
  group_by(year)%>%
  mutate(HHI=sum(ratio))%>%
  mutate(adj_HHI=(HHI*total-1)/(total-1))%>%
  filter(!duplicated(year))%>%
  ungroup()%>%
  select(adj_HHI)
}

HHI$mean <- rowMeans(HHI[,c(2:8,10:37)])

HHI%>%
  ggplot(aes(V1))+
  geom_line(aes(y=mean, linetype="NBER Subcategory Average, Less Computer"), size=2)+
  geom_line(aes(y=V9, linetype="Computer"), size=2)+
  #geom_vline(xintercept = 2000)+
  #annotate("text", label = "Year 2000", x=2002, y = 0.5, size=5)+
  xlab("Year")+
  ylab("HHI")+
  theme_classic(base_size = 18)+
  theme(legend.position = c(0.6,0.3))+
  theme(legend.key.width = unit(2,"cm"))+
  labs(linetype="Category")


ipc_2000 <- ipc_class%>%
  mutate(year=year(date))%>%
  filter(year==2000)%>%
  count(ipc)%>%
  arrange(-n)%>%
  top_n(10)

