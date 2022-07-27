library(ranger)
library(tuneRanger)
library(mlr)
library(OpenML)
library(randomForest)
library(readr)
plioc <- read_delim("~/plioc.csv", delim = ";",escape_double = FALSE, col_types = cols(Status = col_factor(levels = c()),LatitudinalRangePlio = col_number(),Latmidpoint = col_number()), trim_ws = TRUE)
#Model Optimization
task<-makeClassifTask(data=as.data.frame(plioc),target="Status")
estimateTimeTuneRanger(task)
set.seed(123)
res = tuneRanger(task, measure = list(multiclass.brier),num.trees = 1000, iters = 70, iters.warmup = 30)
res
tuner<-res$recommended.pars
mtry<-tuner$mtry
sample<-tuner$sample.fraction
#Run model
rn<-ranger(Status~.,data = plioc,importance = "impurity",num.trees = 1000,mtry =mtry,min.node.size = 1,sample.fraction = sample)
rn
