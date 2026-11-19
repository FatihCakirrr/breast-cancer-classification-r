library(mice)
library(caret)
library(rpart)
library(rpart.plot)
library(dplyr)
library(randomForest)
library(e1071)
library(class)

file.path<-file.choose()
data<-read.csv(file.path,header = TRUE, sep =",")
str(data)

birlesmis_veri<-c("Age","BMI","Glucose","Insulin","HOMA","Leptin",
                  "Adiponectin","Resistin","MCP.1","Classification")
data$Classification <- as.factor(data$Classification)
summary(data)

imp<-mice(data,m=1,method="pmm",maxit=5,seed=123)
data_imputed<-complete(imp)

set.seed(123)
train<-data_imputed%>%sample_frac(0.8)
test<-anti_join(data_imputed,train)
summary(train)

tree_model<-rpart(Classification~.,data = train,method="class")
rpart.plot(tree_model,type=3,extra=101)
pred<-predict(tree_model,test,type="class")
conf_mat<-confusionMatrix(pred,test$Classification,positive="1")

set.seed(123)
rf_model<-randomForest(Classification~.,data=train,ntree=500,mtry=4,importance=TRUE)
pred_rf<-predict(rf_model,test)
conf_rf<-confusionMatrix(pred_rf,test$Classification,positive = "1")
varImpPlot(rf_model,main="De??i??ken ??nem grafi??i")


#knn modeli

set.seed(123)
library(class)
ctrl<-trainControl(method = "cv",number=5)
knn_model<-train(Classification~.,data=train,method="knn",trControl=ctrl)
cat("en iyi k degeri: ",knn_model$bestTune$k)
pred_knn<-predict(knn_model,test)
conf_knn<-confusionMatrix(pred_knn,test$Classification,positive = "1")

set.seed(123)
library(e1071)
nb_model<-naiveBayes(Classification~.,data = train)
pred_nb<-predict(nb_model,test)
conf_nb<-confusionMatrix(pred_nb,test$Classification)

set.seed(123)
library(e1071)
svm_model<-svm(Classification~.,data = train,kernel="radial",cost=1, scale=TRUE)
pred_svm<-predict(svm_model,test)
conf_svm<-confusionMatrix(pred_svm,test$Classification)

compare_results<-data.frame(Model=c("Karar agaci","Rastgele orman","knn","naiveBayes","SVM"),
                            Dogruluk=c(conf_mat$overall["Accuracy"],conf_rf$overall["Accuracy"],conf_knn$overall["Accuracy"],conf_nb$overall["Accuracy"],conf_svm$overall["Accuracy"]),
                            Duyarlilik=c(conf_mat$byClass["Sensitivity"],conf_rf$byClass["Sensitivity"],conf_knn$byClass["Sensitivity"],conf_nb$byClass["Sensitivity"],conf_svm$byClass["Sensitivity"]),
                            Ozgulluk=c(conf_mat$byClass["Specificity"],conf_rf$byClass["Specificity"],conf_knn$byClass["Specificity"],conf_nb$byClass["Specificity"],conf_svm$byClass["Specificity"]),
                            Kesinlik=c(conf_mat$byClass["Precision"],conf_rf$byClass["Precision"],conf_knn$byClass["Precision"],conf_nb$byClass["Precision"],conf_svm$byClass["Precision"]))
compare_results

new_data<-data.frame(
  Age=50,
  BMI=28,
  Glucose=140,
  Insulin=31,
  HOMA=12,
  Leptin=45,
  Adiponectin=20,
  Resistin=19,
  MCP.1=1000
)
birlesmis_veri<-c("Age","BMI","Glucose","Insulin","HOMA","Leptin",
                  "Adiponectin","Resistin","MCP.1")

pred_new<-predict(svm_model,newdata=new_data)
as.character(pred_new)

result_text<-ifelse(as.character(pred_new) == "2", "Positive (Breast Cancer)", "Negative (Healthy)")

cat(
  "New patient diagnosis prediction:",
  result_text,
  "\n"
)


