install.packages("writexl")
library(writexl)

# 定义加载糖尿病数据的函数
loadDiabetesData <- function(path = "../data/samadult.csv", output_path = "../data/samadult_final.xlsx") {
  
  # 加载数据
  diabetes_orig <- read_csv(path)
  
  # 处理数据
  set.seed(24648765)
  diabetes <- diabetes_orig %>%
    group_by(HHX) %>%
    sample_n(1) %>%
    mutate(id = 1:n()) %>%
    ungroup() %>%
    transmute(house_family_person_id = paste(HHX, FMX, FPX, sep = "_"),
              diabetes = as.numeric(DIBEV1 == 1),
              age = AGE_P,
              smoker = SMKEV,
              sex = SEX,
              coronary_heart_disease = as.numeric(CHDEV == 1),
              weight = AWEIGHTP,
              bmi = BMI,
              height = AHEIGHT,
              hypertension = as.numeric(HYPEV == 1),
              heart_condition = as.numeric(HRTEV == 1),
              cancer = as.numeric(CANEV == 1),
              family_history_diabetes = as.numeric(DIBREL == 1))
  
  # 保存为 Excel 文件
  write_xlsx(diabetes, output_path)
  
  return(diabetes)  
}

