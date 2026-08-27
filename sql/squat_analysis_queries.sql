/*Asymmetry Score*/
CREATE OR REPLACE VIEW asymmetry_analysis AS
SELECT
    person_id,
    condition,

    knee_rom_asymmetry,
    hip_rom_asymmetry,
    ankle_rom_asymmetry,

    ROUND(
        (
            (
                knee_rom_asymmetry +
                hip_rom_asymmetry +
                ankle_rom_asymmetry
            ) / 3.0
        )::numeric,
        2
    ) AS overall_rom_asymmetry

FROM squat_trials
ORDER BY overall_rom_asymmetry DESC;

SELECT *
FROM asymmetry_analysis;

/*Condition Summary*/
CREATE OR REPLACE VIEW condition_summary AS
SELECT
    condition,

    COUNT(*) AS total_trials,

    ROUND(AVG(knee_rom_asymmetry)::numeric, 2) AS avg_knee_rom_asymmetry,
    ROUND(AVG(hip_rom_asymmetry)::numeric, 2) AS avg_hip_rom_asymmetry,
    ROUND(AVG(ankle_rom_asymmetry)::numeric, 2) AS avg_ankle_rom_asymmetry,

    ROUND(AVG(knee_velocity_asymmetry)::numeric, 2) AS avg_knee_velocity_asymmetry,
    ROUND(AVG(hip_velocity_asymmetry)::numeric, 2) AS avg_hip_velocity_asymmetry,
    ROUND(AVG(ankle_velocity_asymmetry)::numeric, 2) AS avg_ankle_velocity_asymmetry,

    ROUND(AVG(trunk_rom)::numeric, 2) AS avg_trunk_rom

FROM squat_trials
GROUP BY condition;

SELECT *
FROM condition_summary;

/*Participant  Comparison*/
CREATE OR REPLACE VIEW participant_movement_analysis AS
SELECT
    person_id,
    condition,

    left_knee_rom,
    right_knee_rom,

    left_hip_rom,
    right_hip_rom,

    left_ankle_rom,
    right_ankle_rom,

    trunk_rom,

    knee_rom_asymmetry,
    hip_rom_asymmetry,
    ankle_rom_asymmetry,

    knee_velocity_asymmetry,
    hip_velocity_asymmetry,
    ankle_velocity_asymmetry,

    movement_duration

FROM squat_trials
ORDER BY person_id, condition;

SELECT *
FROM participant_movement_analysis;



SELECT *
FROM squat_trials
LIMIT 6;

SELECT COUNT(*) AS total_trials
FROM squat_trials;


SELECT
    condition,
    COUNT(*) AS number_of_trials
FROM squat_trials
GROUP BY condition;

SELECT
    person_id,
    COUNT(*) AS trials
FROM squat_trials
GROUP BY person_id
ORDER BY person_id;