create database Hospital_Management_db;
use Hospital_Management_db;

-- Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_number VARCHAR(15)
    );
    
    truncate table  patients ;
    
    -- Doctors Table
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialty VARCHAR(50),
    contact_number VARCHAR(15)
);

select * from doctors;

-- Appointments Table
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

select * from appointments;

-- Prescriptions Table
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY,
    appointment_id INT,
    medication VARCHAR(50),
    dosage VARCHAR(20),
    instructions VARCHAR(50),
    FOREIGN KEY (appointment_id) 
    REFERENCES appointments(appointment_id)
);

select * from  prescriptions ;

-- 1)Find the average age of patients for each gender.
select gender,
	   avg(age) as Patients_avg_age
 from patients
 group by gender;

-- 2)List the top 5 doctors with the highest number of completed appointments.
select
    d.first_name as Doctors_FirstName,
    d.last_name as Doctors_LastName,
    DATE_FORMAT(appointment_date, '%Y-%m') as month,
    COUNT(*) as total_appointments
from
    appointments a
join doctors d 
               on a.doctor_id = d.doctor_id
group by Doctors_FirstName,
         Doctors_LastName,
         DATE_FORMAT(appointment_date, '%Y-%m')
order by 
	     month;
    
-- 3)Find the most commonly prescribed medication.
select
    medication,
    COUNT(*)  as prescription_count
from prescriptions
group by medication
order by prescription_count DESC
limit 1;

-- 4) Find doctors having specialty in Dermatology

select first_name,
       last_name,
       specialty
from doctors
    where specialty = 'Dermatology';

-- 5)Calculate the percentage of cancelled appointments for each doctor.
SELECT d.doctor_id,
       d.first_name,
       d.last_name,
COUNT(case when a.status = 'Cancelled' then
1 else NULL end) * 100.0 / COUNT(*) as cancel_percentage
FROM doctors d
JOIN
    appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY cancel_percentage DESC;

-- 6)Find the top 5 patients who have made the most appointments.
select p.first_name as Patients_FirstName,
       p.last_name as Patients_LaststName,
       count(a.appointment_id) as Total_appointments
from patients p
join appointments a on p.patient_id = a.patient_id 
     group by Patients_FirstName,
              Patients_LaststName
	 order by Total_appointments desc
     Limit 5 ;
     
-- 7)Calculate the average number of appointments completed for a doctor.
select 
      avg(Completed_appointments) as Avg_completed_appointments_per_doctor
    from
 (select 
      doctor_id,
      count(*) as Completed_appointments 
from appointments
      where status = 'Completed'
group by doctor_id)
      as Completed_data;
      
-- 8)List the medications that were prescribed more than 5 times in a month.
select p.medication as Medication,
       date_format(a.appointment_date, '%y-%m')  as Month,
       count(*) as Priscrition_Count
from prescriptions p 
       Join appointments a on p.appointment_id = a.appointment_id
       group by p.medication, Month
having count(*) > 5
	   order by  Priscrition_Count desc;
       
-- 9)Find the percentage of completed, canceled, and scheduled appointments 
--  for each month.
select date_format(appointment_date, '%Y-%M') as Month,
sum(case when status = 'completed' then 1 else 0 end)*100/count(*) as completed_percentage,
sum(case when status = 'cancelled' then 1 else 0 end)*100/count(*) as cancelled_percentage,
sum(case when status = 'Scheduled' then 1 else 0 end)*100/count(*) as Scheduled_percentage
    from appointments
group by Month ; 

-- 10)Identify which doctor has attended to the highest number of unique patients.
  select distinct d.first_name as Doctors_FirstName,
				  d.last_name as Doctors_LastName,
  count(*) as Unique_Patients 
  from appointments a 
  join patients p on a.patient_id = p.patient_id
  join doctors d on d.doctor_id = a.doctor_id
  group by d.first_name,d.last_name 
  order by Unique_Patients desc
  limit 1;

  -- 11)Find the number of patients who have visited 
  -- the hospital more than once in the past 6 months.
select
       p.first_name as Patients_FirstName,
       p.last_name as Patients_LastName,
    COUNT(*) as visit_count
from appointments a
right join patients p on a.patient_id = p.patient_id
where 
    appointment_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
group by  Patients_FirstName,Patients_LastName
having COUNT(*) > 1; 
    
-- 12) Find the Most Recent Appointment for among the Patients Using Subquery.
select *
   from appointments a
   where appointment_date = 
   (select 
       max(appointment_date) 
       from appointments a
	where patient_id = a.patient_id
    );
 
 -- 13)Calculate the Running Total of Appointments Per Month Using Window Functions.
 select
    DATE_FORMAT(appointment_date, '%Y-%m') as month,
    COUNT(*) as total_appointments,
SUM(COUNT(*)) over (ORDER BY DATE_FORMAT(appointment_date, '%Y-%m')) as running_total
from
    appointments
group by month
order by running_total DESC;
 
 -- 14)Find the First and Second Most Prescribed Medications Using Dense Rank
 
 select 
    medication,
    COUNT(*) as prescription_count,
   dense_rank() over (ORDER BY COUNT(*) DESC) as Rank_number
from
    prescriptions
group by
    medication 
LIMIT 2;

 
 
 
 
 
 
 
 
 
 
       
       
       
       