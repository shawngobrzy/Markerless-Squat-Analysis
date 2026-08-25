# Markerless Squat Analysis

## Overview

This project uses computer vision and machine learning to analyze squat movement patterns from standard smartphone videos.

The goal is to build a pipeline that can extract human pose landmarks using a markerless pose estimation model, calculate biomechanical movement features, and classify squat trials as either **symmetrical** or **intentionally asymmetrical**.

The project combines computer vision, biomechanical feature engineering, data visualization, and machine learning to explore whether movement characteristics extracted from video can be used to identify differences in lower-body movement patterns.

The long-term motivation for this project is the potential application of markerless movement analysis to human performance, rehabilitation, injury recovery, and the identification of compensatory movement patterns.

> **Note:** This project is a proof of concept and is not intended for clinical diagnosis, injury diagnosis, or medical decision-making.

---

## Project Objectives

The primary objectives of this project are to:

1. Capture squat movement using standard smartphone video.
2. Extract body pose landmarks using MediaPipe.
3. Convert pose landmarks into biomechanically meaningful movement features.
4. Analyze joint angles and movement characteristics throughout the squat.
5. Measure left-right asymmetry between lower-body joints.
6. Calculate joint range of motion and angular velocity.
7. Classify squat trials as:
   - Symmetrical
   - Intentionally asymmetrical
8. Compare multiple machine learning models.
9. Identify which movement features contribute most to classification.

---

## Project Pipeline

The complete workflow is:

Smartphone Video
        │
        ▼
Video Ingestion
        │
        ▼
MediaPipe Pose Estimation
        │
        ▼
Pose Landmarks
        │
        ▼
Data Cleaning and Processing
        │
        ▼
Joint Angle Calculation
        │
        ├── Knee Angles
        ├── Hip Angles
        ├── Ankle Angles
        └── Trunk Angle
        │
        ▼
Feature Engineering
        │
        ├── Range of Motion
        ├── Peak Angular Velocity
        ├── Movement Duration
        └── Left-Right Asymmetry
        │
        ▼
Feature Dataset
        │
        ▼
Group-Aware Cross Validation
        │
        ├── Logistic Regression
        ├── Random Forest
        └── XGBoost
        │
        ▼
Model Interpretation
        │
        └── Feature Importance / SHAP

## Technologies Used

**Programming Language**
    Python
    Computer Vision
    OpenCV
    MediaPipe
**Data Analysis**
    Pandas
    NumPy
**Visualization**
    Matplotlib
**Machine Learning**
    Scikit-learn
    XGBoost

## Data Collection

Squat trials are recorded using a smartphone camera.

There are a total of 20 particapents and each participant performs two squat conditions:

1. Symmetrical squat
2. Intentionally asymmetrical squat

Videos are organized by participant.

data/
└── raw/
    ├── person_01/
    │   ├── symmetrical.mp4
    │   └── asymmetrical.mp4
    │
    ├── person_02/
    │   ├── symmetrical.mp4
    │   └── asymmetrical.mp4
    │
    └── ...

Each video represents one squat trial.

The dataset currently contains:

20 participants
40 squat trials
20 symmetrical trials
20 intentionally asymmetrical trials

## Markerless Pose Estimation

Pose landmarks are extracted from each video using MediaPipe.

The analysis focuses primarily on the following landmarks:

| Body Region | Landmarks                                                |
| ----------- | -------------------------------------------------------- |
| Upper Body  | Left Shoulder, Right Shoulder                            |
| Hips        | Left Hip, Right Hip                                      |
| Knees       | Left Knee, Right Knee                                    |
| Ankles      | Left Ankle, Right Ankle                                  |
| Feet        | Left Heel, Right Heel, Left Foot Index, Right Foot Index |

Each landmark includes positional information:

x
y
z
visibility

Pose information is extracted frame-by-frame and stored in a Pandas DataFrame.

## Biomechanical Features

The raw pose landmarks are transformed into movement features.

### Joint Angles

Joint angles are calculated using three-dimensional landmark coordinates.

The following angles are included:

#### Knee Angle

Hip → Knee → Ankle

#### Hip Angle

Shoulder → Hip → Knee

#### Ankle Angle

Knee → Ankle → Foot

#### Trunk Angle

The trunk angle is calculated using upper-body and hip landmarks to estimate changes in torso orientation throughout the squat.

### Feature Engineering

Each squat video is converted into a single feature vector.

The current dataset contains 23 numerical movement features.

#### Range of Motion

Range of motion is calculated for:

Left knee
Right knee
Left hip
Right hip
Left ankle
Right ankle
Trunk

Example features:

left_knee_rom
right_knee_rom

left_hip_rom
right_hip_rom

left_ankle_rom
right_ankle_rom

trunk_rom

#### Angular Velocity

Angular velocity is calculated from changes in joint angles over time.

Peak velocity features include:

left_knee_peak_velocity
right_knee_peak_velocity

left_hip_peak_velocity
right_hip_peak_velocity

left_ankle_peak_velocity
right_ankle_peak_velocity

peak_trunk_velocity

#### Left-Right Asymmetry

Asymmetry metrics are calculated to quantify differences between the left and right sides of the body.

Examples include:

knee_rom_asymmetry
hip_rom_asymmetry
ankle_rom_asymmetry

knee_velocity_asymmetry
hip_velocity_asymmetry
ankle_velocity_asymmetry

A general asymmetry calculation can be represented as:

**Asymmetry = |Left - Right| / Mean(Left, Right) × 100**

These features are intended to quantify differences in movement between the left and right sides during the squat.

## Dataset Structure

The final machine learning dataset contains one row per squat trial.

| person_id | condition    | left_knee_rom | right_knee_rom | knee_rom_asymmetry | ... |
| --------- | ------------ | ------------: | -------------: | -----------------: | --- |
| person_01 | symmetrical  |           ... |            ... |                ... |     |
| person_01 | asymmetrical |           ... |            ... |                ... |     |
| person_02 | symmetrical  |           ... |            ... |                ... |     |

Current dataset dimensions:

40 samples × 25 columns

The dataset includes:

person_id
condition
23 numerical movement features

## Machine Learning

The classification task is:

### Logistic Regression

Logistic Regression is used as a baseline model.

Because the features exist on different numerical scales, a StandardScaler is included inside a Scikit-learn pipeline.

StandardScaler
        ↓
Logistic Regression

### Random Forest

Random Forest is used as a nonlinear ensemble baseline.

This allows the project to evaluate whether nonlinear relationships between biomechanical features improve classification performance.

### XGBoost

XGBoost is used as the primary gradient-boosting model.

The model is configured conservatively due to the current small dataset size to reduce the risk of overfitting.

## Cross-Validation Strategy

A major consideration in this project is preventing participant-level data leakage.

Each participant contributes both a symmetrical and asymmetrical squat.

For example:

person_01
├── symmetrical
└── asymmetrical

Randomly splitting individual trials could allow the model to train on one movement trial from a participant and test on another trial from the same participant.

To reduce this risk, the project uses:

StratifiedGroupKFold

This approach:

Keeps data from the same participant within the same fold.
Attempts to preserve class balance across folds.
Evaluates the ability of the model to generalize to unseen participants.

The current configuration uses:
10-fold cross-validation

With 20 participants, each test fold contains approximately two unseen participants.

## Evaluation Metrics

Models are evaluated using:

Accuracy
Precision
Recall
F1 Score

The project reports both:

Mean Cross-Validation Score and Standard Deviation Across Folds

For example:

**Accuracy: 0.850 ± 0.120**

Due to the current small dataset size, model performance should be interpreted as preliminary.

## Model Interpretation

Feature importance analysis will be used to investigate which biomechanical features contribute most strongly to the classification of squat movement.

Planned interpretation methods include:

Random Forest feature importance
XGBoost feature importance
SHAP analysis

SHAP can help explain how individual movement features contribute to a model's prediction.

For example, SHAP analysis may help identify whether features such as:

knee_rom_asymmetry
hip_rom_asymmetry
ankle_rom_asymmetry

have a strong influence on the classification of a squat as symmetrical or asymmetrical.

## Future Improvements

Potential future improvements include:

### Larger Dataset

Increase the number of participants and squat trials to improve model generalizability.

### Multiple Camera Angles

Evaluate side-view and front-view recordings to capture different movement characteristics.

### Additional Exercises

Expand the framework to additional movements such as:

Lunges
Deadlifts
Step-ups
Walking or gait analysis

### More Advanced Biomechanical Features

Potential features include:

Knee valgus indicators
Hip-knee coordination
Inter-joint timing
Movement phase segmentation
Acceleration
Symmetry indices across different phases of the squat

### Time-Series Modeling

The current implementation converts each video into a fixed feature vector.

Future versions could analyze the complete movement sequence using:

Recurrent neural networks
Temporal convolutional networks
Transformer-based time-series models

### Real-Time Analysis

A future implementation could potentially process webcam or smartphone video in real time and provide movement feedback.

## Limitations

This project has several important limitations.

The dataset is currently small.
The asymmetrical movement condition is intentionally performed and does not represent clinical pathology.
MediaPipe pose estimation may contain landmark estimation errors.
Smartphone camera angle and positioning may influence measurements.
The calculated joint angles are estimates derived from markerless pose landmarks and are not equivalent to laboratory-grade motion capture measurements.
Model performance should be interpreted as proof-of-concept results rather than clinical validation.

## Ethical and Practical Considerations

This project is intended for educational and research purposes.

It should not be used to:

Diagnose injuries
Replace physical therapists or healthcare professionals
Make clinical decisions

Any future application involving rehabilitation or injury assessment would require substantially larger datasets, validation against established biomechanical measurement systems, and appropriate domain expertise.

## Repository Structure

markerless-squat-analysis/
│
|
├── data/
│   └── raw/
│       ├── person_01/
│       │   ├── symmetrical.mp4
│       │   └── asymmetrical.mp4
|
├── equations/
│   ├── angular_velocity_equation.png
|   ├── joint_angle_equation.png
│   └── ...
│
├── models/
│   └── pose_landmarker_full.task
|
├── notebooks/
│   └── markerless_squat_analysis.ipynb
|
├── questions/
│   └── function_purpose.png
|
├── requirements.txt
│
├── README.md
│
└── .gitignore

## Installation

Clone the repository:

git clone <https://github.com/shawngobrzy/Markerless-Squat-Analysis.git>

Install the required Python packages:

pip install pandas numpy matplotlib opencv-python mediapipe scikit-learn xgboost

These can also be installed from the requirements.txt by running the following command in a clean environment:

pip install -r requirements.txt

## Key Skills Demonstrated

This project demonstrates experience with:

Python
Computer Vision
Markerless Pose Estimation
OpenCV
MediaPipe
Data Processing
Feature Engineering
Biomechanical Data Analysis
Data Visualization
Machine Learning
Logistic Regression
Random Forest
XGBoost
Cross-Validation
Model Evaluation
Machine Learning

## Author

**Shawn Bryant**

Computer Science | Data Science | Computer Vision | Human Performance Analytics

## License

This project is currently intended for educational and portfolio purposes only.