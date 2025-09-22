# MATLAB Hackathon Project – AI-Powered Activity & Calorie Prediction

This project was developed for the [Aristotle Hackathon with AI](https://aristotle-hackathon.devpost.com/).  
Our goal was to **analyze physical activity data and build machine learning models in MATLAB** to predict calories burned, classify activity intensity, and count steps from raw sensor data collected via **MATLAB Mobile** app.

---

## 📌 Project Overview

We approached the problem in two stages:

1. **Calorie Prediction with Fitbit Data**
   - Used the `dailyActivity_merged.csv` dataset from [Fitbit Data Analysis](https://github.com/PriyalChotwani/Fitbit-DataAnalysis).
   - Implemented a **neural network** to predict the number of calories burned based on:
     - Step counts
     - Active minutes
     - Intensity levels (time spent in each activity level)
   - Evaluated model performance using **Mean Squared Error (MSE)**, **R-squared**, and **Range-Based Percentage Accuracy**.

   **Results:**
   - MSE (Test Set): `0.24852`
   - R-squared: `0.70103`
   - Range-Based Accuracy: `93.59%`

   👉 The model showed strong predictive performance, with steps and activity intensity being the most influential features for calorie estimation.

---

2. **Real-World Activity Data Collection & Classification**
   - Collected sensor data with **MATLAB Mobile** during walking and running activities.
   - Extracted features from:
     - **Acceleration magnitude**
     - **Gyroscope magnitude**
     - **GPS speed**
     - **Orientation data**
   - Labeled the data and trained classification models in MATLAB’s **Classification Learner**.
   - Tested models on separately collected test data.

   **Best Model:**
   - **Efficient Linear SVM (without PCA)**
   - Accuracy: `64.5%`

   👉 While not perfect, the classifier was able to distinguish exercise intensity levels using real-world signals.

---

3. **Step Counting**
   - Applied a **moving average filter** on acceleration data to reduce noise.
   - Detected peaks using MATLAB’s `findpeaks`, setting thresholds for peak height and minimum distance.
   - Counted steps as the number of detected peaks.

   👉 This approach provided a straightforward yet effective step-counting method from raw acceleration data.

---

4. **Integration**
   - Combined calorie prediction, activity classification, and step counting into a single pipeline (`main.m`).
   - The pipeline:
     1. Collects real-world sensor data from MATLAB Mobile
     2. Predicts exercise intensity
     3. Counts steps
     4. Estimates calories burned based on activity data

---

## 🔍 Observations
  - Calorie prediction was most successful, achieving ~94% accuracy on range-based evaluation.
  - Activity classification is more challenging due to noise and variability in real-world data, but the SVM achieved reasonable results at ~64.5%.
  - Step counting worked well with smoothing + peak detection, showing clear alignment between detected peaks and actual steps.
