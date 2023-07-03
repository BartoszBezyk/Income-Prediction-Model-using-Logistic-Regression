# Income-Prediction-Model-using-Logistic-Regression

The aim of this project was to develop a logistic regression model that could predict a person's income based on the available data. Various data transformations were performed, such as changing data types, handling missing values, and reducing the number of entries in certain columns.

Next, the data was split into training and testing sets in different proportions, and a logistic regression model was built using the glm function. Additionally, the step function was used to refine the model through variable selection.

The model was tested on the test set, and the results were evaluated using various metrics including confusion matrix, ROC curve, AUC, Gini coefficient, and F1-score.

Upon analysis, it was found that the obtained model has a lower F1-score compared to the previous model. This indicates that the developed model may have lower balanced accuracy in classification.

In summary, although the logistic regression model was built and tested on the available data, there is still room for improvement in its performance through further fine-tuning, selecting relevant variables, or applying other modeling techniques.

The data I have used are avaliable [here](https://www.kaggle.com/datasets/wenruliu/adult-income-dataset)
