# Breast Cancer Diagnosis Classification in R

An end-to-end machine learning classification pipeline built in R using the **UCI Breast Cancer Coimbra** dataset. This project predicts breast cancer diagnosis based on 9 clinical biomarkers (Age, BMI, Glucose, Insulin, HOMA, Leptin, Adiponectin, Resistin, and MCP-1) and evaluates five supervised learning algorithms.

## Project Workflow
1. **Data Preprocessing:** Handled missing values using Predictive Mean Matching (`mice` package).
2. **Train-Test Split:** Partitioned the dataset into 80% training and 20% testing subsets.
3. **Model Training & Tuning:** Trained Decision Tree (CART), Random Forest, K-Nearest Neighbors (with 5-fold cross-validation), Naive Bayes, and Support Vector Machine (Radial Kernel).
4. **Model Evaluation:** Compared models across Accuracy, Sensitivity, Specificity, and Precision.
5. **Inference:** Implemented a prediction pipeline to classify new patient clinical profiles using the top-performing SVM model.

## Model Performance Comparison

| Model | Accuracy | Sensitivity | Specificity | Precision |
| :--- | :---: | :---: | :---: | :---: |
| **Random Forest** | **0.870** | 0.846 | **0.900** | **0.917** |
| **SVM (Radial)** | **0.870** | 0.846 | **0.900** | **0.917** |
| **Decision Tree** | 0.826 | 0.846 | 0.800 | 0.846 |
| **Naive Bayes** | 0.609 | **0.923** | 0.200 | 0.600 |
| **KNN (5-Fold CV)** | 0.522 | 0.231 | 0.900 | 0.750 |

### Key Findings
* **Random Forest** and **SVM** achieved the highest overall performance (**87.0% accuracy** and **91.7% precision**), demonstrating strong generalization on non-linear clinical biomarker relationships.
* **KNN** showed lower accuracy (**52.2%**) due to unscaled feature magnitudes (e.g., `MCP-1` ranging in hundreds/thousands vs. `HOMA` in single digits), highlighting the sensitivity of distance-based algorithms to feature scaling.

## Technologies & Libraries Used
* **Language:** R
* **Libraries:** `mice`, `caret`, `rpart`, `rpart.plot`, `dplyr`, `randomForest`, `e1071`, `class`
