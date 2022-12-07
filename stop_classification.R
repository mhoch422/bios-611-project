library(tidyverse)
library(gbm)
library(matlab)
library(pROC)
library(ggplot2)
pdf(NULL)


dir.create("model_data")
stop_ridership <- read.csv("/home/rstudio/project/derived_data/stop_ridership.csv", header=TRUE, stringsAsFactors = TRUE)

stops <- stop_ridership %>% 
  mutate(boardings = 1*(boardings>50))

train <- runif(nrow(stops)) < 0.80

f <- formula(sprintf("boardings ~ %s", 
                     stops %>%
                       select(zone_id:current_shelter) %>%
                       names() %>% paste(collapse=" + ")))

gbm_model <- gbm(f, data=stops %>% dplyr::filter(train))
s <- summary(gbm_model)
s$rel.inf <- round(s$rel.inf,2)
s %>% write.csv("/home/rstudio/project/model_data/gbm_results.csv", row.names= FALSE) 

gbm_plot <- ggplot(s, aes(var, rel.inf, fill=rel.inf)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=rel.inf), vjust=-0.3, size=3.5)+
  theme_minimal() + 
  labs(title = "Relative influence of variables in gbm model", x = "variable name", y="% influence") +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))
ggsave("figures/gbm_inf.png", width = 6, height = 5, plot= gbm_plot)


test <- stops %>% filter(!train)

test$boardings_p <- predict(gbm_model, newdata=stops %>% dplyr::filter(!train))

test_ex <- test %>% mutate(boardings_p=1*(boardings_p>0.5))

name_map = list("0:0"="true negative", 
                "0:1"="false positive", 
                "1:0"="false negative", 
                "1:1"="true positive")


confusion_base <- test_ex %>% group_by(boardings, boardings_p) %>% tally()

confusion <- test_ex %>% group_by(boardings, boardings_p) %>% tally() %>% 
  mutate(rate_type=name_map[sprintf("%d:%d", boardings, boardings_p)] %>% unlist()) %>%
  select(-boardings, -boardings_p) %>%
  transmute(rate_type=rate_type, rate = n/sum(n))

confusion %>% write.csv("/home/rstudio/project/model_data/stop_classification.csv", row.names= FALSE)

roc_info <- roc(test$boardings, test$boardings_p)

png("figures/roc_plot.png", width = 400, height = 250)
p<- plot(roc_info)
dev.off()


