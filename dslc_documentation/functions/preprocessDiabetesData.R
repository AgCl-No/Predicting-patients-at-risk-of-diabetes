# Cleaning/pre-processing the diabetes data
source("functions/loadDiabetesData.R")

preprocessDiabetesData <- function(data = NULL) {
  # 检查是否提供了数据集
  if (is.null(data)) {
    stop("Please provide a dataset.")
  }
  
  # 删除异常数据
  data <- data %>%
    filter(
      !(age == 85),  # 删除年龄为85的记录
      smoker %in% c(1, 2),  # 保留smoker为1或2的记录
      sex %in% c(1, 2),
      weight <= 299,  # 保留weight小于等于299的记录
      bmi <= 9994,  # 保留bmi小于等于9994的记录
      height <= 76  # 保留height小于等于76的记录
    )
  
  # 转换categorical变量（比如smoker和sex列的0/1转换）
  data <- data %>%
    mutate(
      smoker = ifelse(smoker == 2, 0, smoker),  # 将smoker中的2换成0
      sex = ifelse(sex == 1, 0, ifelse(sex == 2, 1, sex))  # 将sex中的1换成0，2换成1
    )
  
  # 将变量类型进行转换
  data <- data %>%
    mutate(
      age = as.numeric(age),
      weight = as.numeric(weight),
      height = as.numeric(height),
      bmi = as.numeric(bmi),
      smoker = as.factor(smoker),
      sex = as.factor(sex),
      coronary_heart_disease = as.factor(coronary_heart_disease),
      hypertension = as.factor(hypertension),
      heart_condition = as.factor(heart_condition),
      cancer = as.factor(cancer),
      family_history_diabetes = as.factor(family_history_diabetes),
      diabetes = as.factor(diabetes)
    )
  
  # 对numeric variables进行标准化处理
  numeric_columns <- c("age", "weight", "height", "bmi")
  
  data[numeric_columns] <- data[numeric_columns] %>%
    scale() %>%
    as.data.frame()  # 对age, weight, height, bmi进行标准化处理
  
  # 返回处理后的数据
  return(data)
}




