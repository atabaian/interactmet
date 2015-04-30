library(shiny)
library(XML)
library(dplyr)
library(reshape2)
library(tidyr)

is.NullOb <- function(x) is.null(x) | all(sapply(x, is.null))
rmNullObs <- function(x) {
  x <- Filter(Negate(is.NullOb), x)
  lapply(x, function(x) if (is.list(x)) rmNullObs(x) else x)
}

svg_list_nc <- rmNullObs(svg_list)

raw_tbl = svg_list_nc %>% setNames(svg_list_nc %>% sapply("[[",".attrs")) %>% melt %>% as.tbl %>% mutate(is_rxn = grepl("\\$R_",L1))
met_tbl = raw_tbl %>% mutate(raw_id = gsub("::.*","",L1)) %>% filter(!is_rxn)

met_tbl_title = met_tbl %>% filter(L2 == "title") %>% lapply(as.character) %>% as_data_frame %>% mutate(nn = nchar(value)) 



saveRDS(met_tbl_final,"")
met_tbl_final = readRDS("")
met_tbl <- met_tbl[(met_tbl$L2=="title"),]
met_tbl1 <- transform(met_tbl, n=nchar(as.character(value)))
met_tbl1 <- arrange(met_tbl1,n)
met_tbl1 = met_tbl1 %>% mutate(is_4 = grepl("32",n))
met5 = met_tbl1  %>% filter(!is_4)
met_tbl4 = met_tbl4 %>% mutate(Rxn_Id = "none")

met_tbl5 <- separate(data = met_tbl5, col = value, into = c("Met_id","Rxn_Id", "Subsystem","Compartment 1","Compartment 2"), sep = "\\::")
met_tbl4 <- separate(data = met_tbl4, col = value, into = c("Met_id", "Subsystem","Compartment 1","Compartment 2"), sep = "\\::")

met_tbl5[,c("L2","L1","n","numb","is_4","is_rxn")] <-list(NULL)
met_tbl4[,c("L2","L1","n","numb","is_4","is_rxn")] <-list(NULL)
met_tbl1 <- rbind(met_tbl5,met_tbl4)
rm(met5)
rm(met4)

rxn_tbl1 = raw_tbl  %>% filter(is_rxn)
rxn_tbl1 <- rxn_tbl1[(rxn_tbl1$L2==".attrs"),]
rxn_tbl1[,c("L2","is_rxn","L1")] <-list(NULL)
rxn_tbl1 <- separate(data = rxn_tbl1, col = value, into = c("Rxn_Id", "Rxn_part"), sep = "\\::")
rxn_tbl1 <- rxn_tbl1[with(rxn_tbl1, order(Rxn_Id,Rxn_part)), ]
rxn_tbl1[,c("Rxn_part")] <-list(NULL)
rxn_tbl1 <- aggregate(list(Rxn_segs=rep(1, nrow(rxn_tbl1))), rxn_tbl1, length)



