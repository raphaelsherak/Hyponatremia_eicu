#####SQL queries

###hyponatremia
SELECT patientunitstayid, chartoffset, sodium
FROM `physionet-data.eicu_crd_derived.pivoted_lab`
WHERE  `physionet-data.eicu_crd_derived.pivoted_lab`.patientunitstayid 
IN  (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120) AND sodium IS NOT NULL AND chartoffset >= -240 
ORDER BY patientunitstayid

####id, ages, apacheadmindx, gender, mortality, icu_los
SELECT * 
        FROM `physionet-data.eicu_crd_derived.basic_demographics`
WHERE `physionet-data.eicu_crd_derived.basic_demographics`.patientunitstayid 
IN  (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)
AND age IS NOT NULL AND gender is NOT NULL


#####labresults
##BUN
WITH all_BUN AS(
        SELECT patientunitstayid, labresultoffset, labname, labresult
        , row_number() OVER(PARTITION BY patientunitstayid ORDER BY labresultoffset) AS rn
        FROM   `physionet-data.eicu_crd.lab`
        WHERE labname = "BUN" )

SELECT * 
FROM all_BUN
WHERE rn = 1 
AND patientunitstayid  
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##glucose(2527)
WITH all_gluc AS(
        SELECT patientunitstayid, labresultoffset, labname, labresult
        , row_number() OVER(PARTITION BY patientunitstayid ORDER BY labresultoffset) AS rn
        FROM   `physionet-data.eicu_crd.lab`
        WHERE labname = "glucose" )

SELECT * 
        FROM all_gluc
WHERE rn = 1 
AND patientunitstayid  
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##apache score(2101)
SELECT DISTINCT patientunitstayid, apachescore
FROM `physionet-data.eicu_crd.apachepatientresult`
WHERE patientunitstayid  
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)


##apache table(2377)
SELECT patientunitstayid, vent, dialysis, eyes+motor+verbal as GCS
FROM `physionet-data.eicu_crd.apacheapsvar`
WHERE eyes IS NOT NULL AND motor IS NOT NULL AND verbal IS NOT NULL AND dialysis = 0 
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

###seizure
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%345%" AND activeupondischarge = true
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

###alteration consciousness(0)

###coma(6)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%780.01%" AND activeupondischarge = true
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

###transient(0)
###Persistent vegetative state (780.03)(0)

##Other coma (780.09)(282)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%780.09%" AND activeupondischarge = true
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##hemiplegia and hemiparesis (342)(1)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%342%" AND activeupondischarge = true
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##Other paralytic syndromes (344)(7)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%344%" AND activeupondischarge = true
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

###Heart Failure: 428(250)
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%428%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##Chronic liver disease and cirrhosis: 571(98)
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%571%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##Acute renal failure: 584 (447)
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%584%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)


##(Potentially includes 586 Renal failure, unspecified)(14)
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%586%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##Sepsis: 995.91, 995.92 (Not 995.90, 995.93, 995.94) (449)
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%995.91%" OR icd9code LIKE "%995.92%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##Diabetes mellitus: 250 (250)
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%250%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

###CKD
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%585.1%" 
        OR icd9code LIKE "%585.2%" 
        OR icd9code LIKE "%585.3%" 
        OR icd9code LIKE "%585.4%" 
        OR icd9code LIKE "%585.9%" 
        OR icd9code LIKE "%403%" 
        OR icd9code LIKE "%404%")
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))


##bipolar
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%296.0%"   
        OR icd9code LIKE "%296.1%" 
        OR icd9code LIKE "%296.4%" 
        OR icd9code LIKE "%296.5%" 
        OR icd9code LIKE "%296.6%" 
        OR icd9code LIKE "%296.7%" 
        OR icd9code LIKE "%296.8%")
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))

###schizophrenia
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%295%" )
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))

##stroke

SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%430%" 
        OR icd9code LIKE "%431%" 
        OR icd9code LIKE "%434%")
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))

##HIV
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%042%" )
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))

##COPD
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%491%" )
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))

##hypertension
SELECT distinct patientunitstayid
FROM `physionet-data.eicu_crd.diagnosis`
WHERE (icd9code LIKE "%401%"
        OR icd9code LIKE "%402%" 
        OR icd9code LIKE "%403%"
        OR icd9code LIKE "%404%" 
        OR icd9code LIKE "%405%")
AND diagnosisoffset <= 720
AND (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))

###discharge location
SELECT distinct patientunitstayid, unitdischargelocation
FROM `physionet-data.eicu_crd.patient`
WHERE (patientunitstayid 
        IN (SELECT distinct patientunitstayid
                FROM `physionet-data.eicu_crd_derived.pivoted_lab`
                WHERE sodium > 99
                AND sodium <= 120))


###baseline seizure
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%345%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

###baseline coma
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%780.01%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##baseline other coma (780.09)(282)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%780.09%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##baseline hemiplegia and hemiparesis (342)(1)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%342%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##baseline other paralytic syndromes (344)(7)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%344%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
        FROM `physionet-data.eicu_crd_derived.pivoted_lab`
        WHERE sodium > 99
        AND sodium <= 120)

##Admission diagnosis
SELECT patientunitstayid, admitDxPath, admitDxName, admitDxText
FROM `physionet-data.eicu_crd.admissiondx`
WHERE patientunitstayid  
IN (SELECT distinct patientunitstayid
    FROM `physionet-data.eicu_crd_derived.pivoted_lab`
    WHERE sodium > 99
    AND sodium <= 120)

##PastHistory
SELECT patientunitstayid, pasthistoryvalue
FROM `physionet-data.eicu_crd.pasthistory`
WHERE (patientunitstayid
       IN (SELECT distinct patientunitstayid
           FROM `physionet-data.eicu_crd_derived.pivoted_lab`
           WHERE sodium > 99
           AND sodium <= 120))


##baseline other paralytic syndromes (341)(8)
SELECT patientunitstayid, activeupondischarge, diagnosisstring, icd9code 
FROM `physionet-data.eicu_crd.diagnosis`
WHERE icd9code LIKE "%341%" 
AND diagnosisoffset <= 720
AND patientunitstayid 
IN (SELECT distinct patientunitstayid
    FROM `physionet-data.eicu_crd_derived.pivoted_lab`
    WHERE sodium > 99
    AND sodium <= 120)






