# ============================================================
# species-classification-logistic-regression
# Author: Andrés Jiménez | github.com/andreshjp
# ============================================================

required <- c("palmerpenguins","dplyr","ggplot2","caret","rsample",
              "pROC","Metrics","MLmetrics","DescTools","nnet","yardstick","janitor")
miss <- required[!(required %in% installed.packages()[,"Package"])]
if(length(miss)) install.packages(miss, dependencies = TRUE)
suppressPackageStartupMessages(lapply(required, library, character.only = TRUE))
set.seed(42)

# -----------------------------------------------------------------------
# 1. CARGA Y LIMPIEZA
data("penguins", package="palmerpenguins")
peng <- penguins %>% na.omit() %>% select(-year)
message("Observaciones completas: ", nrow(peng))

# -----------------------------------------------------------------------
# 2. SECCIÓN BINARIA  (Adelie vs. resto)
message("\n========== BINARIA ==========")
peng_bin <- peng %>% mutate(target = factor(ifelse(species=="Adelie","yes","no"),
                                            levels=c("no","yes"))) %>% select(-species)
set.seed(42)
split_b <- initial_split(peng_bin, 0.7, strata=target)
train_b <- training(split_b); test_b <- testing(split_b)

form_b <- target ~ bill_length_mm + bill_depth_mm + flipper_length_mm +
  body_mass_g + sex + island

mod_b <- glm(form_b, data=train_b, family=binomial)
summary(mod_b)

# Odds ratios
or_b <- exp(coef(mod_b))
or_tbl_b <- data.frame(Variable=names(or_b), OddsRatio=round(or_b,3))
or_tbl_b

# Predicciones
prob_b <- predict(mod_b, test_b, type="response")
pred_b <- factor(ifelse(prob_b>=0.5,"yes","no"), levels=c("no","yes"))

cm_b <- caret::confusionMatrix(pred_b, test_b$target, positive="yes")
print(cm_b)

# -----------------------------------------------------------------------
# 3. MODELO SIN VARIABLE ISLA 

form_pa <- target ~ bill_length_mm + bill_depth_mm + flipper_length_mm +
  body_mass_g + sex 

mod_pa <- glm(form_pa, data=train_p, family=binomial)

summary(mod_pa)

# Odds ratios
or_pa <- exp(coef(mod_pa))
or_tbl_pa <- data.frame(Variable=names(or_pa), OddsRatio=round(or_pa,3))
or_tbl_pa

# Predicciones
prob_pa <- predict(mod_pa, test_p, type="response")
pred_pa <- factor(ifelse(prob_pa>=0.5,"yes","no"), levels=c("no","yes"))

cm_pa <- caret::confusionMatrix(pred_pa, test_p$target, positive="yes")
print(cm_pa)

# Curva ROC 
library(pROC)
roc_curve <- roc(test_p$target, prob_pa)
plot(roc_curve)




# -----------------------------------------------------------------------
# 4. MODELO SIN VARIABLES ISLA NI BILL BEPTH 

form_pb <- target ~ bill_length_mm + flipper_length_mm +
  body_mass_g + sex 

mod_pb <- glm(form_pb, data=train_p, family=binomial)

summary(mod_pb)

# Odds ratios
or_pb <- exp(coef(mod_pb))
or_tbl_pb <- data.frame(Variable=names(or_pb), OddsRatio=round(or_pb,3))
or_tbl_pb

# Predicciones
prob_pb <- predict(mod_pb, test_p, type="response")
pred_pb <- factor(ifelse(prob_pb>=0.5,"yes","no"), levels=c("no","yes"))

cm_pb <- caret::confusionMatrix(pred_pb, test_p$target, positive="yes")
print(cm_pb)

# Curva ROC 
library(pROC)
roc_curve <- roc(test_p$target, prob_pb)
plot(roc_curve)


# -----------------------------------------------------------------------
# 5. MODELO SIN VARIABLE ISLA NI NI BILL DEPTH NI SEX 

form_pc <- target ~ bill_length_mm + flipper_length_mm +
  body_mass_g 

mod_pc <- glm(form_pc, data=train_p, family=binomial)

summary(mod_pc)

# Odds ratios
or_pc <- exp(coef(mod_pc))
or_tbl_pc <- data.frame(Variable=names(or_pc), OddsRatio=round(or_pc,3))
or_tbl_pc

# Predicciones
prob_pc <- predict(mod_pc, test_p, type="response")
pred_pc <- factor(ifelse(prob_pb>=0.5,"yes","no"), levels=c("no","yes"))

cm_pc <- caret::confusionMatrix(pred_pc, test_p$target, positive="yes")
print(cm_pc)

# Curva ROC
library(pROC)
roc_curve <- roc(test_p$target, prob_pc)
plot(roc_curve)


# -----------------------------------------------------------------------
# 6. MODELO SIN VARIABLE ISLA NI BILL BEPTH NI SEX NI FLIPPER LENGHT 

form_pd <- target ~ bill_length_mm +
  body_mass_g 

mod_pd <- glm(form_pd, data=train_p, family=binomial)

summary(mod_pd)

# Odds ratios
or_pd <- exp(coef(mod_pd))
or_tbl_pd <- data.frame(Variable=names(or_pd), OddsRatio=round(or_pd,3))
or_tbl_pd

# Predicciones
prob_pd <- predict(mod_pd, test_p, type="response")
pred_pd <- factor(ifelse(prob_pd>=0.5,"yes","no"), levels=c("no","yes"))

cm_pd <- caret::confusionMatrix(pred_pd, test_p$target, positive="yes")
print(cm_pd)

# Curva ROC
library(pROC)
roc_curve <- roc(test_p$target, prob_pd)
plot(roc_curve)


# -----------------------------------------------------------------------
# 7. MODELO SOLO CON BILL DPETH Y SEX 

form_pe <- target ~ bill_length_mm + sex

mod_pe <- glm(form_pe, data=train_p, family=binomial)

summary(mod_pe)

# Odds ratios
or_pe <- exp(coef(mod_pe))
or_tbl_pe <- data.frame(Variable=names(or_pe), OddsRatio=round(or_pe,3))
or_tbl_pe

# Predicciones
prob_pe <- predict(mod_pe, test_p, type="response")
pred_pe <- factor(ifelse(prob_pe>=0.5,"yes","no"), levels=c("no","yes"))

cm_pe <- caret::confusionMatrix(pred_pe, test_p$target, positive="yes")
print(cm_pe)

# Curva ROC 
library(pROC)
roc_curve <- roc(test_p$target, prob_pe)
plot(roc_curve)

#Gráficos explicativos de sexo y aleta
# Gráfico de dispersión por sexo
library(ggplot2)
ggplot(train_p, aes(bill_length_mm, fill = target)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~sex, ncol = 1) +
  labs(title = "Distribución de bill_length por Sexo y Especie",
       x = "Longitud del pico (mm)", y = "Densidad")


ggplot(train_p, aes(bill_length_mm, as.numeric(target == "yes"), color = sex)) +
  geom_jitter(height = 0.05) + 
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE) +
  labs(y = "Probabilidad de ser Adelie", 
       title = "Relación no-lineal entre variables")


# -----------------------------------------------------------------------
# 8. MODELO SOLO CON BILL DPETH Y FLIPPER LENGTH 

form_pf <- target ~ bill_length_mm + flipper_length_mm

mod_pf <- glm(form_pf, data=train_p, family=binomial)

summary(mod_pf)

# Odds ratios
or_pf <- exp(coef(mod_pf))
or_tbl_pf <- data.frame(Variable=names(or_pf), OddsRatio=round(or_pf,3))
or_tbl_pf

# Predicciones
prob_pf <- predict(mod_pf, test_p, type="response")
pred_pf <- factor(ifelse(prob_pf>=0.5,"yes","no"), levels=c("no","yes"))

cm_pf <- caret::confusionMatrix(pred_pf, test_p$target, positive="yes")
print(cm_pf)

# Curva ROC 
library(pROC)
roc_curve <- roc(test_p$target, prob_pf)
plot(roc_curve)



# -----------------------------------------------------------------------
# 9. MODELO SOLO CON BILL DPETH, SEX E INTERACCIÓN 

form_pg <- target ~ bill_length_mm + sex + bill_length_mm*sex

mod_pg <- glm(form_pg, data=train_p, family=binomial)

summary(mod_pg)

# Odds ratios
or_pg <- exp(coef(mod_pg))
or_tbl_pg <- data.frame(Variable=names(or_pg), OddsRatio=round(or_pg,3))
or_tbl_pg

# Predicciones
prob_pg <- predict(mod_pg, test_p, type="response")
pred_pg <- factor(ifelse(prob_pg>=0.5,"yes","no"), levels=c("no","yes"))

cm_pg <- caret::confusionMatrix(pred_pg, test_p$target, positive="yes")
print(cm_pg)

# Curva ROC 
library(pROC)
roc_curve <- roc(test_p$target, prob_pg)
plot(roc_curve)

# -----------------------------------------------------------------------
# 10.VERIFICACIONES DEL MEJOR MODELO (PE)
# VERIFICAR SEPARACIÓN PERFECTA

contingency_table <- table(train_p$sex, train_p$target)
prop_table <- prop.table(contingency_table, margin = 2) 

list(
  Conteo = contingency_table,
  Proporciones = round(prop_table, 3)
)


# Ahora haremos una regresión firth
library(logistf)
modpe_firth <- logistf(target ~ bill_length_mm + sex, 
                     data = train_p)
summary(modpe_firth)


#Ahora probaremos con una regularización Lasso
library(glmnet)
x <- model.matrix(target ~ bill_length_mm + sex, train_p)[,-1]
y <- train_p$target == "yes"

cv_lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
coef(cv_lasso, s = "lambda.1se") %>% exp()

# Finalmente ajustar LASSO sobre los coeficientes Firth
x_firth <- model.matrix(~ bill_length_mm + sex, train_p)
y_firth <- as.numeric(train_p$target == "yes")

# Usar los coeficientes Firth como valores iniciales
init_coef <- coef(modpe_firth)

cv_lasso_firth <- cv.glmnet(x_firth, y_firth, 
                            alpha = 1,
                            family = "binomial",
                            penalty.factor = c(0, 1, 1), # No penalizar intercept
                            lambda.start = init_coef)

coef(cv_lasso_firth, s = "lambda.min") %>% exp()


# Comparar resultados
list(
  Firth = exp(coef(modpe_firth)),
  LASSO = exp(coef(cv_lasso, s = "lambda.1se")),
  LASSO_Firth = exp(coef(cv_lasso_firth, s = "lambda.min"))
)

# Gráfico comparativo (excluyendo interceptos para mejor visualización)
results %>%
  filter(Variable != "Intercept") %>%
  ggplot(aes(x = Method, y = OR, fill = Variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_log10() +
  labs(title = "Comparación de Odds Ratios por Método",
       subtitle = "Escala logarítmica para comparación",
       y = "Odds Ratio (log scale)") +
  theme_minimal()



