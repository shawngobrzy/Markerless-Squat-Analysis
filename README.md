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