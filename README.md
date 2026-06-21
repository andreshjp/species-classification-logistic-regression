# Species Classification with Logistic Regression

> Binary classification project using the Palmer Penguins dataset to predict whether a penguin belongs to the Adelie species. The project systematically evaluates multiple logistic regression specifications — including stepwise feature reduction, interaction terms, Firth regression for separation, and LASSO regularization — to identify the most parsimonious model with the best trade-off between complexity and predictive performance.

---

## Overview

The goal is to build a binary classifier for **Adelie vs. non-Adelie** penguin species using physical and geographic measurements. The project goes beyond fitting a single model: it iterates across 9 model specifications, each motivated by a substantive hypothesis about feature relevance, then applies bias correction and regularization techniques to address quasi-perfect separation — a statistical phenomenon where a predictor perfectly predicts the outcome in the training set, destabilizing standard MLE estimates.

---

## Dataset

[Palmer Penguins](https://allisonhorst.github.io/palmerpenguins/) — 344 observations of three penguin species (Adelie, Chinstrap, Gentoo) from three islands in the Palmer Archipelago, Antarctica. Features include bill length, bill depth, flipper length, body mass, sex, and island.

After removing rows with missing values: **333 complete observations**. The binary target is `Adelie (yes) vs. non-Adelie (no)`.

---

## Methodology

### Train/Test Split
70/30 stratified split (`set.seed(42)`) using `rsample::initial_split`.

### Model Specifications Evaluated

| Model | Predictors | Rationale |
|-------|-----------|-----------|
| Full model | All 6 features + island | Baseline |
| Drop island | Physical + sex | Island may act as a proxy for species (data leakage concern) |
| Drop island + bill depth | bill_length + flipper + body_mass + sex | Feature selection |
| Drop island + bill depth + sex | bill_length + flipper + body_mass | Parsimony |
| Drop island + bill depth + sex + flipper | bill_length + body_mass | Minimal model |
| bill_length + sex | Best 2-feature model | Motivated by EDA |
| bill_length + flipper_length | Morphological-only | No behavioral variable |
| bill_length + sex + interaction | Interaction model | Sex modulates bill length effect |

### Addressing Quasi-Perfect Separation
The best-performing 2-feature model (`bill_length + sex`) exhibited quasi-perfect separation — the sex variable nearly perfectly predicted species membership in the training sample. Two bias-corrected estimation methods were applied and compared:

- **Firth logistic regression** (`logistf`) — penalized likelihood approach that shrinks coefficients toward zero, resolving the Hauck-Donner effect
- **LASSO regularization** (`cv.glmnet`) — cross-validated L1 penalty
- **LASSO initialized with Firth coefficients** — hybrid approach combining both corrections

### Evaluation Metrics
Confusion matrix (via `caret`), ROC curve, AUC (`pROC`), odds ratios with 95% CIs.

---

## Key Results

- The `bill_length + sex` specification achieved the best trade-off between interpretability and discrimination.
- Firth regression, standard LASSO, and the hybrid approach produced substantively consistent odds ratios, confirming that both methods converge to similar estimates under separation.
- **Bill length** is the strongest morphological predictor: longer bills are associated with substantially higher odds of being Adelie.
- The sex interaction term did not meaningfully improve discrimination, suggesting the effect of bill length on species membership is approximately constant across sexes.

---

## Tech Stack

| Package | Role |
|---------|------|
| `caret` | Model training and confusion matrix |
| `rsample` | Stratified train/test split |
| `pROC` | ROC curves and AUC |
| `logistf` | Firth penalized logistic regression |
| `glmnet` | LASSO regularization |
| `ggplot2` | Visualization |
| `palmerpenguins` | Dataset |

---

## Project Structure

```
species-classification-logistic-regression/
├── analysis.R          # Full modeling script (9 specifications + diagnostics)
└── penguins_size.csv   # Dataset export
```

---

## How to Run

```r
install.packages(c("palmerpenguins", "dplyr", "ggplot2", "caret", "rsample",
                   "pROC", "logistf", "glmnet"))

source("analysis.R")
```

---

## Skills Demonstrated

`Binary Classification` · `Logistic Regression` · `Feature Selection` · `Regularization (LASSO)` · `Firth Regression` · `ROC / AUC` · `Quasi-Separation Diagnostics` · `Statistical Modeling` · `R` · `caret` · `pROC`
