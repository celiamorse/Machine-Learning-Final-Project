# Machine-Learning-Final-Project

## Selected Models and Data

This project aims to analyze my personal health data gathered over the past six months from my WHOOP watch. This data includes various metrics such as heart rate variability, sleep requirements derived from sleep debt, duration of sleep, respiratory rate, REM sleep duration, energy expended, blood oxygen levels, skin temperature, and recovery score. The objective is to develop two models: a decision tree and a neural network. These models will utilize different combinations of metrics to predict my recovery score, which indicates how intensely I can exercise to meet my fitness goals. The accuracy of both models will be assessed and compared to determine their effectiveness in predicting my recovery score.


## Data Munging and Splitting

To transform my data, I began by categorizing the percentage of recovery scores into different bins, which I labeled as "recovery_category." This categorization is necessary to simplify the analysis of the data. By grouping scores into distinct categories like "low," "moderate," "above moderate," and "very good," it becomes easier to identify patterns in the recovery process.
After initially categorizing the recovery scores into four distinct categories, I observed a significant decrease in the model's accuracy. Recognizing this, I decided to streamline the categories into three: "low," "moderate," and "good." This adjustment notably enhanced the accuracy of the model. This improvement can be due to several factors. First, reducing the number of categories likely reduced the complexity of the model, making it easier to capture underlying patterns in the data. Second, by consolidating categories, we may have mitigated the effects of noise or variability within the dataset, allowing the model to focus on more meaningful distinctions between recovery levels.
Next, I curated a new dataset called "cycles," retaining only the essential variables from the original dataset. This step is crucial for avoiding overfitting, where the model learns noise from the data rather than true patterns. By selecting non-redundant variables, it is ensured that the model focuses on relevant features, improving its generalization performance on unseen data. I identified redundant variables in my Whoop data by intuition and recognizing similarities among certain variables, such as REM duration and deep sleep duration.


Finally, I standardized the variable names in the dataset by removing spaces and ' ' characters. This adjustment is necessary to address issues with the formula parameter in the neural net. Consistent and clean variable names enhance the efficiency of the modeling process, preventing potential errors.
The next step is to split my data into testing a training set. I took a custom function named "create_train_test" in R, which takes the dataset "cycles" and splits it into training and testing sets based on a specified size ratio, with the default set to 80% for training and 20% for testing. Utilizing the set.seed() function ensures reproducibility by fixing the random seed. Initially, I generated a shuffled index of the dataset using the sample() function to randomize the order of observations. Then, I rearrange the dataset according to this shuffled index to introduce randomness. Finally, I apply the "create_train_test" function twice, once for training data and once for testing data, passing in the shuffled dataset and the desired size ratio. Lastly, I omitted any missing values from the training and testing sets. This step prevents the occurrence of biases or inaccuracies in the models training.

## Decision Tree Summary

To model a decision tree, I utilized the rpart() function, to construct a decision tree model for predicting "Recovery_category '' based on the chosen predictor variables in the training dataset (data_train). The method = 'class' parameter signifies that we're dealing with a classification problem. Once the tree model (fit)
was trained, I visualized it using the rpart.plot() function, providing a visual representation of the decision-making process.

The trained model was then used to predict the "Recovery_category" for the unseen data in the testing dataset (data_test) using the predict() function with
type = 'class'. This produced a confusion matrix (table_mat) showcasing the predicted versus actual recovery categories.

The confusion matrix revealed promising results, with high counts along the diagonal indicating correct predictions. The accuracy of the model on the testing data was calculated by summing the diagonal elements of the confusion matrix and dividing by the total number of predictions, resulting in an accuracy of approximately 82.86%.

The achieved accuracy of 82.86% on the testing dataset suggests that the decision tree model demonstrates good predictive capability for categorizing recovery levels based on the given predictors.

## PCA

Although the accuracy of the decision tree was quite high, I decided to apply Principal Component Analysis (PCA) as a preprocessing step. PCA was applied to the cleaned dataset using the prcomp() function, with centering and scaling enabled (center = TRUE and scale = TRUE). The summary() function provided insights into the variance explained by each principal component, while print(pca$rotation) displayed the principal component loadings, indicating the direction and strength of the original variables.
The fviz_eig() function generated a scree plot illustrating the proportion of variance explained by each principal component, which helps to determine the
number of components to retain. From the scree plot, it was evident that the first 4 or 5 principal components captured a significant portion of the variance.

I combined the first 5 principal components with the original "Recovery_category" variable, creating a new dataset named components. This dataset was split into training and testing sets using sample.split() from the caTools package.
A decision tree model was trained on the training dataset (train) using the rpart() function, specifying "class" as the method for classification. The resulting tree model (fit) was visualized with rpart.plot().
The model was then used to predict the "Recovery_category" for the testing dataset (test), and the predictions were compared with the actual values to generate a confusion matrix (table_mat). The accuracy of the model on the testing data was calculated to be approximately 68.18%.
While PCA was used in an attempt to improve model performance, the accuracy suggests that the decision tree model with PCA-transformed features did not outperform the previous model without PCA. This outcome highlights the importance of evaluation when applying preprocessing techniques like PCA to machine learning models.

Neural Net Summary
In this code snippet, I first standardized the numeric variables in the training dataset (data_train) using the scale() function. Then, I combined the scaled numeric data with the non-numeric variables, ensuring all data was prepared for.
Moving forward, I utilized the neuralnet() function from the neuralnet package to construct a neural network model for predicting the "Recovery_category" based on the features in the cleaned training dataset (clean_train). I specified a neural network architecture with 3 hidden layers, containing 5, 4, and 3 neurons, respectively, and set linear.output = FALSE to indicate that the output should be nonlinear.
After training the neural network model (nn), I visualized its structure using the plot() function.

For prediction on the testing dataset (data_test), I used the trained neural network model to generate predictions (pred). I then transformed these predictions into corresponding category labels ("very good," "moderate recovery," and "low") and compared them with the actual "Recovery_category" labels to construct a confusion matrix. This matrix indicated how well the model's predictions aligned with the true categories.

The accuracy of the neural network model on the testing data was calculated to be approximately 60.6%, suggesting moderate predictive performance. This indicates that the neural network model successfully captured certain patterns in the data, though there is room for improvement. Further optimization of the neural network architecture and hyperparameters may lead to enhanced performance.

In the pursuit of optimizing the neural network architecture for predicting recovery categories, I encountered challenges implementing grid search due to its computational demands. Consequently, I resorted to a trial-and-error approach, exploring various architectures until achieving the highest accuracy.



