-- https://school.programmers.co.kr/learn/courses/30/lessons/151141

WITH TRUCK_DISCOUNT AS (
    SELECT  CASE 
                WHEN DURATION_TYPE = '7일 이상'    THEN 7
                WHEN DURATION_TYPE = '30일 이상'   THEN 30
                WHEN DURATION_TYPE = '90일 이상'   THEN 90
            END
            AS DURATION_START
           ,CASE 
                WHEN DURATION_TYPE = '7일 이상'    THEN 30
                WHEN DURATION_TYPE = '30일 이상'   THEN 90
                WHEN DURATION_TYPE = '90일 이상'   THEN 999999
            END
            AS DURATION_END
           ,DISCOUNT_RATE
    FROM    CAR_RENTAL_COMPANY_DISCOUNT_PLAN
    WHERE   CAR_TYPE = '트럭'
    UNION
    SELECT  0 AS DURATION_START
           ,7 AS DURATION_START
           ,0 AS DISCOUNT_RATE
    FROM    DUAL
), TRUCK_HIST AS (
    SELECT  HIST.HISTORY_ID
           ,CAR.CAR_ID
           ,TRUNC(HIST.END_DATE)-TRUNC(HIST.START_DATE)+1 AS DAYS
           ,CAR.DAILY_FEE
    FROM    CAR_RENTAL_COMPANY_CAR CAR
    JOIN    CAR_RENTAL_COMPANY_RENTAL_HISTORY HIST
    ON      CAR.CAR_ID = HIST.CAR_ID
    WHERE   CAR_TYPE = '트럭'
)

SELECT  HIST.HISTORY_ID
       ,(100-DISC.DISCOUNT_RATE)*HIST.DAILY_FEE*HIST.DAYS/100 AS FEE
FROM    TRUCK_HIST HIST
JOIN    TRUCK_DISCOUNT DISC
ON      HIST.DAYS BETWEEN DISC.DURATION_START AND DISC.DURATION_END
ORDER BY
        FEE DESC, 
        HISTORY_ID DESC
;
