library(dplyr)
library(readr)
library(writexl)

# Preparing (cleaning/pre-processing) the diabetes data and split into training, validation, test sets
source("functions/preprocessDiabetesData.R")
source("functions/loadDiabetesData.R")  # 确保已经加载 loadDiabetesData 函数

# 加载数据集（使用 loadDiabetesData 直接加载并存储数据）
diabetes_data <- loadDiabetesData(path = "../data/samadult.csv", output_path = "../data/samadult_final.xlsx")

# split into training, validation, and testing
set.seed(24648765)
diabetes_data <- diabetes_data %>%
  mutate(id = 1:n())

# split into training, testing, and validation
diabetes_train <- diabetes_data %>% sample_frac(0.6) 
diabetes_test <- diabetes_data %>% filter(!(id %in% diabetes_train$id)) %>%
  sample_frac(0.5) 
diabetes_val <- diabetes_data %>% 
  filter(!(id %in% diabetes_train$id) & !(id %in% diabetes_test$id)) 

# clean each dataset
diabetes_train_preprocessed <- preprocessDiabetesData(diabetes_train)

# create version of training data without dummy variables
diabetes_train_preprocessed_nodummy <- preprocessDiabetesData(diabetes_train)

# extract training levels for categorical variables
diabetes_levels <- list(
  sex_levels = levels(diabetes_train_preprocessed_nodummy$sex),
  smoker_levels = levels(diabetes_train_preprocessed_nodummy$smoker),
  coronary_heart_disease_levels = levels(diabetes_train_preprocessed_nodummy$coronary_heart_disease),
  hypertension_levels = levels(diabetes_train_preprocessed_nodummy$hypertension),
  heart_condition_levels = levels(diabetes_train_preprocessed_nodummy$heart_condition),
  cancer_levels = levels(diabetes_train_preprocessed_nodummy$cancer),
  family_history_diabetes_levels = levels(diabetes_train_preprocessed_nodummy$family_history_diabetes)
)

# preprocess val data
diabetes_val_preprocessed <- preprocessDiabetesData(diabetes_val)

# preprocess test data
diabetes_test_preprocessed <- preprocessDiabetesData(diabetes_test)

# 保存为 CSV 格式
write_csv(diabetes_train_preprocessed, "../data/train_val_test/diabetes_train_preprocessed.csv")
write_csv(diabetes_val_preprocessed, "../data/train_val_test/diabetes_val_preprocessed.csv")
write_csv(diabetes_test_preprocessed, "../data/train_val_test/diabetes_test_preprocessed.csv")

# 保存为 Excel 格式
write_xlsx(list(
  train = diabetes_train_preprocessed,
  val = diabetes_val_preprocessed,
  test = diabetes_test_preprocessed
), path = "../data/train_val_test/diabetes_preprocessed.xlsx")
